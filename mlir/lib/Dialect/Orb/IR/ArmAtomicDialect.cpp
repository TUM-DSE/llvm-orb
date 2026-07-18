//===- ArmAtomicOps.cpp - MLIRArmAtomic ops implementation ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the ArmAtomic dialect and its operations.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Orb/ArmAtomicDialect.h"
#include "mlir/Dialect/Ptr/IR/PtrTypes.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

using namespace mlir;

#include "mlir/Dialect/Orb/ArmAtomicDialect.cpp.inc"

#include "mlir/Dialect/Orb/ArmAtomicEnums.cpp.inc"

//===----------------------------------------------------------------------===//
// ArmAtomic OrbAtomicDialectInterface implementation
//===----------------------------------------------------------------------===//

namespace {

/// Returns the ArmMemoryOrder of an arm_atomic memory event op.
static arm_atomic::MemoryOrder getArmMemoryOrder(Operation *op) {
  if (auto load = dyn_cast<arm_atomic::AtomicLoadOp>(op))
    return load.getMemoryOrder();
  if (auto store = dyn_cast<arm_atomic::AtomicStoreOp>(op))
    return store.getMemoryOrder();
  if (auto fence = dyn_cast<arm_atomic::AtomicFenceOp>(op))
    return fence.getMemoryOrder();
  llvm_unreachable("not an arm_atomic memory event");
}

struct ArmAtomicOrbInterface : public orb::OrbAtomicDialectInterface {
  explicit ArmAtomicOrbInterface(Dialect *d) : OrbAtomicDialectInterface(d) {}

  bool isMemoryEvent(Operation *op) const override {
    return isa<arm_atomic::AtomicLoadOp, arm_atomic::AtomicStoreOp,
               arm_atomic::AtomicFenceOp>(op);
  }

  orb::EventOrder getOrder(Operation *a, Operation *b,
                           AliasAnalysis &aliasAnalysis,
                           DominanceInfo &dominance) const override {
    if (!isMemoryEvent(a) || !isMemoryEvent(b))
      return orb::EventOrder::Unreachable;
    // Relaxed/relaxed pairs are unordered; all others ordered
    // (stub — full ARM memory model analysis is deferred).
    if (getArmMemoryOrder(a) == arm_atomic::MemoryOrder::Relaxed &&
        getArmMemoryOrder(b) == arm_atomic::MemoryOrder::Relaxed)
      return orb::EventOrder::Unordered;
    return orb::EventOrder::Ordered;
  }

  llvm::SmallVector<orb::Promotion> promote(uint64_t idA, Operation *a,
                                            uint64_t idB,
                                            Operation *b) const override {
    if (!isMemoryEvent(a) || !isMemoryEvent(b))
      return {};
    llvm::SmallVector<orb::Promotion> options;
    // Option 1: upgrade 'a' to a stronger memory order.
    if (isa<arm_atomic::AtomicLoadOp, arm_atomic::AtomicStoreOp>(a)) {
      orb::Promotion p;
      p.action = orb::Promotion::UpgradeAction{a};
      options.push_back(p);
    }
    // Option 2: insert an arm_atomic fence before 'b'.
    orb::Promotion fence;
    fence.action = orb::Promotion::FenceAction{b};
    options.push_back(fence);
    return options;
  }

  int cost(const orb::Promotion &) const override { return 1; }

  void applyPromotion(const orb::Promotion &p,
                      OpBuilder &builder) const override {
    if (const auto *fa =
            std::get_if<orb::Promotion::FenceAction>(&p.action)) {
      builder.setInsertionPoint(fa->insertBefore);
      arm_atomic::AtomicFenceOp::create(builder, fa->insertBefore->getLoc(),
                                        arm_atomic::MemoryOrder::AcqRel,
                                        /*syncscope=*/StringAttr{});
    } else if (const auto *ua =
                   std::get_if<orb::Promotion::UpgradeAction>(&p.action)) {
      if (auto load = dyn_cast<arm_atomic::AtomicLoadOp>(ua->op))
        load.setMemoryOrder(arm_atomic::MemoryOrder::Acquire);
      else if (auto store = dyn_cast<arm_atomic::AtomicStoreOp>(ua->op))
        store.setMemoryOrder(arm_atomic::MemoryOrder::Release);
      else if (auto fence = dyn_cast<arm_atomic::AtomicFenceOp>(ua->op))
        fence.setMemoryOrder(arm_atomic::MemoryOrder::AcqRel);
    }
  }
};

} // namespace

void arm_atomic::ArmAtomicDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/Orb/ArmAtomic.cpp.inc"
      >();
  addInterfaces<ArmAtomicOrbInterface>();
}

#define GET_OP_CLASSES
#include "mlir/Dialect/Orb/ArmAtomic.cpp.inc"

//===----------------------------------------------------------------------===//
// MemoryEffects implementations
//===----------------------------------------------------------------------===//

using EffectVec =
    SmallVectorImpl<SideEffects::EffectInstance<MemoryEffects::Effect>>;

void arm_atomic::AtomicLoadOp::getEffects(EffectVec &effects) {
  effects.emplace_back(MemoryEffects::Read::get(), &getAddrMutable());
  effects.emplace_back(MemoryEffects::Read::get());
  effects.emplace_back(MemoryEffects::Write::get());
}

void arm_atomic::AtomicStoreOp::getEffects(EffectVec &effects) {
  effects.emplace_back(MemoryEffects::Write::get(), &getAddrMutable());
  effects.emplace_back(MemoryEffects::Read::get());
  effects.emplace_back(MemoryEffects::Write::get());
}

void arm_atomic::AtomicFenceOp::getEffects(EffectVec &effects) {
  effects.emplace_back(MemoryEffects::Read::get());
  effects.emplace_back(MemoryEffects::Write::get());
}
