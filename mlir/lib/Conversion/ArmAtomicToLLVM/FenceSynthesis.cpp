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
#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Pass/Pass.h"
#include <chrono>

namespace mlir {

#define GEN_PASS_DECL_FENCESYNTHESISPASS
#define GEN_PASS_DEF_FENCESYNTHESISPASS
#include "mlir/Conversion/Passes.h.inc"

namespace {

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
    llvm::errs() << "[FenceSynthesis] start fenceCostBase=" << fenceCostBase << "\n";
    // M_A: required ordering pairs from the CppAtomic analysis — fixed.
    auto &required = getAnalysis<orb::OrderAnalysis>();
    llvm::errs() << "[FenceSynthesis] required pairs=" << required.requiredPairs().size() << "\n";
    if (required.empty())
      return;

    auto &aa  = getAnalysis<AliasAnalysis>();
    auto &dom = getAnalysis<DominanceInfo>();
    OpBuilder builder(module->getContext());

    // Precomputed reachability — stable across synthesis iterations.
    auto reach = orb::computeCallReachability(module);

    // Assign IDs for synthesized fences above all source IDs.
    uint64_t nextSynthId = 0;
    module.walk([&](Operation *op) {
      if (auto id = op->getAttrOfType<IntegerAttr>(orb::kEventIdAttr))
        nextSynthId = std::max(nextSynthId,
                               static_cast<uint64_t>(id.getInt()) + 1);
    });

    // Collect all OrbAtomic interfaces present in this module.
    llvm::SmallDenseSet<orb::OrbAtomicDialectInterface *> ifaceSet;
    module.walk([&](Operation *op) {
      if (!op->hasAttr(orb::kEventIdAttr))
        return;
      if (auto *iface =
              op->getDialect()
                  ->getRegisteredInterface<orb::OrbAtomicDialectInterface>())
        ifaceSet.insert(iface);
    });
    llvm::SmallVector<orb::OrbAtomicDialectInterface *> allIfaces(
        ifaceSet.begin(), ifaceSet.end());

    // M_B: current ArmAtomic ordering matrix — built once, updated incrementally.
    auto mb = orb::getOrderMatrix(module, aa, dom, reach);
    // Let the target dialect apply model-specific derived orderings (e.g. lob* for ARM).
    for (auto *iface : allIfaces)
      iface->refineInitialOrderMatrix(mb);

    // isEventFence: true if id refers to a fence op in any registered dialect.
    auto isEventFence = [&](uint64_t id) {
      Operation *op = mb.getOpForId(id);
      if (!op) return false;
      for (auto *iface : allIfaces)
        if (iface->isFenceEvent(op)) return true;
      return false;
    };

    // F_ign: source fence IDs whose mediated access-access pairs are all
    // already ordered in M_B. These pairs are skipped (paper §5.2).
    llvm::DenseSet<uint64_t> fIgn;

    // Pressure maps: count of unsatisfied required pairs per row/column.
    // rowWritePressure[c]: subset of rowPressure where d is a write — used for ACQPC cost.
    // colReadPressure[d]: subset of colPressure where c is a read — used for DMB LD cost.
    // colWritePressure[d]: subset of colPressure where c is a write — used for DMB ST cost.
    llvm::DenseMap<uint64_t, unsigned> rowPressure, rowWritePressure,
        colPressure, colReadPressure, colWritePressure;
    unsigned totalUnsatisfied = 0;
    auto rebuildPressure = [&]() {
      rowPressure.clear();
      rowWritePressure.clear();
      colPressure.clear();
      colReadPressure.clear();
      colWritePressure.clear();
      totalUnsatisfied = 0;
      for (auto [c, d] : required.requiredPairs()) {
        if (fIgn.count(c) || fIgn.count(d))
          continue;
        if (mb.getOrder(c, d) == orb::EventOrder::Ordered)
          continue;
        ++totalUnsatisfied;
        rowPressure[c]++;
        colPressure[d]++;
        Operation *dOp = mb.getOpForId(d);
        if (dOp && llvm::any_of(allIfaces, [&](orb::OrbAtomicDialectInterface *iface) {
              return iface->isWriteEvent(dOp);
            }))
          rowWritePressure[c]++;
        Operation *cOp = mb.getOpForId(c);
        bool cIsWrite = cOp && llvm::any_of(allIfaces, [&](orb::OrbAtomicDialectInterface *iface) {
              return iface->isWriteEvent(cOp); });
        bool cIsFence = cOp && llvm::any_of(allIfaces, [&](orb::OrbAtomicDialectInterface *iface) {
              return iface->isFenceEvent(cOp); });
        if (!cIsWrite && !cIsFence)
          colReadPressure[d]++;
        else if (cIsWrite)
          colWritePressure[d]++;
      }
    };
    rebuildPressure();

    // O(1) required-pair lookup for overspecified counter.
    llvm::DenseSet<std::pair<uint64_t,uint64_t>> requiredSet(
        required.requiredPairs().begin(), required.requiredPairs().end());
    unsigned total = required.requiredPairs().size();

    // Count ordered pairs in M_B: covered = required pairs that are ordered;
    // overspecified = ordered pairs in M_B not in the required set.
    auto countOrdered = [&](unsigned &covered, unsigned &overspecified) {
      covered = overspecified = 0;
      for (uint64_t c : mb.eventIds()) {
        for (uint64_t d : mb.eventIds()) {
          if (c == d || mb.getOrder(c, d) != orb::EventOrder::Ordered)
            continue;
          if (requiredSet.count({c, d}))
            ++covered;
          else
            ++overspecified;
        }
      }
    };

