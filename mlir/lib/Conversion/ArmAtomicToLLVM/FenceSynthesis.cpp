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
#include "llvm/Support/raw_ostream.h"
#include <chrono>
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

    // isEventFence: true if id refers to a fence op in the target dialect.
    auto isEventFence = [&](uint64_t id) -> bool {
      Operation *op = mb.getOpForId(id);
      return op && iface->isFenceEvent(op);
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
    rebuildPressure();

    // O(1) required-pair lookup for overspecified counter.
    llvm::DenseSet<std::pair<uint64_t,uint64_t>> requiredSet(
        required.requiredPairs().begin(), required.requiredPairs().end());
    unsigned total = required.requiredPairs().size();

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
    unsigned iteration = 0;
    while (changed) {
      changed = false;

      // Two passes: fence-involving pairs first (highest payoff), then
      // access-access pairs. Fence upgrades establish the most order per action.
      for (int pass = 0; pass < 2; ++pass) {
        // Batch independent promotions: pairs (a,b) and (c,d) are independent
        // if all of {a,b} are Unreachable from all of {c,d} and vice versa.
        // Independent promotions cannot affect each other's ordering, so we
        // apply them all and run closure once per batch.
        struct BatchEntry {
          uint64_t idA, idB;
          orb::Promotion promo;
        };
        llvm::SmallVector<BatchEntry> batch;
        llvm::SmallVector<unsigned> touchedIdx; // matrix indices in this batch

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

          // Check independence with current batch: all touched events must be
          // Unreachable from both a and b (and vice versa).
          bool independent = true;
          for (unsigned t : touchedIdx) {
            uint64_t tId = mb.eventIds()[t];
            if (mb.getOrder(tId, idA) != orb::EventOrder::Unreachable ||
                mb.getOrder(tId, idB) != orb::EventOrder::Unreachable ||
                mb.getOrder(idA, tId) != orb::EventOrder::Unreachable ||
                mb.getOrder(idB, tId) != orb::EventOrder::Unreachable) {
              independent = false;
              break;
            }
          }
          if (!independent)
            continue; // will be picked up in the next outer iteration

          Operation *a = mb.getOpForId(idA);
          Operation *b = mb.getOpForId(idB);
          if (!a || !b) {
            signalPassFailure();
            return;
          }

          // Pick the promotion with the best coverage-adjusted cost.
          orb::Promotion bestPromotion;
          int bestScore = std::numeric_limits<int>::max();
          orb::CostContext ctx{rowPressure[idA], rowWritePressure[idA],
                               colPressure[idB], colReadPressure[idB],
                               colWritePressure[idB], fenceCostBase,
                               (unsigned)mb.eventIds().size()};
          for (auto &p : iface->promote(idA, a, idB, b)) {
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
            log() << "ERROR: no promotion for pair ("
                         << idA << ", " << idB << ") — aborting\n";
            signalPassFailure();
            return;
          }

          batch.push_back({idA, idB, bestPromotion});
          touchedIdx.push_back(mb.idxOf(idA));
          touchedIdx.push_back(mb.idxOf(idB));
        }

        // Apply the batch: all promotions, then one closure + pressure rebuild.
        if (!batch.empty()) {
          {
            unsigned covered, overspecified;
            countOrdered(covered, overspecified);
            log() << "iter=" << iteration
                         << " pass=" << pass
                         << " ordered=" << covered << "/" << total
                         << " overspecified=" << overspecified
                         << " batched=" << batch.size()
                         << " t=" << elapsedMs() << "ms\n";
          }
          for (auto &e : batch) {
            Operation *newOp = iface->applyPromotion(e.promo, builder);
            if (newOp)
              newOp->setAttr(orb::kEventIdAttr,
                             builder.getI64IntegerAttr(nextSynthId++));
            iface->updateOrderMatrix(e.promo, newOp, e.idA, e.idB,
                                     mb, aa, dom, reach);
          }
          mb.closeIncrementally();
          rebuildPressure();
          changed = true;
        }
      }
      ++iteration;
    }

    unsigned covered, overspecified;
    countOrdered(covered, overspecified);
    unsigned remaining = 0;
    for (auto [idA, idB] : required.requiredPairs()) {
      if (fIgn.count(idA) || fIgn.count(idB))
        continue;
      if (mb.getOrder(idA, idB) != orb::EventOrder::Ordered)
        ++remaining;
    }
    log() << "done ordered=" << covered << "/" << total
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
