//===- OrbAtomicInterface.cpp - Orb atomic ordering interface implementation ===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/IR/Builders.h"

using namespace mlir;
using namespace mlir::orb;

//===----------------------------------------------------------------------===//
// OrderMatrix
//===----------------------------------------------------------------------===//

EventOrder OrderMatrix::getOrder(uint64_t idA, uint64_t idB) const {
  auto it = data.find({idA, idB});
  return it != data.end() ? it->second : EventOrder::Unreachable;
}

Operation *OrderMatrix::getOpForId(uint64_t id) const {
  auto it = idToOp.find(id);
  return it != idToOp.end() ? it->second : nullptr;
}

//===----------------------------------------------------------------------===//
// assignEventIds
//===----------------------------------------------------------------------===//

void mlir::orb::assignEventIds(ModuleOp module) {
  uint64_t nextId = 0;
  module.walk([&](Operation *op) {
    Dialect *d = op->getDialect();
    bool isOrbEvent =
        d->getRegisteredInterface<OrbAtomicDialectInterface>() &&
        d->getRegisteredInterface<OrbAtomicDialectInterface>()->isMemoryEvent(
            op);
    bool isPtrAccess = isa<ptr::LoadOp, ptr::StoreOp>(op);
    if (isOrbEvent || isPtrAccess) {
      OpBuilder b(op->getContext());
      op->setAttr(kEventIdAttr, b.getI64IntegerAttr(nextId++));
    }
  });
}

//===----------------------------------------------------------------------===//
// getOrderMatrix
//===----------------------------------------------------------------------===//

OrderMatrix mlir::orb::getOrderMatrix(ModuleOp module,
                                      AliasAnalysis &aliasAnalysis,
                                      DominanceInfo &dominance) {
  OrderMatrix result;

  // Collect memory events that carry an orb.event_id.
  module.walk([&](Operation *op) {
    auto idAttr = op->getAttrOfType<IntegerAttr>(kEventIdAttr);
    if (!idAttr)
      return;
    uint64_t id = idAttr.getInt();
    result.ids.push_back(id);
    result.idToOp[id] = op;
  });

  // Fill matrix: O(n^2) over collected events.
  for (uint64_t idA : result.ids) {
    for (uint64_t idB : result.ids) {
      if (idA == idB)
        continue;
      Operation *a = result.idToOp[idA];
      Operation *b = result.idToOp[idB];
      auto *ia =
          a->getDialect()->getRegisteredInterface<OrbAtomicDialectInterface>();
      auto *ib =
          b->getDialect()->getRegisteredInterface<OrbAtomicDialectInterface>();
      // Ask the dialect owning 'a' first; fall back to dialect owning 'b'.
      EventOrder order = EventOrder::Unordered;
      if (ia)
        order = ia->getOrder(a, b, aliasAnalysis, dominance);
      if (order == EventOrder::Unordered && ib && ib != ia)
        order = ib->getOrder(a, b, aliasAnalysis, dominance);
      result.data[{idA, idB}] = order;
    }
  }
  return result;
}
