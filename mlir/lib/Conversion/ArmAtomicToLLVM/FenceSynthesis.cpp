//===- FenceSynthesis.cpp - Atomic fence synthesis pass -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/ArmAtomicToLLVM/FenceSynthesis.h"
#include "mlir/Analysis/AliasAnalysis.h"
#include "mlir/Dialect/Orb/ArmAtomicDialect.h"
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/Analysis/CFGLoopInfo.h"
#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
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
    mb.precomputeTransitiveDominance(iface, dom, postDom, reach);
    unsigned nEvents = mb.numEvents();
    log() << "n=" << nEvents << "\n";

    // Register required set for incremental ordered/overspecified tracking.
    llvm::DenseSet<std::pair<uint64_t, uint64_t>> requiredSetForTracking;
    for (auto [a, b] : required.requiredPairs())
      requiredSetForTracking.insert({a, b});
    mb.setRequiredSet(&requiredSetForTracking);

    // Log all events with their parent function and op type.
    {
      log() << "=== Event map ===\n";
      llvm::DenseSet<uint64_t> seenIds;
      for (auto [a, b] : required.requiredPairs()) {
        seenIds.insert(a);
        seenIds.insert(b);
      }
      for (uint64_t id : seenIds) {
        Operation *op = mb.getOpForId(id);
        if (!op) continue;
        StringRef funcName = "<unknown>";
        if (auto parent = op->getParentOfType<mlir::FunctionOpInterface>())
          if (auto sym = parent.getNameAttr())
            funcName = sym.getValue();
        log() << "ev=" << id << "\t" << funcName << "\t"
              << op->getName().getStringRef() << "\n";
      }
      log() << "=== End event map ===\n";

      // Dump all required pairs involving specific events of interest.
      log() << "=== Required pairs for quiescent_state events ===\n";
      for (auto [a, b] : required.requiredPairs()) {
        Operation *aOp = mb.getOpForId(a);
        Operation *bOp = mb.getOpForId(b);
        if (!aOp || !bOp) continue;
        auto aFunc = aOp->getParentOfType<mlir::FunctionOpInterface>();
        auto bFunc = bOp->getParentOfType<mlir::FunctionOpInterface>();
        StringRef aName = aFunc ? aFunc.getNameAttr().getValue() : "";
        StringRef bName = bFunc ? bFunc.getNameAttr().getValue() : "";
        if (aName.contains("quiescent") || bName.contains("quiescent")) {
          bool ordered = mb.isOrdered(a, b);
          log() << "  (" << a << "," << b << ") " << aName << " -> " << bName
                << (ordered ? " [pre-ordered]" : " [UNSATISFIED]") << "\n";
        }
      }
      log() << "=== End quiescent pairs ===\n";
    }

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

    // Count how many required pairs are already ordered by ARM dependencies.
    {
      unsigned preOrdered = 0, crossFn = 0, sameFn = 0;
      // Pair type breakdown: L=load, S=store, F=fence, P=plain load/store.
      unsigned LL = 0, LS = 0, SL = 0, SS = 0, FL = 0, FS = 0,
               LF = 0, SF = 0, other = 0;
      for (auto [c, d] : required.requiredPairs()) {
        if (mb.isOrdered(c, d))
          ++preOrdered;
        Operation *cOp = mb.getOpForId(c);
        Operation *dOp = mb.getOpForId(d);
        if (!cOp || !dOp) continue;
        if (cOp->getBlock()->getParent() != dOp->getBlock()->getParent())
          ++crossFn;
        else
          ++sameFn;
        bool cS = iface->isWriteEvent(cOp);
        bool cF = iface->isFenceEvent(cOp);
        bool cL = !cS && !cF;
        bool dS = iface->isWriteEvent(dOp);
        bool dF = iface->isFenceEvent(dOp);
        bool dL = !dS && !dF;
        if (cL && dL) ++LL; else if (cL && dS) ++LS;
        else if (cS && dL) ++SL; else if (cS && dS) ++SS;
        else if (cF && dL) ++FL; else if (cF && dS) ++FS;
        else if (cL && dF) ++LF; else if (cS && dF) ++SF;
        else ++other;
      }
      log() << "pre-ordered=" << preOrdered << "/" << total
                   << " crossFn=" << crossFn << " sameFn=" << sameFn
                   << " LL=" << LL << " LS=" << LS << " SL=" << SL
                   << " SS=" << SS << " FL=" << FL << " FS=" << FS
                   << " LF=" << LF << " SF=" << SF << "\n";
    }

    // Log initial ordered/overspecified state before greedy loop.
    {
      auto [c, o] = mb.orderedCounts();
      log() << "ordered=" << c << "/" << total
                   << " overspecified=" << o << "\n";
    }

    // Precompute per-event waste potential (invariant during synthesis).
    // nonRequiredFrom[X] = reachable events Y where (X,Y) is NOT required.
    // nonRequiredTo[Y]   = reachable events X where (X,Y) is NOT required.
    // These sets don't change: synthesis only flips Unordered→Ordered,
    // never changes reachability or the required set.
    llvm::DenseMap<uint64_t, unsigned> nonRequiredFrom, nonRequiredTo;
    {
      llvm::DenseMap<uint64_t, unsigned> requiredFromCnt, requiredToCnt;
      for (auto [a, b] : required.requiredPairs()) {
        requiredFromCnt[a]++;
        requiredToCnt[b]++;
      }
      for (uint64_t id : mb.eventIds()) {
        unsigned reachFrom = 0, reachTo = 0;
        for (uint64_t other : mb.eventIds()) {
          if (other == id) continue;
          if (mb.getOrder(id, other) != orb::EventOrder::Unreachable)
            ++reachFrom;
          if (mb.getOrder(other, id) != orb::EventOrder::Unreachable)
            ++reachTo;
        }
        unsigned rf = requiredFromCnt.lookup(id);
        unsigned rt = requiredToCnt.lookup(id);
        nonRequiredFrom[id] = reachFrom > rf ? reachFrom - rf : 0;
        nonRequiredTo[id] = reachTo > rt ? reachTo - rt : 0;
      }
    }

    // Waste estimation for a promotion: maximum non-required pairs that
    // would become ordered as side effects.
    auto estimateWaste = [&](const orb::Promotion &p) -> unsigned {
      if (auto *ua = std::get_if<orb::Promotion::UpgradeAction>(&p.action)) {
        auto evIdAttr =
            ua->op->getAttrOfType<IntegerAttr>(orb::kEventIdAttr);
        if (!evIdAttr || iface->isFenceEvent(ua->op))
          return 0;
        uint64_t evId = evIdAttr.getInt();
        return iface->isWriteEvent(ua->op) ? nonRequiredTo[evId]
                                           : nonRequiredFrom[evId];
      }
      if (auto *pa =
              std::get_if<orb::Promotion::PairUpgradeAction>(&p.action)) {
        unsigned w = 0;
        if (auto id1 =
                pa->op1->getAttrOfType<IntegerAttr>(orb::kEventIdAttr))
          w += iface->isWriteEvent(pa->op1) ? nonRequiredTo[id1.getInt()]
                                            : nonRequiredFrom[id1.getInt()];
        if (auto id2 =
                pa->op2->getAttrOfType<IntegerAttr>(orb::kEventIdAttr))
          w += iface->isWriteEvent(pa->op2) ? nonRequiredTo[id2.getInt()]
                                            : nonRequiredFrom[id2.getInt()];
        return w;
      }
      return 0;
    };

    // Sort required pairs: non-plain access pairs first, fence pairs second,
    // plain-plain pairs last. This ensures tie-breaking favors atomic pairs.
    auto sortedPairs = llvm::to_vector(required.requiredPairs());
    auto pairPriority = [&](const std::pair<uint64_t, uint64_t> &p) -> int {
      Operation *a = mb.getOpForId(p.first);
      Operation *b = mb.getOpForId(p.second);
      if (!a || !b) return 3;
      bool aPlain = isa<ptr::LoadOp, ptr::StoreOp>(a);
      bool bPlain = isa<ptr::LoadOp, ptr::StoreOp>(b);
      bool aFence = iface->isFenceEvent(a);
      bool bFence = iface->isFenceEvent(b);
      if (!aPlain && !bPlain && !aFence && !bFence) return 1; // atomic-atomic
      if (aFence || bFence) return 0;                         // fence endpoint
      return 2;                                               // plain-plain
    };
    llvm::sort(sortedPairs, [&](const auto &a, const auto &b) {
      return pairPriority(a) < pairPriority(b);
    });

    // Simple synthesis loop: pick first unsatisfied pair, promote it,
    // update matrix, repeat.
    unsigned iteration = 0;
    for (auto [idA, idB] : sortedPairs) {
      if (mb.isOrdered(idA, idB))
        continue;

      Operation *a = mb.getOpForId(idA);
      Operation *b = mb.getOpForId(idB);
      if (!a || !b)
        continue;

      // Get available promotions for this pair.
      auto promotions = iface->promote(idA, a, idB, b, mb);

      // When an endpoint is a fence, don't insert a NEW fence next to it.
      if (iface->isFenceEvent(a) || iface->isFenceEvent(b)) {
        llvm::erase_if(promotions, [](const orb::Promotion &p) {
          return std::holds_alternative<orb::Promotion::FenceAction>(
              p.action);
        });
      }

      // Intermediate fence upgrades via precomputed BitVectors.
      unsigned aIdx = mb.idxOf(idA), bIdx = mb.idxOf(idB);
      auto betweenFences = mb.fencesBetween(aIdx, bIdx);
      for (unsigned fEvIdx : betweenFences) {
        Operation *fOp = mb.getOpForId(mb.eventIds()[fEvIdx]);
        if (fOp == a || fOp == b)
          continue;
        if (iface->getOrderThroughFence(a, fOp, b) ==
                orb::EventOrder::Ordered &&
            orb::fencePostDominatesSource(fOp, a, postDom, reach) &&
            orb::fenceDominatesTarget(fOp, b, dom, reach)) {
          promotions.clear();
          promotions.push_back({orb::Promotion::EmptyUpgradeAction{}});
          break;
        }
        for (auto &fp : iface->promoteViaFence(a, fOp, b,
                                                 mb.eventIds()[fEvIdx], mb))
          promotions.push_back(fp);
      }

      if (promotions.empty()) {
        log() << "FATAL: no promotion for (" << idA << "," << idB << ")\n";
        signalPassFailure();
        return;
      }

      // Pick cheapest promotion for this pair.
      rebuildPressure();
      orb::CostContext ctx{rowPressure[idA], rowWritePressure[idA],
                           colPressure[idB], colReadPressure[idB],
                           colWritePressure[idB], fenceCostBase,
                           mb.numEvents()};
      orb::Promotion *best = &promotions[0];
      int64_t bestEff = INT64_MAX;
      for (auto &p : promotions) {
        if (auto *fa = std::get_if<orb::Promotion::FenceAction>(&p.action))
          p.loopDepth = blockLoopDepth.lookup(fa->insertBefore->getBlock());
        else if (auto *ua = std::get_if<orb::Promotion::UpgradeAction>(&p.action))
          p.loopDepth = blockLoopDepth.lookup(ua->op->getBlock());
        else if (auto *pa = std::get_if<orb::Promotion::PairUpgradeAction>(&p.action))
          p.loopDepth = std::max(blockLoopDepth.lookup(pa->op1->getBlock()),
                                 blockLoopDepth.lookup(pa->op2->getBlock()));

        int hwCost = iface->cost(p, ctx);
        unsigned waste = estimateWaste(p);
        int64_t eff = (int64_t)hwCost + 500LL * (int64_t)waste;
        if (eff < bestEff) {
          bestEff = eff;
          best = &p;
        }
      }

      // Empty promotion — pair already satisfied by existing fences.
      if (std::get_if<orb::Promotion::EmptyUpgradeAction>(&best->action)) {
        mb.markOrdered(idA, idB);
        ++iteration;
        continue;
      }

      // Log.
      if (auto *ua = std::get_if<orb::Promotion::UpgradeAction>(&best->action)) {
        uint64_t upgId = 0;
        if (auto attr = ua->op->getAttrOfType<IntegerAttr>(orb::kEventIdAttr))
          upgId = attr.getInt();
        log() << "iter=" << iteration << " (" << idA << "," << idB
              << ") upgrade ev=" << upgId
              << " op=" << ua->op->getName().getStringRef()
              << " to=" << ua->targetMemoryOrder
              << " waste=" << estimateWaste(*best) << "\n";
      } else if (std::get_if<orb::Promotion::FenceAction>(&best->action))
        log() << "iter=" << iteration << " (" << idA << "," << idB
              << ") fence\n";
      else if (auto *pa = std::get_if<orb::Promotion::PairUpgradeAction>(
                   &best->action))
        log() << "iter=" << iteration << " (" << idA << "," << idB
              << ") pair mo1=" << pa->targetMemoryOrder1
              << " mo2=" << pa->targetMemoryOrder2
              << " waste=" << estimateWaste(*best) << "\n";

      // Apply.
      Operation *newOp = iface->applyPromotion(*best, builder, &mb);
      if (newOp) {
        uint64_t newId = nextSynthId++;
        newOp->setAttr(orb::kEventIdAttr,
                       builder.getI64IntegerAttr(newId));
        iface->updateOrderMatrix(*best, newOp, idA, idB,
                                 mb, aa, dom, postDom, reach);
        unsigned fOrigIdx = mb.idxOf(newId);
        mb.addIntermediateFence(fOrigIdx, iface, dom, postDom, reach);
        mb.markOrdered(idA, idB);
        mb.closeTransitively(iface);
      } else {
        iface->updateOrderMatrix(*best, newOp, idA, idB,
                                 mb, aa, dom, postDom, reach);
        mb.closeTransitively(iface);
      }
      ++iteration;

      if (iteration % 100 == 0) {
        auto [c, o] = mb.orderedCounts();
        log() << "ordered=" << c << "/" << total
              << " overspecified=" << o
              << " t=" << elapsedMs() << "ms\n";
      }
    }

    auto [covered, overspecified] = mb.orderedCounts();
    log() << "done ordered=" << covered << "/" << total
                 << " overspecified=" << overspecified
                 << " promotions=" << iteration
                 << " t=" << elapsedMs() << "ms\n";

    // Post-synthesis: check if quiescent_state pairs are satisfied.
    {
      log() << "=== Post-synthesis quiescent pairs ===\n";
      unsigned sat = 0, unsat = 0;
      for (auto [a, b] : required.requiredPairs()) {
        Operation *aOp = mb.getOpForId(a);
        Operation *bOp = mb.getOpForId(b);
        if (!aOp || !bOp) continue;
        auto aFunc = aOp->getParentOfType<mlir::FunctionOpInterface>();
        auto bFunc = bOp->getParentOfType<mlir::FunctionOpInterface>();
        StringRef aName = aFunc ? aFunc.getNameAttr().getValue() : "";
        StringRef bName = bFunc ? bFunc.getNameAttr().getValue() : "";
        if (aName.contains("quiescent") || bName.contains("quiescent")) {
          if (mb.isOrdered(a, b))
            ++sat;
          else {
            ++unsat;
            log() << "  STILL UNSATISFIED (" << a << "," << b << ") "
                  << aName << " -> " << bName << "\n";
          }
        }
      }
      log() << "  quiescent: " << sat << " satisfied, " << unsat << " unsatisfied\n";
      log() << "=== End post-synthesis ===\n";
    }

    // Turn remaining Relaxed fences into compiler barriers (singlethread
    // syncscope). Per-access upgrades (LDAPR/STLR) satisfy ordering pairs but
    // don't act as compiler barriers — LLVM O3 may reorder surrounding code.
    // A singlethread fence prevents compiler reordering without emitting a
    // hardware barrier.
    unsigned compilerBarriers = 0;
    module.walk([&](arm_atomic::AtomicFenceOp fenceOp) {
      if (fenceOp.getMemoryOrder() == arm_atomic::MemoryOrder::Relaxed) {
        fenceOp.setSyncscopeAttr(
            StringAttr::get(fenceOp.getContext(), "singlethread"));
        ++compilerBarriers;
      }
    });
    if (compilerBarriers)
      log() << "compiler-barriers=" << compilerBarriers << "\n";
  }
};

} // namespace
} // namespace mlir
