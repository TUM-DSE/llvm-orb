//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/CppAtomicToArmAtomic/CppAtomicToArmAtomic.h"
#include "mlir/Dialect/Orb/ArmAtomicDialect.h"
#include "mlir/Dialect/Orb/CppAtomicDialect.h"
#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/Pass/Pass.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/DialectConversion.h"
#include "llvm/ADT/SmallVector.h"
#include "mlir/IR/Region.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/WalkPatternRewriteDriver.h"


namespace mlir {
#define GEN_PASS_DEF_CONVERTCPPATOMICTOARMATOMICPASS
#include "mlir/Conversion/Passes.h.inc"
} // namespace mlir

using namespace mlir;

//===----------------------------------------------------------------------===//
// Rewrite patterns
//===----------------------------------------------------------------------===//

struct LoadRewriter : public OpConversionPattern<cpp_atomic::AtomicLoadOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(cpp_atomic::AtomicLoadOp loadOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    bool isDeref = false;
    bool isVolatile = loadOp.getIsVolatileAttr() != nullptr;

    Attribute eventId = loadOp->getAttr(orb::kEventIdAttr);
    auto newOp = rewriter.replaceOpWithNewOp<arm_atomic::AtomicLoadOp>(
        loadOp, loadOp.getResult().getType(), adaptor.getAddr(),
        arm_atomic::MemoryOrder::Relaxed, loadOp.getAlignment(), isDeref, isVolatile);   
    if (eventId)
      newOp->setAttr(orb::kEventIdAttr, eventId);
    return success();
  }
};

struct StoreRewriter : public OpConversionPattern<cpp_atomic::AtomicStoreOp> {

  StoreRewriter(MLIRContext *context) 
      : OpConversionPattern<cpp_atomic::AtomicStoreOp>(context) {}

  LogicalResult matchAndRewrite(cpp_atomic::AtomicStoreOp storeOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    bool isVolatile = storeOp.getIsVolatileAttr() != nullptr;

    Attribute eventId = storeOp->getAttr(orb::kEventIdAttr);
    auto newOp = rewriter.replaceOpWithNewOp<arm_atomic::AtomicStoreOp>(
        storeOp, adaptor.getValue(), adaptor.getAddr(),
        arm_atomic::MemoryOrder::Relaxed, storeOp.getAlignment(), isVolatile);
    if (eventId)
      newOp->setAttr(orb::kEventIdAttr, eventId);
    return success();
  }
};

struct FenceRewriter : public OpConversionPattern<cpp_atomic::AtomicFenceOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(cpp_atomic::AtomicFenceOp fenceOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    Attribute eventId = fenceOp->getAttr(orb::kEventIdAttr);

    StringAttr syncscope;
    if (auto scope = fenceOp.getSyncscope())
      syncscope = StringAttr::get(rewriter.getContext(), *scope);

    auto newOp = rewriter.replaceOpWithNewOp<arm_atomic::AtomicFenceOp>(
        fenceOp, arm_atomic::MemoryOrder::Relaxed, syncscope);
    if (eventId)
      newOp->setAttr(orb::kEventIdAttr, eventId);
    return success();
  }
};

void populateCppToArmPatterns(RewritePatternSet &patterns) {
  patterns.add<LoadRewriter>(patterns.getContext());
  patterns.add<StoreRewriter>(patterns.getContext());
  patterns.add<FenceRewriter>(patterns.getContext());
}

//===----------------------------------------------------------------------===//
// Pass Definition
//===----------------------------------------------------------------------===//

namespace {
class ConvertCppAtomicToArmAtomicPass : public impl::ConvertCppAtomicToArmAtomicPassBase<ConvertCppAtomicToArmAtomicPass> {
  using Base::Base;
  void runOnOperation() override;
};
}

void ConvertCppAtomicToArmAtomicPass::runOnOperation() {
    MLIRContext *context = &getContext();
    ConversionTarget target(*context);

    target.addLegalDialect<arm_atomic::ArmAtomicDialect>();
    target.addLegalOp<mlir::UnrealizedConversionCastOp>();
    target.addIllegalDialect<cpp_atomic::CppAtomicDialect>();

    RewritePatternSet patterns(context);

    populateCppToArmPatterns(patterns);

    if (failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
      signalPassFailure();

    // OrderAnalysis stores only stable event-ID pairs (no op pointers), so it
    // remains valid after ops are replaced.
    markAnalysesPreserved<orb::OrderAnalysis>();
}
