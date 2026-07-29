//===- OrderAnalysis.cpp - Atomic ordering analysis pass ------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Conversion/CppAtomicToArmAtomic/OrderAnalysis.h"
#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/Pass/Pass.h"

namespace mlir {

#define GEN_PASS_DEF_ORDERANALYSISPASS
#include "mlir/Conversion/Passes.h.inc"

namespace {

struct OrderAnalysisPass
    : impl::OrderAnalysisPassBase<OrderAnalysisPass> {
  using Base::Base;

  void runOnOperation() override {
    ModuleOp module = getOperation();
    // Assign stable IDs before the analysis computes the matrix.
    orb::assignEventIds(module);
    // Force computation and caching of OrderAnalysis.
    // Mark it preserved so it survives this pass and subsequent passes until
    // FenceSynthesisPass reads it.
    getAnalysis<orb::OrderAnalysis>();
    markAnalysesPreserved<orb::OrderAnalysis>();
  }
};

} // namespace
} // namespace mlir
