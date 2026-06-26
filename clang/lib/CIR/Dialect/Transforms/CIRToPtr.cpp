//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Partial lowering of CIR pointer operations to the ptr dialect. The pass
// converts pointer arithmetic and memory operations while preserving
// cir.alloca (which has MemoryEffects::Allocate) as the alias root.
// After lowering, LocalAliasAnalysis can trace through ptr.to_ptr
// (ViewLikeOpInterface) and ptr.ptr_add (ViewLikeOpInterface) back to the
// underlying cir.alloca to produce NoAlias results.
//
//===----------------------------------------------------------------------===//

#include "PassDetail.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Ptr/IR/PtrAttrs.h"
#include "mlir/Dialect/Ptr/IR/PtrDialect.h"
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/Dialect/Ptr/IR/PtrTypes.h"
#include "mlir/IR/BuiltinTypeInterfaces.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/DialectConversion.h"
#include "clang/CIR/Dialect/IR/CIRDialect.h"
#include "clang/CIR/Dialect/IR/CIROpsEnums.h"
#include "clang/CIR/Dialect/IR/CIRTypes.h"
#include "clang/CIR/Dialect/Passes.h"

using namespace mlir;
using namespace cir;

namespace mlir {
#define GEN_PASS_DEF_CIRTOPTR
#include "clang/CIR/Dialect/Passes.h.inc"
} // namespace mlir

//===----------------------------------------------------------------------===//
// Helpers
//===----------------------------------------------------------------------===//

static ptr::AtomicOrdering convertMemOrder(cir::MemOrder order) {
  switch (order) {
  case cir::MemOrder::Relaxed:
    return ptr::AtomicOrdering::monotonic;
  case cir::MemOrder::Consume:
  case cir::MemOrder::Acquire:
    return ptr::AtomicOrdering::acquire;
  case cir::MemOrder::Release:
    return ptr::AtomicOrdering::release;
  case cir::MemOrder::AcquireRelease:
    return ptr::AtomicOrdering::acq_rel;
  case cir::MemOrder::SequentiallyConsistent:
    return ptr::AtomicOrdering::seq_cst;
  }
  llvm_unreachable("unknown MemOrder");
}

//===----------------------------------------------------------------------===//
// Type converter
//===----------------------------------------------------------------------===//

static void populateCIRToPtrTypeConversions(TypeConverter &converter) {
  converter.addConversion([](Type t) { return t; });

  // !cir.ptr<T, space> -> !ptr.ptr<space>
  // The normalized default CIR address space is null; map it to generic_space.
  converter.addConversion([](cir::PointerType ptrTy) -> Type {
    auto addrSpace = ptrTy.getAddrSpace();
    if (!addrSpace)
      addrSpace = ptr::GenericSpaceAttr::get(ptrTy.getContext());
    return ptr::PtrType::get(addrSpace);
  });

  converter.addTargetMaterialization([](OpBuilder &b, ptr::PtrType dstTy,
                                 ValueRange inputs, Location loc) -> Value {
    if (inputs.size() != 1)
      return Value();
    if (!isa<cir::PointerType>(inputs[0].getType()))
      return Value();
    return ptr::ToPtrOp::create(b, loc, dstTy, inputs[0]).getResult();
  });

  converter.addSourceMaterialization([](OpBuilder &b, cir::PointerType srcTy,
                                 ValueRange inputs, Location loc) -> Value {
    if (inputs.size() != 1)
      return Value();
    if (!isa<ptr::PtrType>(inputs[0].getType()))
      return Value();
    return ptr::FromPtrOp::create(b, loc, srcTy, inputs[0]).getResult();
  });
}

//===----------------------------------------------------------------------===//
// Conversion patterns
//===----------------------------------------------------------------------===//

namespace {

/// cir.cast(array_to_ptrdecay, %src) -> identity on !ptr.ptr
/// Both !cir.ptr<!cir.array<T x N>> and !cir.ptr<T> map to the same
/// !ptr.ptr<space>, so the cast is a no-op.
struct CastArrayDecayLowering : public OpConversionPattern<cir::CastOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(cir::CastOp op, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    if (op.getKind() != cir::CastKind::array_to_ptrdecay)
      return failure();
    rewriter.replaceOp(op, adaptor.getSrc());
    return success();
  }
};

/// Cast a CIR integer value (signful) to a signless MLIR integer of the same
/// width using an unrealized conversion cast, so arith ops can consume it.
static Value castToSignlessInt(ConversionPatternRewriter &rewriter,
                               Location loc, Value cirInt) {
  auto cirIntTy = mlir::cast<cir::IntType>(cirInt.getType());
  auto signlessTy = mlir::IntegerType::get(cirInt.getContext(),
                                           cirIntTy.getWidth());
  return mlir::UnrealizedConversionCastOp::create(rewriter, loc,
                                                  signlessTy, cirInt)
      .getResult(0);
}

/// cir.get_element %base[%idx] -> ptr.ptr_add %base, (%idx * sizeof(elemTy))
struct GetElementLowering : public OpConversionPattern<cir::GetElementOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(cir::GetElementOp op, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    Location loc = op.getLoc();
    Type idxTy = rewriter.getIndexType();

    // Element type of the array being indexed.
    Type elemTy = op.getElementType();

    // Byte size of one element.
    Value sz = ptr::TypeOffsetOp::create(rewriter, loc, idxTy, elemTy);

    // The index may be a CIR integer; cast to signless before index_cast.
    Value index = adaptor.getIndex();
    if (isa<cir::IntType>(index.getType()))
      index = castToSignlessInt(rewriter, loc, index);
    Value iIdx = arith::IndexCastOp::create(rewriter, loc, idxTy, index);
    Value off = arith::MulIOp::create(rewriter, loc, iIdx, sz);

    rewriter.replaceOpWithNewOp<ptr::PtrAddOp>(op, adaptor.getBase(), off);
    return success();
  }
};

