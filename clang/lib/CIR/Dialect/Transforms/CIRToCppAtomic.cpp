//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "PassDetail.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Orb/CppAtomicDialect.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Region.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/WalkPatternRewriteDriver.h"
#include "mlir/Transforms/DialectConversion.h"
#include "clang/CIR/Dialect/IR/CIRDialect.h"
#include "clang/CIR/Dialect/Passes.h"
#include "llvm/ADT/SmallVector.h"

using namespace mlir;
using namespace cir;

namespace mlir {
#define GEN_PASS_DEF_CIRTOCPPATOMIC
#include "clang/CIR/Dialect/Passes.h.inc"
} // namespace mlir

//===----------------------------------------------------------------------===//
// Rewrite patterns
//===----------------------------------------------------------------------===//

namespace {

static cpp_atomic::MemoryOrder convertMemoryOrder(std::optional<cir::MemOrder> cirOrder) {

  switch (cirOrder.value()) {
    case cir::MemOrder::Relaxed: return cpp_atomic::MemoryOrder::Relaxed;
    case cir::MemOrder::Acquire: return cpp_atomic::MemoryOrder::Acquire;
    case cir::MemOrder::Release: return cpp_atomic::MemoryOrder::Release;
    case cir::MemOrder::AcquireRelease: return cpp_atomic::MemoryOrder::AcqRel;
    case cir::MemOrder::SequentiallyConsistent: return cpp_atomic::MemoryOrder::SeqCst;
    default:
      llvm_unreachable("Unknown memory order");
  }
}


static cpp_atomic::MemoryOrder convertFenceMemoryOrder(cir::MemOrder cirOrder) {
  
  switch (cirOrder) {
    case cir::MemOrder::Relaxed: return cpp_atomic::MemoryOrder::Relaxed;
    case cir::MemOrder::Acquire: return cpp_atomic::MemoryOrder::Acquire;
    case cir::MemOrder::Release: return cpp_atomic::MemoryOrder::Release;
    case cir::MemOrder::AcquireRelease: return cpp_atomic::MemoryOrder::AcqRel;
    case cir::MemOrder::SequentiallyConsistent: return cpp_atomic::MemoryOrder::SeqCst;
    default:
    llvm_unreachable("Unknown memory order");
  }
}

static cpp_atomic::BinOp convertBinOp(cir::AtomicFetchKind kind) {
  switch (kind) {
    case cir::AtomicFetchKind::Add: return cpp_atomic::BinOp::Add;
    case cir::AtomicFetchKind::Sub: return cpp_atomic::BinOp::Sub;
    case cir::AtomicFetchKind::And: return cpp_atomic::BinOp::And;
    case cir::AtomicFetchKind::Or:  return cpp_atomic::BinOp::Or;
    case cir::AtomicFetchKind::Xor: return cpp_atomic::BinOp::Xor;
    case cir::AtomicFetchKind::Nand: return cpp_atomic::BinOp::Nand;
    case cir::AtomicFetchKind::Max: return cpp_atomic::BinOp::Max;
    case cir::AtomicFetchKind::Min: return cpp_atomic::BinOp::Min;
    default: 
      llvm_unreachable("Unsupported CIR atomic fetch kind");
  }
}

struct LoadRewriter : public OpConversionPattern<cir::LoadOp> {

  LoadRewriter(MLIRContext *context)
      : OpConversionPattern<cir::LoadOp>(context) {}

  LogicalResult matchAndRewrite(cir::LoadOp loadOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {

    Value addr = adaptor.getAddr();

    auto memOrder = convertMemoryOrder(loadOp.getMemOrder());

    unsigned align = loadOp.getAlignmentAttr() 
                     ? static_cast<unsigned>(*loadOp.getAlignment()) : 0;

    if (align == 0) {
      return rewriter.notifyMatchFailure(
          loadOp, "Atomic operations strictly require a non-zero alignment.");
    }

    bool isDeref = loadOp.getIsDerefAttr() != nullptr;
    bool isVolatile = loadOp.getIsVolatileAttr() != nullptr;

    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicLoadOp>(loadOp, addr, memOrder, align, isDeref, isVolatile);
    return success();
  }
};

struct StoreRewriter : public OpConversionPattern<cir::StoreOp> {

  StoreRewriter(MLIRContext *context)
      : OpConversionPattern<cir::StoreOp>(context) {}

  LogicalResult matchAndRewrite(cir::StoreOp storeOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {

    Value value = adaptor.getValue();
    Value addr = adaptor.getAddr();

    auto memOrder = convertMemoryOrder(storeOp.getMemOrder());

    unsigned align = storeOp.getAlignmentAttr() 
                     ? static_cast<unsigned>(*storeOp.getAlignment()) : 0;

    if (align == 0) {
      return rewriter.notifyMatchFailure(
          storeOp, "Atomic operations strictly require a non-zero alignment.");
    }

    bool isVolatile = storeOp.getIsVolatileAttr() != nullptr;

    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicStoreOp>(storeOp, value, addr, memOrder, align, isVolatile);
    return success();
  }
};

struct FenceRewriter : public OpConversionPattern<cir::AtomicFenceOp> {

