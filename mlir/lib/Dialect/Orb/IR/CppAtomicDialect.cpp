//===- CppAtomicOps.cpp - MLIRCppAtomic ops implementation --------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the CppAtomic dialect and its operations.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Orb/CppAtomicDialect.h"
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

using namespace mlir;

#include "mlir/Dialect/Orb/CppAtomicDialect.cpp.inc"

#include "mlir/Dialect/Orb/CppAtomicEnums.cpp.inc"

//===----------------------------------------------------------------------===//
// CppAtomic OrbAtomicDialectInterface implementation
//===----------------------------------------------------------------------===//

namespace {

/// Returns the MemoryOrder attribute of a cpp_atomic memory event op.
static cpp_atomic::MemoryOrder getCppMemoryOrder(Operation *op) {
  if (auto load = dyn_cast<cpp_atomic::AtomicLoadOp>(op))
    return load.getMemoryOrder();
  if (auto store = dyn_cast<cpp_atomic::AtomicStoreOp>(op))
    return store.getMemoryOrder();
  if (auto fence = dyn_cast<cpp_atomic::AtomicFenceOp>(op))
    return fence.getMemoryOrder();
  llvm_unreachable("not a cpp_atomic memory event");
}

struct CppAtomicOrbInterface : public orb::OrbAtomicDialectInterface {
  explicit CppAtomicOrbInterface(Dialect *d) : OrbAtomicDialectInterface(d) {}

  bool isMemoryEvent(Operation *op) const override {
    return isa<cpp_atomic::AtomicLoadOp, cpp_atomic::AtomicStoreOp,
               cpp_atomic::AtomicFenceOp, ptr::LoadOp, ptr::StoreOp>(op);
  }

  orb::EventOrder getOrder(Operation *a, Operation *b,
                           AliasAnalysis &aliasAnalysis,
                           DominanceInfo &dominance) const override {
    if (!isMemoryEvent(a) || !isMemoryEvent(b))
      return orb::EventOrder::Unreachable;
    // ptr ops are plain (no ordering constraint imposed by the ptr dialect).
    bool aPlain = isa<ptr::LoadOp, ptr::StoreOp>(a);
    bool bPlain = isa<ptr::LoadOp, ptr::StoreOp>(b);
    if (aPlain || bPlain)
      return orb::EventOrder::Unordered;
    // Both cpp_atomic: relaxed/relaxed pairs are unordered; all others ordered
    // (stub — full RC11 sequenced-before analysis is deferred).
    if (getCppMemoryOrder(a) == cpp_atomic::MemoryOrder::Relaxed &&
        getCppMemoryOrder(b) == cpp_atomic::MemoryOrder::Relaxed)
      return orb::EventOrder::Unordered;
    return orb::EventOrder::Ordered;
  }

  llvm::SmallVector<orb::Promotion> promote(uint64_t idA, Operation *a,
                                            uint64_t idB,
                                            Operation *b) const override {
    // Only promote cpp_atomic ops; ptr ops are plain and not upgradeable here.
    if (!isa<cpp_atomic::AtomicLoadOp, cpp_atomic::AtomicStoreOp,
             cpp_atomic::AtomicFenceOp>(a))
      return {};
    if (!isMemoryEvent(b))
      return {};
    llvm::SmallVector<orb::Promotion> options;
    // Option 1: upgrade 'a' to a stronger memory order.
    if (isa<cpp_atomic::AtomicLoadOp, cpp_atomic::AtomicStoreOp>(a)) {
      orb::Promotion p;
      p.action = orb::Promotion::UpgradeAction{a};
      p.newlyOrdered.emplace_back(idA, idB);
      options.push_back(std::move(p));
    }
    // Option 2: insert a cpp_atomic fence before 'b'.
    orb::Promotion fence;
    fence.action = orb::Promotion::FenceAction{b};
    fence.newlyOrdered.emplace_back(idA, idB);
    options.push_back(std::move(fence));
    return options;
  }

  int cost(const orb::Promotion &) const override { return 1; }
};

} // namespace

void cpp_atomic::CppAtomicDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/Orb/CppAtomic.cpp.inc"
      >();
  addInterfaces<CppAtomicOrbInterface>();
}

#define GET_OP_CLASSES
#include "mlir/Dialect/Orb/CppAtomic.cpp.inc"

//===----------------------------------------------------------------------===//
// MemoryEffects implementations
//===----------------------------------------------------------------------===//

using EffectVec =
    SmallVectorImpl<SideEffects::EffectInstance<MemoryEffects::Effect>>;

// Atomic load: reads from addr; ordering constraint imposes global R/W barrier.
void cpp_atomic::AtomicLoadOp::getEffects(EffectVec &effects) {
  effects.emplace_back(MemoryEffects::Read::get(), &getAddrMutable());
  effects.emplace_back(MemoryEffects::Read::get());
  effects.emplace_back(MemoryEffects::Write::get());
}

// Atomic store: writes to addr; ordering constraint imposes global R/W barrier.
void cpp_atomic::AtomicStoreOp::getEffects(EffectVec &effects) {
  effects.emplace_back(MemoryEffects::Write::get(), &getAddrMutable());
  effects.emplace_back(MemoryEffects::Read::get());
  effects.emplace_back(MemoryEffects::Write::get());
}

// Fence: no specific address — full global R/W barrier.
void cpp_atomic::AtomicFenceOp::getEffects(EffectVec &effects) {
  effects.emplace_back(MemoryEffects::Read::get());
  effects.emplace_back(MemoryEffects::Write::get());
}
