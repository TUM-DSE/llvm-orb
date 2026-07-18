//===- FenceSynthesis.cpp - Atomic fence synthesis pass -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/ArmAtomicToLLVM/FenceSynthesis.h"
#include "mlir/Analysis/AliasAnalysis.h"
#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Pass/Pass.h"

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

    bool progress = true;
    while (progress) {
      progress = false;
      orb::OrderMatrix current = orb::getOrderMatrix(module, aa, dom);

      std::optional<orb::Promotion> best;
      int bestCost = INT_MAX;
      orb::OrbAtomicDialectInterface *bestIface = nullptr;

      for (auto [idA, idB] : required.requiredPairs()) {
        if (current.getOrder(idA, idB) == orb::EventOrder::Ordered)
          continue;

        Operation *a = current.getOpForId(idA);
        Operation *b = current.getOpForId(idB);
        if (!a || !b)
          continue;

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
  }
};

} // namespace
} // namespace mlir
