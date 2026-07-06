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

static LLVM::AtomicBinOp convertToLLVMBinOp(arm_atomic::BinOp op, Type valType) {
  bool isFloat = llvm::isa<mlir::FloatType>(valType);

  switch (op) {
    case arm_atomic::BinOp::Add:  return isFloat ? LLVM::AtomicBinOp::fadd : LLVM::AtomicBinOp::add;
    case arm_atomic::BinOp::Sub:  return isFloat ? LLVM::AtomicBinOp::fsub : LLVM::AtomicBinOp::sub;
    case arm_atomic::BinOp::Max:  return isFloat ? LLVM::AtomicBinOp::fmax : LLVM::AtomicBinOp::max;
    case arm_atomic::BinOp::Min:  return isFloat ? LLVM::AtomicBinOp::fmin : LLVM::AtomicBinOp::min;
    
    case arm_atomic::BinOp::And:  return LLVM::AtomicBinOp::_and;
    case arm_atomic::BinOp::Or:   return LLVM::AtomicBinOp::_or;
    case arm_atomic::BinOp::Xor:  return LLVM::AtomicBinOp::_xor;
    case arm_atomic::BinOp::Nand: return LLVM::AtomicBinOp::nand;
  }
  llvm_unreachable("Unknown ArmAtomic BinOp");
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
    
    bool isVolatile = op.getIsVolatileAttr() != nullptr;

    rewriter.replaceOpWithNewOp<LLVM::LoadOp>(
        op, resultTy, adaptor.getAddr(), align,
        isVolatile, /*isNonTemporal=*/false,
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

    bool isVolatile = op.getIsVolatileAttr() != nullptr;

    rewriter.replaceOpWithNewOp<LLVM::StoreOp>(
        op, adaptor.getValue(), adaptor.getAddr(), align,
        isVolatile, /*isNonTemporal=*/false,
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

struct AtomicCmpXchgLowering : public ConvertOpToLLVMPattern<arm_atomic::AtomicCmpXchgOp> {
  using ConvertOpToLLVMPattern::ConvertOpToLLVMPattern;

  LogicalResult
  matchAndRewrite(arm_atomic::AtomicCmpXchgOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {

    Type loadedTy = typeConverter->convertType(op.getLoaded().getType());

    bool isWeak = op.getWeakAttr() != nullptr;
    bool isVolatile = op.getIsVolatileAttr() != nullptr;
    uint64_t align = op.getAlignment();

    auto llvmCmpXchg = LLVM::AtomicCmpXchgOp::create(
        rewriter,
        op.getLoc(),
        adaptor.getAddr(),
        adaptor.getExpected(),
        adaptor.getDesired(),
        toAtomicOrdering(op.getSuccessOrder()),
        toAtomicOrdering(op.getFailureOrder()),
        llvm::StringRef(), // syncscope
        align,
        isWeak,
        isVolatile
    );

    Value loadedVal = LLVM::ExtractValueOp::create(
        rewriter,
        op.getLoc(), 
        loadedTy, 
        llvmCmpXchg.getResult(), 
        rewriter.getDenseI64ArrayAttr({0})
    );

    Value successBool = LLVM::ExtractValueOp::create(
        rewriter,
        op.getLoc(), 
        rewriter.getI1Type(), 
        llvmCmpXchg.getResult(), 
        rewriter.getDenseI64ArrayAttr({1})
    );

    rewriter.replaceOp(op, {loadedVal, successBool});
    
    return success();
  }
};

struct AtomicFetchLowering : public ConvertOpToLLVMPattern<arm_atomic::AtomicFetchOp> {
  using ConvertOpToLLVMPattern::ConvertOpToLLVMPattern;

  LogicalResult 
  matchAndRewrite(arm_atomic::AtomicFetchOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
                    
    Type valType = adaptor.getValue().getType();
    LLVM::AtomicBinOp llvmBinOp = convertToLLVMBinOp(op.getBinop(), valType);

    bool isVolatile = op.getIsVolatileAttr() != nullptr;
    bool isFloat = llvm::isa<mlir::FloatType>(valType);

    if (op.getFetchFirst()) {
      rewriter.replaceOpWithNewOp<LLVM::AtomicRMWOp>(
        op,
        llvmBinOp,
        adaptor.getAddr(),
        adaptor.getValue(),
        toAtomicOrdering(op.getMemoryOrder()),
        /*syncscope*/llvm::StringRef(),
        /*alignment*/0,
        isVolatile
      );
      return success();
    }

    auto rmwOp = LLVM::AtomicRMWOp::create(
      rewriter, 
      op.getLoc(), 
      llvmBinOp, 
      adaptor.getAddr(), 
      adaptor.getValue(),
      toAtomicOrdering(op.getMemoryOrder()), 
      /*syncscope*/llvm::StringRef(),
      /*alignment*/0,
      isVolatile
    );

    Value result = rmwOp.getResult();
    Location loc = op.getLoc();
    Value val = adaptor.getValue();

    if (isFloat) {
      switch (llvmBinOp) {
        case LLVM::AtomicBinOp::fadd: 
          result = LLVM::FAddOp::create(rewriter, loc, result, val); break;
        case LLVM::AtomicBinOp::fsub: 
          result = LLVM::FSubOp::create(rewriter, loc, result, val); break;
        default:
          llvm::errs() << "Warning: fetch_first=false not implemented for Float Min/Max.\n";
          break;
      }
    } else {
      switch (llvmBinOp) {
        case LLVM::AtomicBinOp::add: 
          result = LLVM::AddOp::create(rewriter, loc, result, val); break;
        case LLVM::AtomicBinOp::sub: 
          result = LLVM::SubOp::create(rewriter, loc, result, val); break;
        case LLVM::AtomicBinOp::_and: 
          result = LLVM::AndOp::create(rewriter, loc, result, val); break;
        case LLVM::AtomicBinOp::_or: 
          result = LLVM::OrOp::create(rewriter, loc, result, val); break;
        case LLVM::AtomicBinOp::_xor: 
          result = LLVM::XOrOp::create(rewriter, loc, result, val); break;
        default:
          llvm::errs() << "Warning: fetch_first=false not implemented for Integer Min/Max/Nand.\n";
          break;
      }
    }  

    rewriter.replaceOp(op, result);
    return success();
  }
};

struct AtomicXchgLowering : public ConvertOpToLLVMPattern<arm_atomic::AtomicXchgOp> {
  using ConvertOpToLLVMPattern::ConvertOpToLLVMPattern;

  LogicalResult 
  matchAndRewrite(arm_atomic::AtomicXchgOp op, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {

    bool isVolatile = op.getIsVolatileAttr() != nullptr;

    rewriter.replaceOpWithNewOp<LLVM::AtomicRMWOp>(
        op, 
        LLVM::AtomicBinOp::xchg, 
        adaptor.getAddr(), 
        adaptor.getValue(),
        toAtomicOrdering(op.getMemoryOrder()), 
        /*syncscope*/llvm::StringRef(),
        /*alignment*/0,
        isVolatile
    );

    return success();
  }
};

//===----------------------------------------------------------------------===//
// Pass
//===----------------------------------------------------------------------===//

void mlir::populateArmAtomicToLLVMPatterns(LLVMTypeConverter &converter,
                                           RewritePatternSet &patterns) {
  patterns.add<AtomicLoadLowering, AtomicStoreLowering, AtomicFenceLowering, AtomicCmpXchgLowering, AtomicFetchLowering, AtomicXchgLowering>(converter);
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
