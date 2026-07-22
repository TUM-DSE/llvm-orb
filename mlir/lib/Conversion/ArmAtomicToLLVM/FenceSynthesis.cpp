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
#include "llvm/ADT/DenseSet.h"

namespace mlir {

#define GEN_PASS_DEF_FENCESYNTHESISPASS
#include "mlir/Conversion/Passes.h.inc"

namespace {

struct FenceSynthesisPass
    : impl::FenceSynthesisPassBase<FenceSynthesisPass> {
  using Base::Base;

  void runOnOperation() override {
    ModuleOp module = getOperation();

    auto &required = getAnalysis<orb::OrderAnalysis>();
    if (required.empty())
      return;

    auto &aa  = getAnalysis<AliasAnalysis>();
    auto &dom = getAnalysis<DominanceInfo>();
    OpBuilder builder(module->getContext());

    // isSatisfied: is (idA, idB) ordered in the current ArmAtomic IR?
    // Checks direct ordering and fence-mediated ordering (getOrderThroughFence).
    orb::OrderMatrix current;
    auto isSatisfied = [&](uint64_t idA, uint64_t idB) -> bool {
      if (current.getOrder(idA, idB) == orb::EventOrder::Ordered)
        return true;
      Operation *a = current.getOpForId(idA);
      Operation *b = current.getOpForId(idB);
      if (!a || !b)
        return false;
      for (uint64_t idF : current.eventIds()) {
        if (idF == idA || idF == idB)
          continue;
        Operation *f = current.getOpForId(idF);
        if (!f)
          continue;
        auto *iface = f->getDialect()
                          ->getRegisteredInterface<orb::OrbAtomicDialectInterface>();
        if (iface &&
            iface->getOrderThroughFence(a, f, b, dom) == orb::EventOrder::Ordered)
          return true;
      }
      return false;
    };

    // F_ign: event IDs of source fences whose mediated access-access pairs
    // are all already satisfied — these fences can be erased.
    llvm::SmallDenseSet<uint64_t> fIgn;

    bool progress = true;
    while (progress) {
      progress = false;
      current = orb::getOrderMatrix(module, aa, dom);

      std::optional<orb::Promotion> best;
      int bestCost = INT_MAX;
      orb::OrbAtomicDialectInterface *bestIface = nullptr;

      for (auto [idA, idB] : required.requiredPairs()) {
        // Skip pairs involving already-ignorable fences.
        if (fIgn.count(idA) || fIgn.count(idB))
          continue;
        if (isSatisfied(idA, idB))
          continue;

        Operation *a = current.getOpForId(idA);
        Operation *b = current.getOpForId(idB);
        if (!a || !b)
          continue;

        // Fence-pair: check whether all access-access pairs mediated by this
        // fence are already satisfied (paper Alg. 1, fence-ignorable check).
        bool aIsFence = isa<arm_atomic::AtomicFenceOp>(a);
        bool bIsFence = isa<arm_atomic::AtomicFenceOp>(b);
        if (aIsFence || bIsFence) {
          uint64_t idF = aIsFence ? idA : idB;
          llvm::SmallVector<uint64_t> before, after;
          required.pairsWithFence(idF, before, after);
          // Restrict to access-access pairs (O_A submatrix of M_A):
          // skip ids that correspond to fence events.
          auto isAccess = [&](uint64_t id) {
            Operation *op = current.getOpForId(id);
            return op && !isa<arm_atomic::AtomicFenceOp>(op);
          };
          bool needed = false;
          for (uint64_t idC : before) {
            if (!isAccess(idC)) continue;
            for (uint64_t idD : after) {
              if (!isAccess(idD)) continue;
              if (!isSatisfied(idC, idD)) {
                needed = true;
                break;
              }
            }
            if (needed)
              break;
          }
          if (!needed) {
            fIgn.insert(idF);
            progress = true;
            break; // restart the loop with updated fIgn
          }
          // needed=true: fall through to promote the fence pair
        }

        // Promote (a, b) — handles access-access and access-fence pairs.
        auto *iface = a->getDialect()
                          ->getRegisteredInterface<orb::OrbAtomicDialectInterface>();
        if (!iface)
          continue;
        for (auto p : iface->promote(idA, a, idB, b)) {
          int c = iface->cost(p);
          if (c < bestCost) {
            best = p;
            bestCost = c;
            bestIface = iface;
          }
        }
      }

      if (best && bestIface) {
        bestIface->applyPromotion(*best, builder);
        progress = true;
      }
    }

    // Erase ignorable source fences — they are still arm::Relaxed and contribute
    // no ordering; keeping them would generate spurious (no-op) ArmAtomic fences.
    module.walk([&](arm_atomic::AtomicFenceOp fence) {
      auto idAttr = fence->getAttrOfType<IntegerAttr>(orb::kEventIdAttr);
      if (idAttr && fIgn.count(static_cast<uint64_t>(idAttr.getInt())))
        fence->erase();
    });
  }
};

} // namespace
} // namespace mlir
