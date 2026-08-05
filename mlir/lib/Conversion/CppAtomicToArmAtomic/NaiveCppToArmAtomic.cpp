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


namespace mlir {
#define GEN_PASS_DEF_CONVERTCPPATOMICTOARMATOMICNAIVEPASS
#include "mlir/Conversion/Passes.h.inc"
} // namespace mlir

using namespace mlir;

//===----------------------------------------------------------------------===//
// Rewrite patterns
//===----------------------------------------------------------------------===//

static arm_atomic::MemoryOrder convertLoadMemoryOrder(cpp_atomic::MemoryOrder cppOrder) {
  switch (cppOrder) {
    case cpp_atomic::MemoryOrder::Relaxed: return arm_atomic::MemoryOrder::Relaxed;
     
    case cpp_atomic::MemoryOrder::Acquire:
      return arm_atomic::MemoryOrder::AcquirePC;
    case cpp_atomic::MemoryOrder::SeqCst: 
      return arm_atomic::MemoryOrder::Acquire;
    default:
      llvm_unreachable("Unknown CppAtomic memory order for atomic_load");
  }
}


static arm_atomic::MemoryOrder convertStoreMemoryOrder(cpp_atomic::MemoryOrder cppOrder) {
  switch (cppOrder) {
    case cpp_atomic::MemoryOrder::Relaxed: return arm_atomic::MemoryOrder::Relaxed;

    case cpp_atomic::MemoryOrder::Release:
    case cpp_atomic::MemoryOrder::SeqCst: 
      return arm_atomic::MemoryOrder::Release;
    default:
      llvm_unreachable("Unknown CppAtomic memory order for atomic_store");
  }
}

static arm_atomic::MemoryOrder convertFenceMemoryOrder(cpp_atomic::MemoryOrder cppOrder) {
  switch (cppOrder) {
    case cpp_atomic::MemoryOrder::Relaxed: return arm_atomic::MemoryOrder::Relaxed;
    case cpp_atomic::MemoryOrder::Acquire: return arm_atomic::MemoryOrder::Acquire;

    case cpp_atomic::MemoryOrder::Release:
    case cpp_atomic::MemoryOrder::AcqRel:
    case cpp_atomic::MemoryOrder::SeqCst:
      return arm_atomic::MemoryOrder::AcqRel;
    default:
      llvm_unreachable("Unknown CppAtomic memory order for fence");
  }
}

namespace {

  struct LoadRewriter : public OpConversionPattern<cpp_atomic::AtomicLoadOp> {

    LoadRewriter(MLIRContext *context) 
        : OpConversionPattern<cpp_atomic::AtomicLoadOp>(context) {}

    LogicalResult matchAndRewrite(cpp_atomic::AtomicLoadOp loadOp, OpAdaptor adaptor,
                                  ConversionPatternRewriter &rewriter) const override {
      
      auto memOrder = convertLoadMemoryOrder(loadOp.getMemoryOrder());

      bool isDeref = loadOp.getIsDerefAttr() != nullptr;
      bool isVolatile = loadOp.getIsVolatileAttr() != nullptr;  

      Attribute eventId = loadOp->getAttr(orb::kEventIdAttr);

      auto newOp = rewriter.replaceOpWithNewOp<arm_atomic::AtomicLoadOp>(
          loadOp, loadOp.getResult().getType(), adaptor.getAddr(), 
          memOrder, loadOp.getAlignment(), isDeref, isVolatile);
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
      
      auto memOrder = convertStoreMemoryOrder(storeOp.getMemoryOrder());

      bool isVolatile = storeOp.getIsVolatileAttr() != nullptr;  

      Attribute eventId = storeOp->getAttr(orb::kEventIdAttr);
      auto newOp = rewriter.replaceOpWithNewOp<arm_atomic::AtomicStoreOp>(
        storeOp, adaptor.getValue(), adaptor.getAddr(), 
        memOrder, storeOp.getAlignment(), isVolatile);
      if (eventId)
        newOp->setAttr(orb::kEventIdAttr, eventId);  
      return success();
    }
  };

  struct FenceRewriter : public OpConversionPattern<cpp_atomic::AtomicFenceOp> {

    FenceRewriter(MLIRContext *context) 
        : OpConversionPattern<cpp_atomic::AtomicFenceOp>(context) {}

    LogicalResult matchAndRewrite(cpp_atomic::AtomicFenceOp fenceOp, OpAdaptor adaptor,
                                  ConversionPatternRewriter &rewriter) const override {
                                  
      auto memOrder = convertFenceMemoryOrder(fenceOp.getMemoryOrder());

      Attribute eventId = fenceOp->getAttr(orb::kEventIdAttr);

      StringAttr syncscope;
      if (auto scope = fenceOp.getSyncscope())
        syncscope = StringAttr::get(rewriter.getContext(), *scope);

      auto newOp = rewriter.replaceOpWithNewOp<arm_atomic::AtomicFenceOp>(
        fenceOp, memOrder, syncscope);
      if (eventId)
        newOp->setAttr(orb::kEventIdAttr, eventId);
      return success();
    }
  };

}

void populateNaiveCppToArmPatterns(RewritePatternSet &patterns) {
  patterns.add<LoadRewriter>(patterns.getContext());
  patterns.add<StoreRewriter>(patterns.getContext());
  patterns.add<FenceRewriter>(patterns.getContext());
}

//===----------------------------------------------------------------------===//
// Pass Definition
//===----------------------------------------------------------------------===//

namespace {
class ConvertCppAtomicToArmAtomicNaivePass : public impl::ConvertCppAtomicToArmAtomicNaivePassBase<ConvertCppAtomicToArmAtomicNaivePass> {
  using Base::Base;
  void runOnOperation() override;
};
}

void ConvertCppAtomicToArmAtomicNaivePass::runOnOperation() {
    MLIRContext *context = &getContext();
    ConversionTarget target(*context);

    target.addLegalDialect<arm_atomic::ArmAtomicDialect>();
    target.addLegalOp<mlir::UnrealizedConversionCastOp>();
    target.addIllegalDialect<cpp_atomic::CppAtomicDialect>();

    RewritePatternSet patterns(context);

    populateNaiveCppToArmPatterns(patterns);

    if (failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
      signalPassFailure();

    // OrderAnalysis stores only stable event-ID pairs (no op pointers), so it
    // remains valid after ops are replaced.
    markAnalysesPreserved<orb::OrderAnalysis>();
}