/// cir.ptr_stride %base, %stride -> ptr.ptr_add %base, (%stride * sizeof(pointeeTy))
struct PtrStrideLowering : public OpConversionPattern<cir::PtrStrideOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(cir::PtrStrideOp op, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    Location loc = op.getLoc();
    Type idxTy = rewriter.getIndexType();

    // Pointee type of the base pointer.
    Type elemTy = op.getElementType();

    // Byte size of one element.
    Value sz = ptr::TypeOffsetOp::create(rewriter, loc, idxTy, elemTy);

    // The stride may be a CIR integer; cast to signless before index_cast.
    Value stride = adaptor.getStride();
    if (isa<cir::IntType>(stride.getType()))
      stride = castToSignlessInt(rewriter, loc, stride);
    Value sIdx = arith::IndexCastOp::create(rewriter, loc, idxTy, stride);
    Value off = arith::MulIOp::create(rewriter, loc, sIdx, sz);

    rewriter.replaceOpWithNewOp<ptr::PtrAddOp>(op, adaptor.getBase(), off);
    return success();
  }
};

/// cir.load [volatile] [atomic(order)] %ptr -> ptr.load
struct LoadLowering : public OpConversionPattern<cir::LoadOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(cir::LoadOp op, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    Location loc = op.getLoc();
    ptr::AtomicOrdering ordering = ptr::AtomicOrdering::not_atomic;
    if (auto mo = op.getMemOrder())
      ordering = convertMemOrder(*mo);

    //FIXME: can cir atomics really have no alignment?
    std::optional<int64_t> align = op.getAlignment()
        ? std::optional<int64_t>(static_cast<int64_t>(*op.getAlignment()))
        : (ordering != ptr::AtomicOrdering::not_atomic
               ? std::optional<int64_t>(1)
               : std::optional<int64_t>(std::nullopt));
    bool isVolatile = op.getIsVolatile();

    Type resultTy = getTypeConverter()->convertType(op.getType());
    unsigned alignUnsigned = align ? static_cast<unsigned>(*align) : 0u;
    auto newLoad = ptr::LoadOp::create(rewriter, loc, resultTy,
                                       adaptor.getAddr(), alignUnsigned,
                                       isVolatile, /*nontemporal=*/false,
                                       /*invariant=*/false,
                                       /*invariantGroup=*/false,
                                       ordering, StringRef{});
    rewriter.replaceOp(op, newLoad.getResult());
    return success();
  }
};

/// cir.store [volatile] [atomic(order)] %val, %ptr -> ptr.store
struct StoreLowering : public OpConversionPattern<cir::StoreOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(cir::StoreOp op, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    Location loc = op.getLoc();
    ptr::AtomicOrdering ordering = ptr::AtomicOrdering::not_atomic;
    if (auto mo = op.getMemOrder())
      ordering = convertMemOrder(*mo);

    std::optional<int64_t> align = op.getAlignment()
        ? std::optional<int64_t>(static_cast<int64_t>(*op.getAlignment()))
        : (ordering != ptr::AtomicOrdering::not_atomic
               ? std::optional<int64_t>(1)
               : std::optional<int64_t>(std::nullopt));
    bool isVolatile = op.getIsVolatile();

    unsigned alignUnsigned = align ? static_cast<unsigned>(*align) : 0u;
    ptr::StoreOp::create(rewriter, loc, adaptor.getValue(), adaptor.getAddr(),
                         alignUnsigned, isVolatile, /*nontemporal=*/false,
                         /*invariantGroup=*/false, ordering, StringRef{});
    rewriter.eraseOp(op);
    return success();
  }
};

//===----------------------------------------------------------------------===//
// Pass
//===----------------------------------------------------------------------===//

struct CIRToPtrPass : public mlir::impl::CIRToPtrBase<CIRToPtrPass> {
  void runOnOperation() override {
    MLIRContext *ctx = &getContext();
    ConversionTarget target(*ctx);

    TypeConverter tc;
    populateCIRToPtrTypeConversions(tc);

    target.addLegalDialect<ptr::PtrDialect>();
    target.addLegalDialect<arith::ArithDialect>();
    target.addLegalDialect<cir::CIRDialect>();
    target.addLegalOp<mlir::UnrealizedConversionCastOp>();

    target.addDynamicallyLegalOp<cir::CastOp>([](cir::CastOp op) {
      return op.getKind() != cir::CastKind::array_to_ptrdecay;
    });

    target.addIllegalOp<cir::GetElementOp, cir::PtrStrideOp>();
    target.addIllegalOp<cir::LoadOp, cir::StoreOp>();

    RewritePatternSet patterns(ctx);
    patterns.add<CastArrayDecayLowering, GetElementLowering, PtrStrideLowering,
                 LoadLowering, StoreLowering>(tc, ctx);

    if (failed(applyPartialConversion(getOperation(), target,
                                      std::move(patterns))))
      signalPassFailure();
  }
};

} // namespace

std::unique_ptr<mlir::Pass> mlir::createCIRToPtrPass() {
  return std::make_unique<CIRToPtrPass>();
}
