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

struct LoadRewriter : public OpConversionPattern<cir::LoadOp> {

  LoadRewriter(MLIRContext *context)
      : OpConversionPattern<cir::LoadOp>(context) {}

  LogicalResult matchAndRewrite(cir::LoadOp loadOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {

    Value addr = adaptor.getAddr();

    auto memOrder = convertMemoryOrder(loadOp.getMemOrder());
    auto alignment = loadOp.getAlignmentAttr();

    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicLoadOp>(loadOp, addr, memOrder, alignment);
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
    auto alignment = storeOp.getAlignmentAttr();

    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicStoreOp>(storeOp, value, addr, memOrder, alignment);
    return success();
  }
};

struct FenceRewriter : public OpConversionPattern<cir::AtomicFenceOp> {

  FenceRewriter(MLIRContext *context)
      : OpConversionPattern<cir::AtomicFenceOp>(context) {}

  LogicalResult matchAndRewrite(cir::AtomicFenceOp fenceOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    

    auto memOrder = convertMemoryOrder(std::make_optional(fenceOp.getOrdering()));
    
    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicFenceOp>(fenceOp, memOrder);
    
    return success();
  }
};  

void populateCIRToCppAtomicPatterns(RewritePatternSet &patterns) {
  patterns.add<LoadRewriter>(patterns.getContext());
  patterns.add<StoreRewriter>(patterns.getContext());
  patterns.add<FenceRewriter>(patterns.getContext());
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

  RewritePatternSet patterns(context);

  populateCIRToCppAtomicPatterns(patterns);

  if (failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
    signalPassFailure();
}

} // namespace

std::unique_ptr<Pass> mlir::createCIRToCppAtomicPass() {
  return std::make_unique<CIRToCppAtomicPass>();
}