    // Fixpoint: each iteration either adds a fence to F_ign or adds edges to
    // M_B. Both sets are finite, so the loop always terminates (paper §5).
    bool changed = true;
    while (changed) {
      changed = false;

      // Two passes: fence-involving pairs first (highest payoff), then
      // access-access pairs. Fence upgrades establish the most order per action.
      for (int pass = 0; pass < 2; ++pass) {
        for (auto [idA, idB] : required.requiredPairs()) {
          if (fIgn.count(idA) || fIgn.count(idB))
            continue;
          if (mb.getOrder(idA, idB) == orb::EventOrder::Ordered)
            continue;

          bool aIsFence = isEventFence(idA), bIsFence = isEventFence(idB);
          if (pass == 0 && !(aIsFence || bIsFence))
            continue;
          if (pass == 1 && (aIsFence || bIsFence))
            continue;

          // Paper §5.2: if one endpoint is a source fence f, count how many
          // access-access pairs it mediates are still unordered.
          // If 0: f is ignorable. Otherwise fall through to promote() always —
          // deferring fence pairs causes an infinite loop (pass=1 skips them).
          if (aIsFence || bIsFence) {
            uint64_t fId = aIsFence ? idA : idB;
            llvm::SmallVector<uint64_t> before, after;
            required.pairsWithFence(fId, before, after);
            unsigned mediatedUnordered = 0;
            for (auto c : before) {
              if (isEventFence(c))
                continue; // O_B: access-access only
              for (auto d : after) {
                if (isEventFence(d))
                  continue;
                if (mb.getOrder(c, d) != orb::EventOrder::Ordered)
                  ++mediatedUnordered;
              }
            }
            if (mediatedUnordered == 0) {
              fIgn.insert(fId);
              changed = true;
              continue;
            }
            // mediatedUnordered > 0: fall through to promote().
          }

          Operation *a = mb.getOpForId(idA);
          Operation *b = mb.getOpForId(idB);
          if (!a || !b) {
            signalPassFailure();
            return;
          }

          // Log state before this promotion (first call = implicit coverage).
          {
            unsigned covered, overspecified;
            countOrdered(covered, overspecified);
            llvm::errs() << "[FenceSynthesis] ordered=" << covered << "/" << total
                         << " overspecified=" << overspecified
                         << " t=" << elapsedMs() << "ms\n";
          }

          // Pick the promotion with the best coverage-adjusted cost.
          // Lower score is better; dialect's cost() encodes both base cost and
          // coverage via the CostContext.
          orb::OrbAtomicDialectInterface *bestIface = nullptr;
          orb::Promotion bestPromotion;
          int bestScore = std::numeric_limits<int>::max();
          orb::CostContext ctx{rowPressure[idA], rowWritePressure[idA],
                               colPressure[idB], colReadPressure[idB],
                               colWritePressure[idB], fenceCostBase};
          for (auto *iface : allIfaces) {
            for (auto &p : iface->promote(idA, a, idB, b)) {
              int score = iface->cost(p, ctx);
              if (score < bestScore) {
                bestScore = score;
                bestIface = iface;
                bestPromotion = p;
              }
            }
          }
          if (!bestIface) {
            llvm::errs() << "[FenceSynthesis] ERROR: no promotion for pair ("
                         << idA << ", " << idB << ") — aborting\n";
            signalPassFailure();
            return;
          }

          Operation *newOp = bestIface->applyPromotion(bestPromotion, builder);

          if (const auto *ua = std::get_if<orb::Promotion::UpgradeAction>(
                  &bestPromotion.action)) {
            if (isa<arm_atomic::AtomicLoadOp>(ua->op)) {
              auto targetMO = static_cast<arm_atomic::MemoryOrder>(ua->targetMemoryOrder);
              if (targetMO == arm_atomic::MemoryOrder::AcquirePC)
                mb.applyAcqPCUpgrade(mb.idxOf(idA), allIfaces);
              else
                mb.applyAcqUpgrade(mb.idxOf(idA));
            } else if (isa<arm_atomic::AtomicStoreOp>(ua->op))
              mb.applyRelUpgrade(mb.idxOf(idB));
            else { // fence upgrade
              uint64_t fId = (ua->op == a) ? idA : idB;
              mb.applyFenceUpgrade(mb.idxOf(fId), allIfaces, aa, dom, reach);
            }
          } else {
            assert(newOp && "applyPromotion must return the created fence op");
            newOp->setAttr(orb::kEventIdAttr,
                           builder.getI64IntegerAttr(nextSynthId++));
            mb.addFence(newOp, allIfaces, aa, dom, reach);
          }

          rebuildPressure();
          changed = true;
        }
      }
    }

    // Verify all required pairs (excluding ignorable fences) are satisfied.
    unsigned covered, overspecified;
    countOrdered(covered, overspecified);
    unsigned remaining = 0;
    for (auto [idA, idB] : required.requiredPairs()) {
      if (fIgn.count(idA) || fIgn.count(idB))
        continue;
      if (mb.getOrder(idA, idB) != orb::EventOrder::Ordered)
        ++remaining;
    }
    llvm::errs() << "[FenceSynthesis] done ordered=" << covered << "/" << total
                 << " overspecified=" << overspecified
                 << " fIgn=" << fIgn.size()
                 << " remaining=" << remaining
                 << " t=" << elapsedMs() << "ms\n";
    if (remaining > 0)
      signalPassFailure();
  }
};

} // namespace
} // namespace mlir
