//===- ArmAtomicToLLVM.cpp - ArmAtomic to LLVM dialect conversion ---------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/ArmAtomicToLLVM/ArmAtomicToLLVM.h"

#include "mlir/Conversion/LLVMCommon/ConversionTarget.h"
#include "mlir/Conversion/LLVMCommon/Pattern.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/Orb/ArmAtomicDialect.h"
#include "mlir/Dialect/Ptr/IR/PtrTypes.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

namespace mlir {
#define GEN_PASS_DEF_CONVERTARMATOMICTOLLVMPASS
#include "mlir/Conversion/Passes.h.inc"
} // namespace mlir

using namespace mlir;

//===----------------------------------------------------------------------===//
// Type conversion
//===----------------------------------------------------------------------===//

/// Register ptr dialect pointer type conversion to LLVM pointer type.
/// After cir-to-ptr, all atomic pointer operands are !ptr.ptr<space>.
/// Value operands (integers, floats) are already MLIR signless types handled
/// by LLVMTypeConverter's default conversions.
static void addPtrTypeConversions(LLVMTypeConverter &converter) {
  converter.addConversion([](ptr::PtrType type) -> mlir::Type {
    // Map !ptr.ptr<space> → !llvm.ptr (address space 0 for generic/null).
    return LLVM::LLVMPointerType::get(type.getContext(), 0);
  });
}

//===----------------------------------------------------------------------===//
// Helpers
//===----------------------------------------------------------------------===//

static LLVM::AtomicOrdering
toAtomicOrdering(arm_atomic::MemoryOrder order) {
  switch (order) {
  case arm_atomic::MemoryOrder::Relaxed: return LLVM::AtomicOrdering::monotonic;
  case arm_atomic::MemoryOrder::AcquirePC: return LLVM::AtomicOrdering::acquire;
  case arm_atomic::MemoryOrder::Acquire: return LLVM::AtomicOrdering::acquire;
  case arm_atomic::MemoryOrder::Release: return LLVM::AtomicOrdering::release;
  case arm_atomic::MemoryOrder::AcqRel:  return LLVM::AtomicOrdering::acq_rel;
  }
  llvm_unreachable("unhandled ArmAtomic MemoryOrder");
}

//===----------------------------------------------------------------------===//
// Patterns
//===----------------------------------------------------------------------===//

struct AtomicLoadLowering
    : public ConvertOpToLLVMPattern<arm_atomic::AtomicLoadOp> {
  using ConvertOpToLLVMPattern::ConvertOpToLLVMPattern;

  LogicalResult
  matchAndRewrite(arm_atomic::AtomicLoadOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    Type resultTy = typeConverter->convertType(op.getResult().getType());
    if (!resultTy)
      return rewriter.notifyMatchFailure(op, "unconvertible result type");

    unsigned align = 0;
    if (op.getAlignment()) {
      align = static_cast<unsigned>(*op.getAlignment());
    } else {
      // If missing, calculate the byte width from the converted type
      if (resultTy.isIntOrFloat()) {
        align = std::max(1u, resultTy.getIntOrFloatBitWidth() / 8);
      } else {
        align = 8; // in case of pointers
      }
    }

    rewriter.replaceOpWithNewOp<LLVM::LoadOp>(
        op, resultTy, adaptor.getAddr(), align,
        /*isVolatile=*/false, /*isNonTemporal=*/false,
        /*isInvariant=*/false, /*isInvariantGroup=*/false,
        toAtomicOrdering(op.getMemoryOrder()));
    return success();
  }
};

struct AtomicStoreLowering
    : public ConvertOpToLLVMPattern<arm_atomic::AtomicStoreOp> {
  using ConvertOpToLLVMPattern::ConvertOpToLLVMPattern;

  LogicalResult
  matchAndRewrite(arm_atomic::AtomicStoreOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    Type valTy = adaptor.getValue().getType();

    unsigned align = 0;
    if (op.getAlignment()) {
      align = static_cast<unsigned>(*op.getAlignment());
    } else {
      // If missing, calculate the byte width from the converted type
      if (valTy.isIntOrFloat()) {
        align = std::max(1u, valTy.getIntOrFloatBitWidth() / 8);
      } else {
        align = 8; // in case of pointers
      }
    }

    rewriter.replaceOpWithNewOp<LLVM::StoreOp>(
        op, adaptor.getValue(), adaptor.getAddr(), align,
        /*isVolatile=*/false, /*isNonTemporal=*/false,
        /*isInvariantGroup=*/false,
        toAtomicOrdering(op.getMemoryOrder()));
    return success();
  }
};

struct AtomicFenceLowering
    : public ConvertOpToLLVMPattern<arm_atomic::AtomicFenceOp> {
  using ConvertOpToLLVMPattern::ConvertOpToLLVMPattern;

  LogicalResult
  matchAndRewrite(arm_atomic::AtomicFenceOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    
    if (op.getMemoryOrder() == arm_atomic::MemoryOrder::Relaxed) {
      rewriter.eraseOp(op);
      return success();
    }

    auto fence = rewriter.replaceOpWithNewOp<LLVM::FenceOp>(
        op, toAtomicOrdering(op.getMemoryOrder()));
    if (auto syncscope = op.getSyncscope())
      fence.setSyncscope(*syncscope);
        
    return success();
  }
};

//===----------------------------------------------------------------------===//
// Pass
//===----------------------------------------------------------------------===//

void mlir::populateArmAtomicToLLVMPatterns(LLVMTypeConverter &converter,
                                           RewritePatternSet &patterns) {
  patterns.add<AtomicLoadLowering, AtomicStoreLowering, AtomicFenceLowering>(converter);
}

namespace {
struct ConvertArmAtomicToLLVMPass
    : public impl::ConvertArmAtomicToLLVMPassBase<ConvertArmAtomicToLLVMPass> {
  using Base::Base;

  void runOnOperation() override {
    LLVMTypeConverter converter(&getContext());
    addPtrTypeConversions(converter);

    LLVMConversionTarget target(getContext());
    target.addIllegalDialect<arm_atomic::ArmAtomicDialect>();

    RewritePatternSet patterns(&getContext());
    populateArmAtomicToLLVMPatterns(converter, patterns);

    if (failed(applyPartialConversion(getOperation(), target,
                                      std::move(patterns))))
      signalPassFailure();
  }
};
} // namespace
