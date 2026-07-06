//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

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
#include "mlir/Conversion/CppAtomicToArmAtomic/CppAtomicToArmAtomic.h"
#include "mlir/Pass/Pass.h"


namespace mlir {
#define GEN_PASS_DEF_CONVERTCPPATOMICTOARMATOMICPASS
#include "mlir/Conversion/Passes.h.inc"
} // namespace mlir

using namespace mlir;

//===----------------------------------------------------------------------===//
// Rewrite patterns
//===----------------------------------------------------------------------===//

static arm_atomic::MemoryOrder convertLoadMemoryOrder(cpp_atomic::MemoryOrder cppOrder) {
  switch (cppOrder) {
    case cpp_atomic::MemoryOrder::Relaxed: return arm_atomic::MemoryOrder::Relaxed;
    
    // case cpp_atomic::MemoryOrder::Acquire:
    // case cpp_atomic::MemoryOrder::Release: 
    // case cpp_atomic::MemoryOrder::AcqRel: 
    // case cpp_atomic::MemoryOrder::SeqCst: 
    default:
      return arm_atomic::MemoryOrder::Acquire;
  }
}


static arm_atomic::MemoryOrder convertStoreMemoryOrder(cpp_atomic::MemoryOrder cppOrder) {
  switch (cppOrder) {
    case cpp_atomic::MemoryOrder::Relaxed: return arm_atomic::MemoryOrder::Relaxed;

    // case cpp_atomic::MemoryOrder::Release:
    // case cpp_atomic::MemoryOrder::Acquire: 
    // case cpp_atomic::MemoryOrder::AcqRel: 
    // case cpp_atomic::MemoryOrder::SeqCst: 
    default:
      return arm_atomic::MemoryOrder::Release;
  }
}

static arm_atomic::MemoryOrder convertFenceMemoryOrder(cpp_atomic::MemoryOrder cppOrder) {
  switch (cppOrder) {
    case cpp_atomic::MemoryOrder::Relaxed: return arm_atomic::MemoryOrder::Relaxed;
    case cpp_atomic::MemoryOrder::Acquire: return arm_atomic::MemoryOrder::Acquire;
    case cpp_atomic::MemoryOrder::Release: return arm_atomic::MemoryOrder::Release;
    
    case cpp_atomic::MemoryOrder::AcqRel:
    case cpp_atomic::MemoryOrder::SeqCst:
      return arm_atomic::MemoryOrder::AcqRel;
  }
  llvm_unreachable("Unknown CppAtomic memory order for fence");
}

static std::pair<arm_atomic::MemoryOrder, arm_atomic::MemoryOrder>
convertCASMemoryOrders(cpp_atomic::MemoryOrder succ, cpp_atomic::MemoryOrder fail) {
  // cas = compare and swap = relaxed
  // casl = release
  // casa = acquire
  // casal = acquire release
  
  using Cpp = cpp_atomic::MemoryOrder;
  using Arm = arm_atomic::MemoryOrder;
  
  if (succ == Cpp::SeqCst || fail == Cpp::SeqCst || succ == Cpp::AcqRel || (succ == Cpp::Release && fail == Cpp::Acquire)) {
    return {Arm::AcqRel, Arm::Relaxed};
  }

  if (succ == Cpp::Acquire || fail == Cpp::Acquire) return {Arm::Acquire, Arm::Relaxed};

  if (succ == Cpp::Release) return {Arm::Release, Arm::Relaxed};

  return {Arm::Relaxed, Arm::Relaxed};
}

static arm_atomic::BinOp convertBinOp(cpp_atomic::BinOp op) {
  switch (op) {
    case cpp_atomic::BinOp::Add: return arm_atomic::BinOp::Add;
    case cpp_atomic::BinOp::Sub: return arm_atomic::BinOp::Sub;
    case cpp_atomic::BinOp::And: return arm_atomic::BinOp::And;
    case cpp_atomic::BinOp::Or:  return arm_atomic::BinOp::Or;
    case cpp_atomic::BinOp::Xor: return arm_atomic::BinOp::Xor;
    case cpp_atomic::BinOp::Nand: return arm_atomic::BinOp::Nand;
    case cpp_atomic::BinOp::Max: return arm_atomic::BinOp::Max;
    case cpp_atomic::BinOp::Min: return arm_atomic::BinOp::Min;
  }
  llvm_unreachable("Unsupported Cpp_atomic fetch binop");
}

struct LoadRewriter : public OpConversionPattern<cpp_atomic::AtomicLoadOp> {

  LoadRewriter(MLIRContext *context) 
      : OpConversionPattern<cpp_atomic::AtomicLoadOp>(context) {}