  FenceRewriter(MLIRContext *context)
      : OpConversionPattern<cir::AtomicFenceOp>(context) {}

  LogicalResult matchAndRewrite(cir::AtomicFenceOp fenceOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    

    auto memOrder = convertFenceMemoryOrder(fenceOp.getOrdering());
    
    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicFenceOp>(fenceOp, memOrder);
    
    return success();
  }
};

struct CmpXchgRewriter : public OpConversionPattern<cir::AtomicCmpXchgOp> {

  CmpXchgRewriter(MLIRContext *context)
      : OpConversionPattern<cir::AtomicCmpXchgOp>(context) {}

  LogicalResult matchAndRewrite(cir::AtomicCmpXchgOp cmpOp, OpAdaptor adaptor,
                              ConversionPatternRewriter &rewriter) const override {

    auto successOrder = convertMemoryOrder(cmpOp.getSuccOrder());
    auto failureOrder = convertMemoryOrder(cmpOp.getFailOrder());

    unsigned align = cmpOp.getAlignmentAttr() 
                    ? static_cast<unsigned>(*cmpOp.getAlignment()) : 0;
    
    if (align == 0) {
      return rewriter.notifyMatchFailure(
        cmpOp, "Atomic operations strictly require a non-zero alignment.");
      }
      
    bool isWeak = cmpOp.getWeakAttr() != nullptr;
    bool isVolatile = cmpOp.getIsVolatileAttr() != nullptr;


    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicCmpXchgOp>(
        cmpOp, 
        adaptor.getPtr(),
        adaptor.getExpected(), 
        adaptor.getDesired(), 
        successOrder, 
        failureOrder, 
        align,
        isWeak,   
        isVolatile
    );
      
    return success();
  }
};

struct FetchRewriter : public mlir::OpConversionPattern<cir::AtomicFetchOp> {
  
  FetchRewriter(MLIRContext *context)
      : OpConversionPattern<cir::AtomicFetchOp>(context) {}

  LogicalResult matchAndRewrite(cir::AtomicFetchOp fetchOp, OpAdaptor adaptor,
                              ConversionPatternRewriter &rewriter) const override {

    auto memOrder = convertMemoryOrder(fetchOp.getMemOrder());
    auto binOp = convertBinOp(fetchOp.getBinop());

    bool isVolatile = fetchOp.getIsVolatileAttr() != nullptr;
    bool fetchFirst = fetchOp.getFetchFirstAttr() != nullptr;

    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicFetchOp>(
        fetchOp,
        adaptor.getVal(),
        adaptor.getPtr(),
        binOp,
        memOrder,
        isVolatile,
        fetchFirst
    );

    return success();
  }
};

struct XchgRewriter : public OpConversionPattern<cir::AtomicXchgOp> {

  XchgRewriter(MLIRContext *context)
      : OpConversionPattern<cir::AtomicXchgOp>(context) {}

  LogicalResult matchAndRewrite(cir::AtomicXchgOp xchgOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
                                
    auto memOrder = convertFenceMemoryOrder(xchgOp.getMemOrder()); 
    bool isVolatile = xchgOp.getIsVolatileAttr() != nullptr;

    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicXchgOp>(
        xchgOp,
        adaptor.getVal(), 
        adaptor.getPtr(),
        memOrder,
        isVolatile
    );
    return success();
  }
};

void populateCIRToCppAtomicPatterns(RewritePatternSet &patterns) {
  patterns.add<LoadRewriter>(patterns.getContext());
  patterns.add<StoreRewriter>(patterns.getContext());
  patterns.add<FenceRewriter>(patterns.getContext());
  patterns.add<CmpXchgRewriter>(patterns.getContext());
  patterns.add<FetchRewriter>(patterns.getContext());
  patterns.add<XchgRewriter>(patterns.getContext());
}

//===----------------------------------------------------------------------===//
// Pass definition
// ===----------------------------------------------------------------------===//

struct CIRToCppAtomicPass : public impl::CIRToCppAtomicBase<CIRToCppAtomicPass> {
  CIRToCppAtomicPass() = default;
  void runOnOperation() override;
};

void CIRToCppAtomicPass::runOnOperation() {
  MLIRContext *context = &getContext();
  ConversionTarget target(*context);

  target.addLegalDialect<cpp_atomic::CppAtomicDialect>();
  target.addLegalOp<mlir::UnrealizedConversionCastOp>();

  target.addDynamicallyLegalOp<cir::LoadOp>([](cir::LoadOp op) { return !op.getMemOrder().has_value(); });
  target.addDynamicallyLegalOp<cir::StoreOp>([](cir::StoreOp op) { return !op.getMemOrder().has_value(); });

  target.addIllegalOp<cir::AtomicFenceOp>();
  target.addIllegalOp<cir::AtomicCmpXchgOp>();
  target.addIllegalOp<cir::AtomicFetchOp>();
  target.addIllegalOp<cir::AtomicXchgOp>();

  RewritePatternSet patterns(context);

  populateCIRToCppAtomicPatterns(patterns);

  if (failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
    signalPassFailure();
}

} // namespace

std::unique_ptr<Pass> mlir::createCIRToCppAtomicPass() {
  return std::make_unique<CIRToCppAtomicPass>();
}
