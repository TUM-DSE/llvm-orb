//===- FenceSynthesis.cpp - Atomic fence synthesis pass -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/ArmAtomicToLLVM/FenceSynthesis.h"
#include "mlir/Analysis/AliasAnalysis.h"
#include "mlir/Analysis/CFGLoopInfo.h"
#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Pass/Pass.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include <chrono>

#define DEBUG_TYPE "fence-synthesis"
#include <cstdlib>

namespace mlir {

#define GEN_PASS_DECL_FENCESYNTHESISPASS
#define GEN_PASS_DEF_FENCESYNTHESISPASS
#include "mlir/Conversion/Passes.h.inc"

namespace {

/// Tee stream: writes to both stderr and an optional file.
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

struct FenceSynthesisPass
    : impl::FenceSynthesisPassBase<FenceSynthesisPass> {
  using Base::Base;

  void runOnOperation() override {
    ModuleOp module = getOperation();

    auto synthStart = std::chrono::steady_clock::now();
    auto elapsedMs = [&]() {
      return std::chrono::duration_cast<std::chrono::milliseconds>(
                 std::chrono::steady_clock::now() - synthStart)
          .count();
    };
    // Build log tag from source filename + symbol hash for disambiguation.
    // Same source compiled with different defines (e.g. -DRCU_MB) produces
    // different symbol sets, so hashing symbol names yields a unique tag.
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
    std::string tag = "[FenceSynthesis] <" + tagId + "> ";

    // If ORB_SYNTH_LOG is set, write synthesis log to a per-module file.
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

    log() << "start fenceCostBase=" << fenceCostBase << "\n";
    auto &required = getAnalysis<orb::OrderAnalysis>();
    log() << "required pairs=" << required.requiredPairs().size() << "\n";
    if (required.empty())
      return;

    auto &aa  = getAnalysis<AliasAnalysis>();
    auto &dom = getAnalysis<DominanceInfo>();
    auto &postDom = getAnalysis<PostDominanceInfo>();
    OpBuilder builder(module->getContext());

    // Precomputed reachability — stable across synthesis iterations.
    auto reach = orb::computeCallReachability(module);

    // Precompute loop depth per block for loop-aware cost model.
    // Skip single-block regions (no loops possible) and regions whose
    // blocks lack terminators (not valid CFG — e.g. CIR structured regions).
    llvm::DenseMap<Block *, unsigned> blockLoopDepth;
    module.walk([&](Operation *op) {
      auto callable = dyn_cast<CallableOpInterface>(op);
      if (!callable)
        return;
      Region *body = callable.getCallableRegion();
      if (!body || body->empty() || body->hasOneBlock())
        return;
      // Verify all blocks have terminators (proper CFG).
      for (Block &b : *body)
        if (!b.getTerminator())
          return;
      CFGLoopInfo li(dom.getDomTree(body));
      for (Block &b : *body)
        if (unsigned d = li.getLoopDepth(&b))
          blockLoopDepth[&b] = d;
    });

    // Find the single OrbAtomicDialectInterface registered in this module.
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
      signalPassFailure();
      return;
    }

    // Assign IDs for synthesized fences above all source IDs.
    uint64_t nextSynthId = 0;
    module.walk([&](Operation *op) {
      if (auto id = op->getAttrOfType<IntegerAttr>(orb::kEventIdAttr))
        nextSynthId = std::max(nextSynthId,
                               static_cast<uint64_t>(id.getInt()) + 1);
    });

    // M_B: current ArmAtomic ordering matrix — built once, updated incrementally.
    auto mb = orb::getOrderMatrix(module, aa, dom, iface, reach);
    // Let the target dialect apply model-specific derived orderings (e.g. lob* for ARM).
    iface->refineInitialOrderMatrix(mb);
    mb.precomputeIntermediateFences(iface, dom, postDom, reach);
    unsigned nEvents = mb.numEvents();
    log() << "n=" << nEvents << "\n";

    // Pressure maps: count of unsatisfied required pairs per row/column.
    llvm::DenseMap<uint64_t, unsigned> rowPressure, rowWritePressure,
        colPressure, colReadPressure, colWritePressure;
    auto rebuildPressure = [&]() {
      rowPressure.clear();
      rowWritePressure.clear();
      colPressure.clear();
      colReadPressure.clear();
      colWritePressure.clear();
      for (auto [c, d] : required.requiredPairs()) {
        if (mb.isOrdered(c, d))
          continue;
        rowPressure[c]++;
        colPressure[d]++;
        Operation *dOp = mb.getOpForId(d);
        if (dOp && iface->isWriteEvent(dOp))
          rowWritePressure[c]++;
        Operation *cOp = mb.getOpForId(c);
        bool cIsWrite = cOp && iface->isWriteEvent(cOp);
        bool cIsFence = cOp && iface->isFenceEvent(cOp);
        if (!cIsWrite && !cIsFence)
          colReadPressure[d]++;
        else if (cIsWrite)
          colWritePressure[d]++;
      }
    };

    unsigned total = required.requiredPairs().size();

    // Count how many required pairs are already ordered by ARM dependencies
    // (dob, lwfs, transitive closure) BEFORE synthesis.
    {
      unsigned preOrdered = 0;
      for (auto [c, d] : required.requiredPairs()) {
        if (mb.isOrdered(c, d))
          ++preOrdered;
      }
      log() << "pre-ordered=" << preOrdered << "/" << total << "\n";
    }

    // Simple greedy loop: pick the first unsatisfied pair, find the
    // cheapest promotion, apply it, update the matrix, repeat.
    unsigned iteration = 0;
    for (;;) {
      // Find first unsatisfied pair.
      uint64_t idA = UINT64_MAX, idB = UINT64_MAX;
      for (auto [a, b] : required.requiredPairs()) {
        if (mb.isOrdered(a, b))
          continue;
        idA = a;
        idB = b;
        break;
      }
      if (idA == UINT64_MAX)
        break; // all satisfied

      Operation *a = mb.getOpForId(idA);
      Operation *b = mb.getOpForId(idB);
      if (!a || !b) {
        signalPassFailure();
        return;
      }

      // Pick the promotion with the best coverage-adjusted cost.
      rebuildPressure();
      orb::Promotion bestPromotion;
      int bestScore = std::numeric_limits<int>::max();
      orb::CostContext ctx{rowPressure[idA], rowWritePressure[idA],
                           colPressure[idB], colReadPressure[idB],
                           colWritePressure[idB], fenceCostBase,
                           mb.numEvents()};
      auto promotions = iface->promote(idA, a, idB, b);

      // Intermediate fence upgrades via precomputed BitVectors.
      unsigned aIdx = mb.idxOf(idA), bIdx = mb.idxOf(idB);
      auto betweenFences = mb.fencesBetween(aIdx, bIdx);
      for (unsigned fEvIdx : betweenFences) {
        Operation *fOp = mb.getOpForId(mb.eventIds()[fEvIdx]);
        if (fOp == a || fOp == b)
          continue;
        // If this fence already orders the pair AND dominates the target,
        // the pair is already satisfied — no promotion needed.
        if (iface->getOrderThroughFence(a, fOp, b) ==
                orb::EventOrder::Ordered &&
            orb::fenceDominatesTarget(fOp, b, dom, reach)) {
          promotions.clear();
          promotions.push_back({orb::Promotion::EmptyUpgradeAction{}});
          break;
        }
        for (auto &fp : iface->promoteViaFence(a, fOp, b))
          promotions.push_back(fp);
      }

      for (auto &p : promotions) {
        if (auto *fa = std::get_if<orb::Promotion::FenceAction>(&p.action))
          p.loopDepth =
              blockLoopDepth.lookup(fa->insertBefore->getBlock());
        else if (auto *ua = std::get_if<orb::Promotion::UpgradeAction>(&p.action))
          p.loopDepth = blockLoopDepth.lookup(ua->op->getBlock());
        else if (auto *pa = std::get_if<orb::Promotion::PairUpgradeAction>(&p.action))
          p.loopDepth =
              std::max(blockLoopDepth.lookup(pa->op1->getBlock()),
                       blockLoopDepth.lookup(pa->op2->getBlock()));
        int score = iface->cost(p, ctx);
        if (score < bestScore) {
          bestScore = score;
          bestPromotion = p;
        }
      }
      if (bestScore == std::numeric_limits<int>::max()) {
        log() << "no promotion for (" << idA << "," << idB << ")\n";
        break;
      }

      // Log and apply.
      if (auto *ua = std::get_if<orb::Promotion::UpgradeAction>(&bestPromotion.action)) {
        uint64_t upgId = 0;
        if (auto idA2 = ua->op->getAttrOfType<IntegerAttr>(orb::kEventIdAttr))
          upgId = idA2.getInt();
        log() << "iter=" << iteration << " (" << idA << "," << idB
                     << ") upgrade ev=" << upgId
                     << " op=" << ua->op->getName().getStringRef()
                     << " to=" << ua->targetMemoryOrder << "\n";
      }
      else if (std::get_if<orb::Promotion::FenceAction>(&bestPromotion.action))
        log() << "iter=" << iteration << " (" << idA << "," << idB
                     << ") fence\n";
      else if (auto *pa = std::get_if<orb::Promotion::PairUpgradeAction>(&bestPromotion.action))
        log() << "iter=" << iteration << " (" << idA << "," << idB
                     << ") pair mo1=" << pa->targetMemoryOrder1
                     << " mo2=" << pa->targetMemoryOrder2 << "\n";
      else
        log() << "iter=" << iteration << " (" << idA << "," << idB
                     << ") empty\n";

      Operation *newOp = iface->applyPromotion(bestPromotion, builder);
      if (newOp) {
        uint64_t newId = nextSynthId++;
        newOp->setAttr(orb::kEventIdAttr,
                       builder.getI64IntegerAttr(newId));
        // Update intermediate fence BitVectors after addFence expanded the matrix.
        iface->updateOrderMatrix(bestPromotion, newOp, idA, idB,
                                 mb, aa, dom, reach);
        unsigned fOrigIdx = mb.idxOf(newId);
        mb.addIntermediateFence(fOrigIdx, iface, dom, postDom, reach);
        mb.markOrdered(idA, idB);
        ++iteration;
        continue;
      }
      iface->updateOrderMatrix(bestPromotion, newOp, idA, idB,
                               mb, aa, dom, reach);
      mb.markOrdered(idA, idB);
      ++iteration;
    }

    auto [covered, overspecified] = mb.orderedCounts();
    log() << "done ordered=" << covered << "/" << total
                 << " overspecified=" << overspecified
                 << " promotions=" << iteration
                 << " t=" << elapsedMs() << "ms\n";
  }
};

} // namespace
} // namespace mlir
