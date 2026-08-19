//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/CppAtomicToArmAtomic/CppAtomicToArmAtomic.h"
#include "mlir/Analysis/AliasAnalysis.h"
#include "mlir/Dialect/Orb/ArmAtomicDialect.h"
#include "mlir/Dialect/Orb/CppAtomicDialect.h"
#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/IR/Dominance.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/DialectConversion.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/raw_ostream.h"
#include <chrono>
#include <cstdlib>


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
    case cpp_atomic::MemoryOrder::AcqRel:
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
    case cpp_atomic::MemoryOrder::AcqRel:
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
// Logging helper (mirrors FenceSynthesis)
//===----------------------------------------------------------------------===//

namespace {

struct SynthLogStream {
  llvm::raw_ostream *file;
  const std::string &tag;
  bool started = false;
  template <typename T> SynthLogStream &operator<<(const T &v) {
    if (!started) { llvm::errs() << tag; if (file) *file << tag; started = true; }
    llvm::errs() << v;
    if (file) *file << v;
    return *this;
  }
};

} // namespace

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
    auto synthStart = std::chrono::steady_clock::now();
    auto elapsedMs = [&]() {
      return std::chrono::duration_cast<std::chrono::milliseconds>(
                 std::chrono::steady_clock::now() - synthStart)
          .count();
    };

    ModuleOp module = cast<ModuleOp>(getOperation());
    MLIRContext *context = &getContext();

    // ---- Build log tag (same scheme as FenceSynthesis) ----
    StringRef moduleName = "<unknown>";
    if (auto name = module.getName())
      moduleName = llvm::sys::path::filename(*name);
    else if (auto fileLoc = dyn_cast<FileLineColLoc>(module->getLoc()))
      moduleName = llvm::sys::path::filename(fileLoc.getFilename());
    llvm::hash_code moduleHash = llvm::hash_value(moduleName);
    module.walk([&](Operation *op) {
      if (auto sym = op->getAttrOfType<StringAttr>(
              mlir::SymbolTable::getSymbolAttrName()))
        moduleHash = llvm::hash_combine(moduleHash, sym);
    });
    std::string tagId = moduleName.str() + ":" +
                        llvm::utohexstr(static_cast<uint32_t>(moduleHash) & 0xFFFF,
                                        /*LowerCase=*/true);
    std::string tag = "[NaiveCppToArm] <" + tagId + "> ";

    std::unique_ptr<llvm::raw_fd_ostream> synthLog;
    if (const char *dir = std::getenv("ORB_SYNTH_LOG")) {
      std::string path = std::string(dir) + "/" + tagId + ".log";
      std::error_code ec;
      synthLog = std::make_unique<llvm::raw_fd_ostream>(path, ec,
                                                         llvm::sys::fs::OF_Append);
      if (ec)
        synthLog.reset();
    }
    auto log = [&]() -> SynthLogStream { return {synthLog.get(), tag}; };

    log() << "start\n";

    // ---- 1:1 conversion ----
    ConversionTarget target(*context);
    target.addLegalDialect<arm_atomic::ArmAtomicDialect>();
    target.addLegalOp<mlir::UnrealizedConversionCastOp>();
    target.addIllegalDialect<cpp_atomic::CppAtomicDialect>();

    RewritePatternSet patterns(context);
    populateNaiveCppToArmPatterns(patterns);

    if (failed(applyPartialConversion(getOperation(), target, std::move(patterns)))) {
      signalPassFailure();
      return;
    }

    // OrderAnalysis stores only stable event-ID pairs (no op pointers), so it
    // remains valid after ops are replaced.
    markAnalysesPreserved<orb::OrderAnalysis>();

    // ---- Verify ordering coverage and log ----
    auto &required = getAnalysis<orb::OrderAnalysis>();
    log() << "required pairs=" << required.requiredPairs().size() << "\n";
    if (required.empty())
      return;

    auto &aa  = getAnalysis<AliasAnalysis>();
    auto &dom = getAnalysis<DominanceInfo>();

    const orb::OrbAtomicDialectInterface *iface = nullptr;
    module.walk([&](Operation *op) -> WalkResult {
      if (!op->hasAttr(orb::kEventIdAttr))
        return WalkResult::advance();
      if (auto *i = op->getDialect()
                       ->getRegisteredInterface<orb::OrbAtomicDialectInterface>()) {
        iface = i;
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    if (!iface) {
      log() << "ERROR: no OrbAtomicDialectInterface found\n";
      return;
    }

    auto reach = orb::computeCallReachability(module);
    auto mb = orb::getOrderMatrix(module, aa, dom, iface, reach);
    iface->refineInitialOrderMatrix(mb);

    unsigned nEvents = mb.numEvents();
    log() << "n=" << nEvents << "\n";

    llvm::DenseSet<std::pair<uint64_t,uint64_t>> requiredSet(
        required.requiredPairs().begin(), required.requiredPairs().end());
    unsigned total = required.requiredPairs().size();
    unsigned covered = 0, overspecified = 0, remaining = 0;
    for (uint64_t c : mb.eventIds())
      for (uint64_t d : mb.eventIds()) {
        if (c == d || !mb.isOrdered(c, d))
          continue;
        if (requiredSet.count({c, d}))
          ++covered;
        else
          ++overspecified;
      }
    for (auto [idA, idB] : required.requiredPairs())
      if (!mb.isOrdered(idA, idB))
        ++remaining;

    log() << "done ordered=" << covered << "/" << total
          << " overspecified=" << overspecified
          << " remaining=" << remaining
          << " t=" << elapsedMs() << "ms\n";
}
