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
#include "mlir/Conversion/LLVMCommon/TypeConverter.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/LLVMIR/LLVMTypes.h"
#include "mlir/Dialect/Ptr/IR/PtrAttrs.h"
#include "mlir/Dialect/Ptr/IR/PtrDialect.h"
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/Dialect/Ptr/IR/PtrTypes.h"
#include "mlir/IR/BuiltinTypeInterfaces.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/DataLayoutInterfaces.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "clang/CIR/Dialect/IR/CIRDialect.h"
#include "clang/CIR/Dialect/IR/CIROpsEnums.h"
#include "clang/CIR/Dialect/IR/CIRTypes.h"
#include "clang/CIR/Dialect/Passes.h"
#include "clang/CIR/LoweringHelpers.h"

using namespace mlir;
using namespace cir;

namespace mlir {
#define GEN_PASS_DEF_CIRTOPTR
#define GEN_PASS_DEF_CIRORBCLEANUP
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

// Populate all CIR→LLVM type conversions (shared with ConvertCIRToLLVMPass),
// then override cir::PointerType to produce ptr::PtrType instead of llvm.ptr.
static void populateCIRToPtrTypeConversions(mlir::LLVMTypeConverter &converter,
                                            mlir::DataLayout &dataLayout) {
  populateCIRTypeConversions(converter, dataLayout);

  // Override: !cir.ptr<T, space> -> !ptr.ptr<space> (takes priority over LLVM)
  converter.addConversion([](cir::PointerType ptrTy) -> Type {
    auto addrSpace = ptrTy.getAddrSpace();
    if (!addrSpace)
      addrSpace = ptr::GenericSpaceAttr::get(ptrTy.getContext());
    return ptr::PtrType::get(addrSpace);
  });

  converter.addTargetMaterialization([](OpBuilder &b, ptr::PtrType dstTy,
                                        ValueRange inputs,
                                        Location loc) -> Value {
    if (inputs.size() != 1)
      return Value();
    if (!isa<cir::PointerType>(inputs[0].getType()))
      return Value();
    return ptr::ToPtrOp::create(b, loc, dstTy, inputs[0]).getResult();
  });

  converter.addSourceMaterialization([](OpBuilder &b, cir::PointerType srcTy,
                                        ValueRange inputs,
                                        Location loc) -> Value {
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

/// cir.alloca -> llvm.alloca + ptr.to_ptr(!llvm.ptr -> !ptr.ptr<space>)
/// Converts alloca directly to LLVM so the alias analysis chain is clean:
///   llvm.alloca -> ptr.to_ptr (ViewLikeOpInterface) -> ptr.load/store
struct AllocaLowering : public OpConversionPattern<cir::AllocaOp> {
  mlir::DataLayout const &dataLayout;

  AllocaLowering(const mlir::TypeConverter &tc, mlir::MLIRContext *ctx,
                 mlir::DataLayout const &dl)
      : OpConversionPattern(tc, ctx), dataLayout(dl) {}

  LogicalResult matchAndRewrite(cir::AllocaOp op, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    MLIRContext *ctx = op.getContext();
    Location loc = op.getLoc();

    // Array size: dynamic value or constant 1.
    Type sizeTy = getTypeConverter()->convertType(rewriter.getIndexType());
    Value size = op.isDynamic()
        ? adaptor.getDynAllocSize()
        : mlir::LLVM::ConstantOp::create(rewriter, loc, sizeTy, 1).getResult();

    // Element type to allocate.
    Type elemTy = convertTypeForMemory(*getTypeConverter(), dataLayout,
                                      op.getAllocaType());

    // llvm.alloca always produces !llvm.ptr (address space 0 for locals).
    Type llvmPtrTy = mlir::LLVM::LLVMPointerType::get(ctx, 0);
    Value alloca = mlir::LLVM::AllocaOp::create(
        rewriter, loc, llvmPtrTy, elemTy, size,
        static_cast<unsigned>(op.getAlignment())).getResult();

    // Wrap in ptr.to_ptr(!llvm.ptr -> !ptr.ptr<#ptr.generic_space>).
    // AS 0 on llvm.ptr maps to GenericSpaceAttr (see LLVMPointerType::getMemorySpace).
    Type ptrPtrTy = ptr::PtrType::get(ptr::GenericSpaceAttr::get(ctx));
    rewriter.replaceOpWithNewOp<ptr::ToPtrOp>(op, ptrPtrTy, alloca);
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

    mlir::LLVMTypeConverter tc(ctx);
    mlir::DataLayout dl(getOperation());
    populateCIRToPtrTypeConversions(tc, dl);

    target.addLegalDialect<ptr::PtrDialect>();
    target.addLegalDialect<arith::ArithDialect>();
    target.addLegalDialect<cir::CIRDialect>();
    target.addLegalDialect<mlir::LLVM::LLVMDialect>();
    target.addLegalOp<mlir::UnrealizedConversionCastOp>();

    target.addDynamicallyLegalOp<cir::CastOp>([](cir::CastOp op) {
      return op.getKind() != cir::CastKind::array_to_ptrdecay;
    });

    target.addIllegalOp<cir::GetElementOp, cir::PtrStrideOp>();
    target.addIllegalOp<cir::LoadOp, cir::StoreOp>();
    target.addIllegalOp<cir::AllocaOp>();

    RewritePatternSet patterns(ctx);
    patterns.add<AllocaLowering>(tc, ctx, dl);
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

//===----------------------------------------------------------------------===//
// CIROrbCleanupPass
//===----------------------------------------------------------------------===//

namespace {

/// Collapses:
///   %cir = ptr.from_ptr %ptrptr : <space> -> !cir.ptr<T>
///   %llvm = unrealized_cast %cir : !cir.ptr<T> -> !llvm.ptr
/// into:
///   %llvm = ptr.from_ptr %ptrptr : <space> -> !llvm.ptr
struct CleanupFromPtrCastPattern
    : public mlir::OpRewritePattern<mlir::UnrealizedConversionCastOp> {
  using OpRewritePattern::OpRewritePattern;

  mlir::LogicalResult
  matchAndRewrite(mlir::UnrealizedConversionCastOp castOp,
                  mlir::PatternRewriter &rewriter) const override {
    if (castOp.getNumOperands() != 1 || castOp.getNumResults() != 1)
      return failure();
    if (!mlir::isa<mlir::LLVM::LLVMPointerType>(castOp.getType(0)))
      return failure();
    auto fromPtr =
        castOp.getOperand(0).getDefiningOp<mlir::ptr::FromPtrOp>();
    if (!fromPtr)
      return failure();
    rewriter.replaceOpWithNewOp<mlir::ptr::FromPtrOp>(
        castOp, mlir::LLVM::LLVMPointerType::get(rewriter.getContext()),
        fromPtr.getPtr());
    return success();
  }
};

/// After CleanupFromPtrCastPattern runs, we may have:
///   ptr.from_ptr(ptr.to_ptr(%llvm_ptr : !llvm.ptr)) -> !llvm.ptr
/// or:
///   ptr.from_ptr(ptr.to_ptr(unrealized_cast(%llvm_ptr : !llvm.ptr -> T))) -> !llvm.ptr
/// Both reduce to %llvm_ptr.
struct CleanupFromPtrViaToPtrPattern
    : public mlir::OpRewritePattern<mlir::ptr::FromPtrOp> {
  using OpRewritePattern::OpRewritePattern;

  mlir::LogicalResult
  matchAndRewrite(mlir::ptr::FromPtrOp fromPtrOp,
                  mlir::PatternRewriter &rewriter) const override {
    if (!mlir::isa<mlir::LLVM::LLVMPointerType>(fromPtrOp.getType()))
      return failure();
    auto toPtr = fromPtrOp.getPtr().getDefiningOp<mlir::ptr::ToPtrOp>();
    if (!toPtr)
      return failure();
    mlir::Value input = toPtr.getPtr();
    // Direct !llvm.ptr -> forward it
    if (mlir::isa<mlir::LLVM::LLVMPointerType>(input.getType())) {
      rewriter.replaceOp(fromPtrOp, input);
      return success();
    }
    // unrealized_cast(%llvm_ptr : !llvm.ptr -> T) -> forward the cast's input
    auto cast = input.getDefiningOp<mlir::UnrealizedConversionCastOp>();
    if (cast && cast.getNumOperands() == 1 &&
        mlir::isa<mlir::LLVM::LLVMPointerType>(cast.getOperand(0).getType())) {
      rewriter.replaceOp(fromPtrOp, cast.getOperand(0));
      return success();
    }
    return failure();
  }
};

/// Collapses:
///   %cir = unrealized_cast %llvm_ptr : !llvm.ptr -> !cir.ptr<T>
///   %ptrptr = ptr.to_ptr %cir : !cir.ptr<T> -> <space>
/// into:
///   %ptrptr = ptr.to_ptr %llvm_ptr : !llvm.ptr -> <space>
struct CleanupToPtrCastPattern
    : public mlir::OpRewritePattern<mlir::ptr::ToPtrOp> {
  using OpRewritePattern::OpRewritePattern;

  mlir::LogicalResult matchAndRewrite(mlir::ptr::ToPtrOp toPtrOp,
                                      mlir::PatternRewriter &rewriter) const override {
    auto cast = toPtrOp.getPtr().getDefiningOp<mlir::UnrealizedConversionCastOp>();
    if (!cast || cast.getNumOperands() != 1 || cast.getNumResults() != 1)
      return failure();
    if (!mlir::isa<mlir::LLVM::LLVMPointerType>(cast.getOperand(0).getType()))
      return failure();
    rewriter.replaceOpWithNewOp<mlir::ptr::ToPtrOp>(
        toPtrOp, toPtrOp.getType(), cast.getOperand(0));
    return success();
  }
};

struct CIROrbCleanupPass : public mlir::impl::CIROrbCleanupBase<CIROrbCleanupPass> {
  void runOnOperation() override {
    mlir::RewritePatternSet patterns(&getContext());
    patterns.add<CleanupFromPtrCastPattern>(&getContext());
    patterns.add<CleanupFromPtrViaToPtrPattern>(&getContext());
    patterns.add<CleanupToPtrCastPattern>(&getContext());
    if (failed(mlir::applyPatternsGreedily(getOperation(),
                                           std::move(patterns))))
      signalPassFailure();
  }
};

} // namespace

std::unique_ptr<mlir::Pass> mlir::createCIROrbCleanupPass() {
  return std::make_unique<CIROrbCleanupPass>();
}
