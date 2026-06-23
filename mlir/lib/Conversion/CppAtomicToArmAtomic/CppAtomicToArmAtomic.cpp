//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "PassDetail.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Region.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/WalkPatternRewriteDriver.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Dialect/Orb/CppAtomicDialect.h"
#include "mlir/Dialect/Orb/ArmAtomicDialect.h"
#include "clang/CIR/Dialect/IR/CIRDialect.h"
#include "clang/CIR/Dialect/Passes.h"
#include "llvm/ADT/SmallVector.h"

using namespace mlir;

namespace mlir {
#define GEN_PASS_DEF_CPPATOMICTOARMATOMIC
#include "mlir/Conversion/Passes.h.inc"
} // namespace mlir

//===----------------------------------------------------------------------===//
// Rewrite patterns
//===----------------------------------------------------------------------===//

namespace {

static arm_atomic::MemoryOrder convertLoadMemoryOrder(cpp_atomic::MemoryOrder cppOrder) {
  switch (cppOrder) {
    case cpp_atomic::MemoryOrder::Relaxed: return arm_atomic::MemoryOrder::Relaxed;
    case cpp_atomic::MemoryOrder::Acquire: return arm_atomic::MemoryOrder::Acquire;
    
    case cpp_atomic::MemoryOrder::Release: 
    case cpp_atomic::MemoryOrder::AcqRel: 
    case cpp_atomic::MemoryOrder::SeqCst: 
    default:
      return arm_atomic::MemoryOrder::Acquire;
  }
}


static arm_atomic::MemoryOrder convertStoreMemoryOrder(cpp_atomic::MemoryOrder cppOrder) {
  switch (cppOrder) {
    case cpp_atomic::MemoryOrder::Relaxed: return arm_atomic::MemoryOrder::Relaxed;
    case cpp_atomic::MemoryOrder::Release: return arm_atomic::MemoryOrder::Release;

    case cpp_atomic::MemoryOrder::Acquire: 
    case cpp_atomic::MemoryOrder::AcqRel: 
    case cpp_atomic::MemoryOrder::SeqCst: 
    default:
      return arm_atomic::MemoryOrder::Release;
  }
}

struct LoadRewriter : public OpConversionPattern<cpp_atomic::AtomicLoadOp> {

  LoadRewriter(MLIRContext *context) 
      : OpConversionPattern<cpp_atomic::AtomicLoadOp>(context) {}

  LogicalResult matchAndRewrite(cpp_atomic::AtomicLoadOp loadOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    Value addr = adaptor.getAddr();
    
    auto memOrder = convertLoadMemoryOrder(loadOp.getMemoryOrder());
    auto alignment = loadOp.getAlignmentAttr();

    rewriter.replaceOpWithNewOp<arm_atomic::AtomicLoadOp>(loadOp, addr, memOrder, alignment);
    return success();
  }
};

struct StoreRewriter : public OpConversionPattern<cpp_atomic::AtomicStoreOp> {

  StoreRewriter(MLIRContext *context) 
      : OpConversionPattern<cpp_atomic::AtomicStoreOp>(context) {}

  LogicalResult matchAndRewrite(cpp_atomic::AtomicStoreOp storeOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    Value value = adaptor.getValue();
    Value addr = adaptor.getAddr();
    
    auto memOrder = convertStoreMemoryOrder(storeOp.getMemoryOrder());
    auto alignment = storeOp.getAlignmentAttr();

    rewriter.replaceOpWithNewOp<arm_atomic::AtomicStoreOp>(storeOp, value, addr, memOrder, alignment);
    return success();
  }
};

void populateCIRToCppAtomicPatterns(RewritePatternSet &patterns) {
  patterns.add<LoadRewriter>(patterns.getContext());
  patterns.add<StoreRewriter>(patterns.getContext());
}

//===----------------------------------------------------------------------===//
// Pass Definition
//===----------------------------------------------------------------------===//

struct CppAtomicToArmAtomicPass : public impl::CppAtomicToArmAtomicBase<CppAtomicToArmAtomicPass> {
    CppAtomicToArmAtomicPass() = default;
    void runOnOperation() override;
};    
  
void CppAtomicToArmAtomicPass::runOnOperation() {
    MLIRContext *context = &getContext();
    ConversionTarget target(*context);
    
    target.addLegalDialect<arm_atomic::ArmAtomicDialect>();
    target.addLegalOp<mlir::UnrealizedConversionCastOp>();
    target.addIllegalOp<cpp_atomic::AtomicLoadOp, cpp_atomic::AtomicStoreOp>();

    RewritePatternSet patterns(context);

    populateCIRToCppAtomicPatterns(patterns);

    if (failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
      signalPassFailure();
  }

} // namespace

std::unique_ptr<Pass> mlir::createCppAtomicToArmAtomicPass() {
  return std::make_unique<CppAtomicToArmAtomicPass>();
}