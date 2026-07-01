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
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"
#include "clang/CIR/Dialect/IR/CIRTypes.h"

namespace mlir {
#define GEN_PASS_DEF_CONVERTARMATOMICTOLLVMPASS
#include "mlir/Conversion/Passes.h.inc"
} // namespace mlir

using namespace mlir;

//===----------------------------------------------------------------------===//
// Type conversion
//===----------------------------------------------------------------------===//

/// Register CIR scalar and pointer type conversions that are relevant for
/// atomic load/store operands and results.
static void addCIRTypeConversions(LLVMTypeConverter &converter) {
  converter.addConversion([](cir::PointerType type) -> mlir::Type {
    mlir::ptr::MemorySpaceAttrInterface addrSpaceAttr = type.getAddrSpace();
    unsigned numericAS = 0;
    if (auto targetAsAttr =
            mlir::dyn_cast_if_present<cir::TargetAddressSpaceAttr>(
                addrSpaceAttr))
      numericAS = targetAsAttr.getValue();
    return LLVM::LLVMPointerType::get(type.getContext(), numericAS);
  });
  converter.addConversion([](cir::IntType type) -> mlir::Type {
    return IntegerType::get(type.getContext(), type.getWidth());
  });
  converter.addConversion([](cir::BoolType type) -> mlir::Type {
    return IntegerType::get(type.getContext(), 1, IntegerType::Signless);
  });
  converter.addConversion([](cir::SingleType type) -> mlir::Type {
    return Float32Type::get(type.getContext());
  });
  converter.addConversion([](cir::DoubleType type) -> mlir::Type {
    return Float64Type::get(type.getContext());
  });
}

//===----------------------------------------------------------------------===//
// Helpers
//===----------------------------------------------------------------------===//

static LLVM::AtomicOrdering
toAtomicOrdering(arm_atomic::MemoryOrder order) {
  switch (order) {
  case arm_atomic::MemoryOrder::Relaxed: return LLVM::AtomicOrdering::monotonic;
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

    unsigned align = op.getAlignment();  

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

    unsigned align = op.getAlignment();

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
    
    if (op.getMemoryOrder() == mlir::arm_atomic::MemoryOrder::Relaxed) { 
      rewriter.eraseOp(op);
      return success();
    }

    rewriter.replaceOpWithNewOp<LLVM::FenceOp>(
        op, toAtomicOrdering(op.getMemoryOrder()));
        
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
    addCIRTypeConversions(converter);

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
