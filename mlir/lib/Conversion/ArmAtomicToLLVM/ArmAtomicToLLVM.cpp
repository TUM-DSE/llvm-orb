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
#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/Dialect/Ptr/IR/PtrTypes.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/raw_ostream.h"

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

    unsigned align = op.getAlignment(); 
    
    bool isVolatile = op.getIsVolatileAttr() != nullptr;

    // AcquirePC → LLVM acquire → LDAPR (with +rcpc).
    // Acquire   → LLVM seq_cst → LDAR.
    auto ordering = op.getMemoryOrder() == arm_atomic::MemoryOrder::Acquire
                        ? LLVM::AtomicOrdering::seq_cst
                        : toAtomicOrdering(op.getMemoryOrder());
    rewriter.replaceOpWithNewOp<LLVM::LoadOp>(
        op, resultTy, adaptor.getAddr(), align,
        isVolatile, /*isNonTemporal=*/false,
        /*isInvariant=*/false, /*isInvariantGroup=*/false,
        ordering);
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
    
    if (op.getMemoryOrder() == arm_atomic::MemoryOrder::Relaxed) {
      if (auto syncscope = op.getSyncscope()) {
        // Relaxed fence with syncscope = compiler barrier (no hardware fence).
        // Use AcqRel ordering with singlethread syncscope so LLVM treats it
        // as a compiler-only barrier that prevents reordering.
        auto fence = rewriter.replaceOpWithNewOp<LLVM::FenceOp>(
            op, LLVM::AtomicOrdering::acq_rel);
        fence.setSyncscope(*syncscope);
      } else {
        rewriter.eraseOp(op);
      }
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
/// Prints one line counting the memory events of the target program by kind
/// and memory order, e.g.
///
///   [OrbStats] module=test_urcu.c ld_rlx=12 ld_acqpc=0 ld_acq=3 ...
///
/// This pass runs after the memory model boundary in both pipelines -- after
/// the synthesis in -orb, after the naive conversion in -naive-orb -- so the
/// line records exactly the primitives handed to the back end. Unlike counting
/// instructions in the object file, it separates relaxed atomic accesses from
/// non-atomic ones (ptr_ld/ptr_st), which both compile to plain LDR/STR.
/// Relaxed fences are deliberately not counted as they emit no instruction. Stack-slot
/// accesses are not memory events and are not counted.
static void reportTargetStats(ModuleOp module) {
  unsigned ldRlx = 0, ldAcqPC = 0, ldAcq = 0, stRlx = 0, stRel = 0;
  unsigned fAcq = 0, fRel = 0, fAcqRel = 0, ptrLd = 0, ptrSt = 0;
  unsigned other = 0; // orders the conversions never produce
  module.walk([&](Operation *op) {
    if (auto ld = dyn_cast<arm_atomic::AtomicLoadOp>(op)) {
      switch (ld.getMemoryOrder()) {
      case arm_atomic::MemoryOrder::Relaxed:   ++ldRlx; break;
      case arm_atomic::MemoryOrder::AcquirePC: ++ldAcqPC; break;
      case arm_atomic::MemoryOrder::Acquire:   ++ldAcq; break;
      default:                                 ++other; break;
      }
    } else if (auto st = dyn_cast<arm_atomic::AtomicStoreOp>(op)) {
      switch (st.getMemoryOrder()) {
      case arm_atomic::MemoryOrder::Relaxed: ++stRlx; break;
      case arm_atomic::MemoryOrder::Release: ++stRel; break;
      default:                               ++other; break;
      }
    } else if (auto fence = dyn_cast<arm_atomic::AtomicFenceOp>(op)) {
      switch (fence.getMemoryOrder()) {
      case arm_atomic::MemoryOrder::Acquire: ++fAcq; break;
      case arm_atomic::MemoryOrder::Release: ++fRel; break;
      case arm_atomic::MemoryOrder::AcqRel:  ++fAcqRel; break;
      default:                               ++other; break;
      }
    } else if (isa<ptr::LoadOp>(op) && !orb::isStackSlotAccess(op)) {
      ++ptrLd;
    } else if (isa<ptr::StoreOp>(op) && !orb::isStackSlotAccess(op)) {
      ++ptrSt;
    }
  });

  StringRef name = "<unknown>";
  if (auto moduleName = module.getName())
    name = llvm::sys::path::filename(*moduleName);
  else if (auto fileLoc = dyn_cast<FileLineColLoc>(module->getLoc()))
    name = llvm::sys::path::filename(fileLoc.getFilename());

  llvm::errs() << "[OrbStats] module=" << name << " ld_rlx=" << ldRlx
               << " ld_acqpc=" << ldAcqPC << " ld_acq=" << ldAcq
               << " st_rlx=" << stRlx << " st_rel=" << stRel
               << " fence_acq=" << fAcq
               << " fence_rel=" << fRel << " fence_acqrel=" << fAcqRel
               << " ptr_ld=" << ptrLd << " ptr_st=" << ptrSt
               << " other=" << other << "\n";
}

struct ConvertArmAtomicToLLVMPass
    : public impl::ConvertArmAtomicToLLVMPassBase<ConvertArmAtomicToLLVMPass> {
  using Base::Base;

  void runOnOperation() override {
    reportTargetStats(getOperation());

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