  LogicalResult matchAndRewrite(cpp_atomic::AtomicLoadOp loadOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    Value addr = adaptor.getAddr();
    
    auto memOrder = convertLoadMemoryOrder(loadOp.getMemoryOrder());
    uint64_t alignment = loadOp.getAlignment();

    bool isDeref = loadOp.getIsDerefAttr() != nullptr;
    bool isVolatile = loadOp.getIsVolatileAttr() != nullptr;  

    rewriter.replaceOpWithNewOp<arm_atomic::AtomicLoadOp>(loadOp, addr, memOrder, alignment, isDeref, isVolatile);
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
    uint64_t alignment = storeOp.getAlignment();

    bool isVolatile = storeOp.getIsVolatileAttr() != nullptr;  

    rewriter.replaceOpWithNewOp<arm_atomic::AtomicStoreOp>(storeOp, value, addr, memOrder, alignment, isVolatile);
    return success();
  }
};

struct FenceRewriter : public OpConversionPattern<cpp_atomic::AtomicFenceOp> {

  FenceRewriter(MLIRContext *context) 
      : OpConversionPattern<cpp_atomic::AtomicFenceOp>(context) {}

  LogicalResult matchAndRewrite(cpp_atomic::AtomicFenceOp fenceOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
                                
    auto memOrder = convertFenceMemoryOrder(fenceOp.getMemoryOrder());

    rewriter.replaceOpWithNewOp<arm_atomic::AtomicFenceOp>(fenceOp, memOrder);
    return success();
  }
};

struct CmpXchgRewriter : public OpConversionPattern<cpp_atomic::AtomicCmpXchgOp> {

  CmpXchgRewriter(MLIRContext *context)
      : OpConversionPattern<cpp_atomic::AtomicCmpXchgOp>(context) {}

  LogicalResult matchAndRewrite(cpp_atomic::AtomicCmpXchgOp cmpOp, OpAdaptor adaptor,
                              ConversionPatternRewriter &rewriter) const override {

    auto [armSuccess, armFailure] = convertCASMemoryOrders(
      cmpOp.getSuccessOrder(), 
      cmpOp.getFailureOrder()
    );

    uint64_t alignment = cmpOp.getAlignment();

    bool isWeak = cmpOp.getWeakAttr() != nullptr;
    bool isVolatile = cmpOp.getIsVolatileAttr() != nullptr;

    rewriter.replaceOpWithNewOp<arm_atomic::AtomicCmpXchgOp>(
        cmpOp, 
        adaptor.getAddr(), 
        adaptor.getExpected(), 
        adaptor.getDesired(), 
        armSuccess, 
        armFailure, 
        alignment,
        isWeak,
        isVolatile
    );
        
    return success();
  }
};

struct FetchRewriter : public OpConversionPattern<cpp_atomic::AtomicFetchOp> {
  
  FetchRewriter(MLIRContext *context)
      : OpConversionPattern<cpp_atomic::AtomicFetchOp>(context) {}

  LogicalResult matchAndRewrite(cpp_atomic::AtomicFetchOp fetchOp, OpAdaptor adaptor,
                              ConversionPatternRewriter &rewriter) const override {

    auto memOrder = convertFenceMemoryOrder(fetchOp.getMemoryOrder());
    auto binOp = convertBinOp(fetchOp.getBinop());

    bool isVolatile = fetchOp.getIsVolatileAttr() != nullptr;
    bool fetchFirst = fetchOp.getFetchFirstAttr() != nullptr;

    rewriter.replaceOpWithNewOp<arm_atomic::AtomicFetchOp>(
        fetchOp,
        adaptor.getValue(),
        adaptor.getAddr(),
        binOp,
        memOrder,
        isVolatile,
        fetchFirst
    );

    return success();
  }
};

struct XchgRewriter : public OpConversionPattern<cpp_atomic::AtomicXchgOp> {

  XchgRewriter(MLIRContext *context)
      : OpConversionPattern<cpp_atomic::AtomicXchgOp>(context) {}

  LogicalResult matchAndRewrite(cpp_atomic::AtomicXchgOp xchgOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {

    auto memOrder = convertFenceMemoryOrder(xchgOp.getMemoryOrder());
    bool isVolatile = xchgOp.getIsVolatileAttr() != nullptr;

    rewriter.replaceOpWithNewOp<arm_atomic::AtomicXchgOp>(
        xchgOp,
        adaptor.getValue(), 
        adaptor.getAddr(),
        memOrder,
        isVolatile
    );
    return success();
  }
};

void populateCppToArmPatterns(RewritePatternSet &patterns) {
  patterns.add<LoadRewriter>(patterns.getContext());
  patterns.add<StoreRewriter>(patterns.getContext());
  patterns.add<FenceRewriter>(patterns.getContext());
  patterns.add<CmpXchgRewriter>(patterns.getContext());
  patterns.add<FetchRewriter>(patterns.getContext());
  patterns.add<XchgRewriter>(patterns.getContext());
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
}
