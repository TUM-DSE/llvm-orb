//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Converts ptr.load/ptr.store with atomic ordering to cpp_atomic dialect ops,
// and converts cir.atomic_fence to cpp_atomic.atomic_fence.
// Run this pass after cir-to-ptr so that all CIR loads/stores are already
// lowered to ptr dialect.
//
//===----------------------------------------------------------------------===//

#include "PassDetail.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Orb/CppAtomicDialect.h"
#include "mlir/Dialect/Ptr/IR/PtrAttrs.h"
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/DialectConversion.h"
#include "clang/CIR/Dialect/IR/CIRDialect.h"
#include "clang/CIR/Dialect/Passes.h"

using namespace mlir;

namespace mlir {
#define GEN_PASS_DEF_CIRTOCPPATOMIC
#include "clang/CIR/Dialect/Passes.h.inc"
} // namespace mlir

//===----------------------------------------------------------------------===//
// Helpers
//===----------------------------------------------------------------------===//

namespace {

static cpp_atomic::MemoryOrder convertPtrOrder(ptr::AtomicOrdering ord) {
  switch (ord) {
  case ptr::AtomicOrdering::monotonic:
    return cpp_atomic::MemoryOrder::Relaxed;
  case ptr::AtomicOrdering::acquire:
    return cpp_atomic::MemoryOrder::Acquire;
  case ptr::AtomicOrdering::release:
    return cpp_atomic::MemoryOrder::Release;
  case ptr::AtomicOrdering::seq_cst:
    return cpp_atomic::MemoryOrder::SeqCst;
  default:
    llvm_unreachable("unexpected ptr AtomicOrdering in CIRToCppAtomic");
  }
}

static cpp_atomic::MemoryOrder
convertCIRFenceOrder(cir::MemOrder order) {
  switch (order) {
    case cir::MemOrder::Relaxed:
      return cpp_atomic::MemoryOrder::Relaxed;
    case cir::MemOrder::Consume:
    case cir::MemOrder::Acquire:
      return cpp_atomic::MemoryOrder::Acquire;
    case cir::MemOrder::Release:
      return cpp_atomic::MemoryOrder::Release;
    case cir::MemOrder::SequentiallyConsistent:
      return cpp_atomic::MemoryOrder::SeqCst;
    default:
    llvm_unreachable("unknown CIR MemOrder");
  }
}

//===----------------------------------------------------------------------===//
// Rewrite patterns
//===----------------------------------------------------------------------===//

/// ptr.load (with atomic ordering) → cpp_atomic.atomic_load
struct LoadRewriter : public OpConversionPattern<ptr::LoadOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(ptr::LoadOp loadOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    auto memOrder = convertPtrOrder(loadOp.getOrdering());

    uint64_t align = loadOp.getAlignment().value_or(0);

    if (align == 0) {
      return rewriter.notifyMatchFailure(
          loadOp, "Atomic operations strictly require a non-zero alignment.");
    }

    // TODO: isDeref was destroyed by the cir-to-ptr pass, so it is always false here
    bool isDeref = false;
    bool isVolatile = loadOp.getVolatile_();

    // ptr::LoadOp operand is named $ptr
    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicLoadOp>(
        loadOp, loadOp.getValue().getType(), adaptor.getPtr(), memOrder, align, isDeref, isVolatile);
    return success();
  }
};

/// ptr.store (with atomic ordering) → cpp_atomic.atomic_store
struct StoreRewriter : public OpConversionPattern<ptr::StoreOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(ptr::StoreOp storeOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    auto memOrder = convertPtrOrder(storeOp.getOrdering());

    uint64_t align = storeOp.getAlignment().value_or(0);
    
    if (align == 0) {
      return rewriter.notifyMatchFailure(
          storeOp, "Atomic operations strictly require a non-zero alignment.");
    }

    bool isVolatile = storeOp.getVolatile_();

    // ptr::StoreOp operands are $value and $ptr
    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicStoreOp>(
        storeOp, adaptor.getValue(), adaptor.getPtr(), memOrder, align, isVolatile);
    return success();
  }
};

/// cir.atomic_fence → cpp_atomic.atomic_fence
struct FenceRewriter : public OpConversionPattern<cir::AtomicFenceOp> {
  using OpConversionPattern::OpConversionPattern;

  LogicalResult matchAndRewrite(cir::AtomicFenceOp fenceOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    auto memOrder = convertCIRFenceOrder(fenceOp.getOrdering());

    StringAttr syncscope;
    if (fenceOp.getSyncscope() == cir::SyncScopeKind::SingleThread)
      syncscope = rewriter.getStringAttr("singlethread");

    rewriter.replaceOpWithNewOp<cpp_atomic::AtomicFenceOp>(fenceOp, memOrder, syncscope);
    return success();
  }
};

//===----------------------------------------------------------------------===//
// Pass
//===----------------------------------------------------------------------===//

struct CIRToCppAtomicPass : public impl::CIRToCppAtomicBase<CIRToCppAtomicPass> {
  void runOnOperation() override {
    MLIRContext *context = &getContext();
    ConversionTarget target(*context);

    target.addLegalDialect<cpp_atomic::CppAtomicDialect>();
    target.addLegalDialect<ptr::PtrDialect>();
    target.addLegalDialect<cir::CIRDialect>();
    target.addLegalOp<mlir::UnrealizedConversionCastOp>();

    // Only atomic ptr.load/store are converted; non-atomic ones stay.
    target.addDynamicallyLegalOp<ptr::LoadOp>([](ptr::LoadOp op) {
      return op.getOrdering() == ptr::AtomicOrdering::not_atomic;
    });
    target.addDynamicallyLegalOp<ptr::StoreOp>([](ptr::StoreOp op) {
      return op.getOrdering() == ptr::AtomicOrdering::not_atomic;
    });
    target.addIllegalOp<cir::AtomicFenceOp>();

    RewritePatternSet patterns(context);
    patterns.add<LoadRewriter, StoreRewriter, FenceRewriter>(context);

    if (failed(applyPartialConversion(getOperation(), target,
                                      std::move(patterns))))
      signalPassFailure();
  }
};

} // namespace

std::unique_ptr<Pass> mlir::createCIRToCppAtomicPass() {
  return std::make_unique<CIRToCppAtomicPass>();
}
