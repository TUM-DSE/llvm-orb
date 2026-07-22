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
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

using namespace mlir;

#include "mlir/Dialect/Orb/ArmAtomicDialect.cpp.inc"

#include "mlir/Dialect/Orb/ArmAtomicEnums.cpp.inc"

//===----------------------------------------------------------------------===//
// ArmAtomic OrbAtomicDialectInterface implementation
//===----------------------------------------------------------------------===//

namespace {

/// BFS over def-use chains from `sources`, looking for `target` (an operand
/// of `b`). Three early-exit / pruning conditions:
///
///  1. Ctrl dependency: if any terminator uses a dependent value and b's block
///     is reachable from that branch, the access is ctrl-dependent → ordered.
///  2. Forward reachability: skip users whose block cannot reach b's block
///     (precomputed backward BFS from b's block on the predecessor graph).
///  3. Max steps: hard cap to bound compile time.
static constexpr int kMaxDepSteps = 256;

static bool transitivelyReaches(ValueRange sources, Value target, Operation *b,
                                 int maxOps = kMaxDepSteps) {
  // Precompute blocks that can reach b's block (backward BFS on predecessors).
  Block *targetBlock = b->getBlock();
  llvm::SmallPtrSet<Block *, 16> canReachTarget;
  {
    llvm::SmallVector<Block *> rBFS = {targetBlock};
    while (!rBFS.empty()) {
      Block *blk = rBFS.pop_back_val();
      if (!canReachTarget.insert(blk).second)
        continue;
      for (Block *pred : blk->getPredecessors())
        rBFS.push_back(pred);
    }
  }

  llvm::SmallPtrSet<Value, 32> visited;
  llvm::SmallVector<Value> worklist(sources.begin(), sources.end());
  int steps = 0;
  while (!worklist.empty() && steps < maxOps) {
    Value v = worklist.pop_back_val();
    if (!visited.insert(v).second)
      continue;
    ++steps;
    if (v == target)
      return true;
    for (Operation *user : v.getUsers()) {
      Block *userBlock = user->getBlock();
      // Pruning 2: skip subtrees that can never reach b.
      if (!canReachTarget.count(userBlock))
        continue;
      // Pruning 1: ctrl dependency — terminator branches toward b.
      if (user == userBlock->getTerminator() && userBlock != targetBlock)
        return true;
      for (Value result : user->getResults())
        worklist.push_back(result);
    }
  }
  return false;
}

/// Returns the ArmMemoryOrder of an arm_atomic memory event op.
static arm_atomic::MemoryOrder getArmMemoryOrder(Operation *op) {
  // There is no MO_na in Arm
  if (isa<ptr::LoadOp, ptr::StoreOp>(op))
    return arm_atomic::MemoryOrder::Relaxed;
  if (auto load = dyn_cast<arm_atomic::AtomicLoadOp>(op))
    return load.getMemoryOrder();
  if (auto store = dyn_cast<arm_atomic::AtomicStoreOp>(op))
    return store.getMemoryOrder();
  // NOTE: we reuse MO_acq for dmb ld, MO_rel for dmb st, and MO_acqrel for dmb (full)
  if (auto fence = dyn_cast<arm_atomic::AtomicFenceOp>(op))
    return fence.getMemoryOrder();
  llvm_unreachable("not an arm_atomic memory event");
}

struct ArmAtomicOrbInterface : public orb::OrbAtomicDialectInterface {
  explicit ArmAtomicOrbInterface(Dialect *d) : OrbAtomicDialectInterface(d) {}

  bool isMemoryEvent(Operation *op) const override {
    return isa<arm_atomic::AtomicLoadOp, arm_atomic::AtomicStoreOp,
               arm_atomic::AtomicFenceOp, ptr::LoadOp, ptr::StoreOp>(op);
  }

  /// ppo_arm = lob | pick-lob for ARMv8
  ///
  /// dtrm: dependency through register or memory
  /// iico_ctrl: internal control (CAS | SELECT)
  /// lrrs: local register read successor
  ///
  /// Local memory write successor
  /// NOTE: As a target-dialect this OVER-approximates executions.
  /// Thus po-loc, means any po that is must-alias.
  /// lmws            = [M];po-loc;[W]
  ///
  /// Local memory read successor
  /// NOTE: we OVER-approximate. So this needs to check the next po-earlier may-alias
  /// lmrs            = [W];(po-loc & ~(intervening(W, po-loc));[R]
  ///
  /// dtrm            = (iico_data | lmrs | lrrs)*
  ///
  /// Syntactic dependencies
  /// addr            = [R];dtrm & po;[Rreg]; iico_addr & ii_data;[M]
  /// data            = [R];dtrm & po;[Rreg]; iico_data & ii_data;[W]
  /// ctrl            = [R];dtrm & po;[Rreg]; iico_data;[BCC];po
  ///
  /// Order from CAS and SELECT
  /// pick-dtrm       = (dtrm | iico_ctrl)*
  ///
  /// Pick dependencies
  /// pick-basic-dep  = [R];pick-dtrm
  /// pick-addr       = [R];pick-dtrm & po;[Rreg]; iico_addr & ii_data;[M]
  /// pick-data       = [R];pick-dtrm & po;[Rreg]; iico_data & ii_data;[W]
  /// pick-ctrl       = [R];pick-dtrm & po;[Rreg]; iico_data;[BCC];po
  ///
  /// pick-dep        = (pick-basic-dep | pick-addr | pick-data | pick-ctrl) & ~same-instr
  ///
  /// pick-lob = pick-dep;lob;[W]
  ///
  /// Locally ordered before (What we actually care about)
  /// lob             = (lmws | dob | pob | aob | bob)*
  ///
  /// Dependency ordered before
  /// dob             = addr | data | ctrl;[W] | addr;po;[W] | addr;lmrs | data;lmrs
  ///
  /// Pick ordered before
  /// IGNORED
  ///
  /// Atomic ordered before
  /// aob             = rmw | rmw;lmrs;[R & (ACQ | ACQPC)]
  ///
  /// Barrier ordered before
  /// bob1            = [codom([R & ACQ];amo;[W & REL])];po
  ///                 | [W & REL];po;[R & ACQ]
  ///                 | po;[W & REL] | [R & (ACQ | ACQ-PC)];po
  ///
  /// NOTE: again split fences
  /// bob2            = po;[F & ACQREL]         // 1
  ///                 | [F & ACQREL];po         // 2
  ///                 | [R];po;[F & ACQ]        // 3
  ///                 | [F & ACQ];po            // 4
  ///                 | [W];po;[F & REL]        // 5
  ///                 | [F & REL];po;[W]        // 6

  bool try_order_bob1(Operation *a, Operation *b, AliasAnalysis &AA,
                      DominanceInfo &DI, orb::EventOrder &ret) const {
    // [R & (ACQ | ACQPC | ACQREL)];po
    if (isa<arm_atomic::AtomicLoadOp>(a)) {
      auto mo = getArmMemoryOrder(a);
      if (mo == arm_atomic::MemoryOrder::Acquire ||
          mo == arm_atomic::MemoryOrder::AcquirePC ||
          mo == arm_atomic::MemoryOrder::AcqRel) {
        ret = orb::EventOrder::Ordered;
        return true;
      }
    }
    // po;[W & (REL | ACQREL)]
    if (isa<arm_atomic::AtomicStoreOp>(b)) {
      auto mo = getArmMemoryOrder(b);
      if (mo == arm_atomic::MemoryOrder::Release ||
          mo == arm_atomic::MemoryOrder::AcqRel) {
        ret = orb::EventOrder::Ordered;
        return true;
      }
    }
    return false;
  }

  orb::EventOrder try_order_bob2(Operation *a, Operation *b) const {
    if (isa<arm_atomic::AtomicFenceOp>(a)) {
      auto mof = getArmMemoryOrder(a);
      // [F & (ACQREL | ACQ)];po — rules 2, 4
      if (mof == arm_atomic::MemoryOrder::AcqRel ||
          mof == arm_atomic::MemoryOrder::Acquire)
        return orb::EventOrder::Ordered;
      // [F & REL];po;[W] — rule 6
      if (mof == arm_atomic::MemoryOrder::Release &&
          isa<arm_atomic::AtomicStoreOp, ptr::StoreOp>(b))
        return orb::EventOrder::Ordered;
    }
    if (isa<arm_atomic::AtomicFenceOp>(b)) {
      auto mof = getArmMemoryOrder(b);
      // po;[F & ACQREL] — rule 1
      if (mof == arm_atomic::MemoryOrder::AcqRel)
        return orb::EventOrder::Ordered;
      // [R];po;[F & ACQ] — rule 3
      if (mof == arm_atomic::MemoryOrder::Acquire &&
          isa<arm_atomic::AtomicLoadOp, ptr::LoadOp>(a))
        return orb::EventOrder::Ordered;
      // [W];po;[F & REL] — rule 5
      if (mof == arm_atomic::MemoryOrder::Release &&
          isa<arm_atomic::AtomicStoreOp, ptr::StoreOp>(a))
        return orb::EventOrder::Ordered;
    }
    return orb::EventOrder::Unordered;
  }

  bool try_order_dob(Operation *a, Operation *b, AliasAnalysis &AA,
                     DominanceInfo &DI, orb::EventOrder &ret) const {
    // addr and data deps require 'a' to be a read
    if (!isa<arm_atomic::AtomicLoadOp, ptr::LoadOp>(a))
      return false;
    ValueRange sources = a->getResults();

    // Address operand of b
    Value addr;
    if (auto op = dyn_cast<arm_atomic::AtomicLoadOp>(b))
      addr = op.getAddr();
    else if (auto op = dyn_cast<arm_atomic::AtomicStoreOp>(b))
      addr = op.getAddr();
    else if (auto op = dyn_cast<ptr::LoadOp>(b))
      addr = op.getPtr();
    else if (auto op = dyn_cast<ptr::StoreOp>(b))
      addr = op.getPtr();

    if (addr && transitivelyReaches(sources, addr, b)) {
      ret = orb::EventOrder::Ordered;
      return true;
    }

    // Data operand of b (stores only)
    Value data;
    if (auto op = dyn_cast<arm_atomic::AtomicStoreOp>(b))
      data = op.getValue();
    else if (auto op = dyn_cast<ptr::StoreOp>(b))
      data = op.getValue();

    if (data && transitivelyReaches(sources, data, b)) {
      ret = orb::EventOrder::Ordered;
      return true;
    }

    return false;
  }

  orb::EventOrder getOrder(Operation *a, Operation *b,
                           AliasAnalysis &aliasAnalysis,
                           DominanceInfo &dominance) const override {
    if (!isMemoryEvent(a) || !isMemoryEvent(b))
      return orb::EventOrder::Unreachable;

    if (!dominance.dominates(a,b) && !a->getBlock()->isReachable(b->getBlock()))
      return orb::EventOrder::Unreachable;

    if (isa<arm_atomic::AtomicFenceOp>(a) || isa<arm_atomic::AtomicFenceOp>(b))
      return try_order_bob2(a,b);

    orb::EventOrder ret;
    if (try_order_dob(a, b, aliasAnalysis, dominance, ret))
      return ret;
    if (try_order_bob1(a, b, aliasAnalysis, dominance, ret))
      return ret;
    // aob ...

    return orb::EventOrder::Unordered;
  }

  orb::EventOrder getOrderThroughFence(Operation *a, Operation *f, Operation *b,
                                       DominanceInfo &dom) const override {
    if (!isa<arm_atomic::AtomicFenceOp>(f))
      return orb::EventOrder::Unordered;
    if (!dom.dominates(a, f) || !dom.dominates(f, b))
      return orb::EventOrder::Unreachable;

    auto mof = getArmMemoryOrder(f);
    bool aIsRead  = isa<arm_atomic::AtomicLoadOp,  ptr::LoadOp>(a);
    bool aIsWrite = isa<arm_atomic::AtomicStoreOp, ptr::StoreOp>(a);
    bool bIsWrite = isa<arm_atomic::AtomicStoreOp, ptr::StoreOp>(b);

    // Pair 1&2: DMB SY — any a, any b
    if (mof == arm_atomic::MemoryOrder::AcqRel)
      return orb::EventOrder::Ordered;
    // Pair 3&4: DMB LD — a is Read, any b
    if (mof == arm_atomic::MemoryOrder::Acquire && aIsRead)
      return orb::EventOrder::Ordered;
    // Pair 5&6: DMB ST — a is Write, b is Write
    if (mof == arm_atomic::MemoryOrder::Release && aIsWrite && bIsWrite)
      return orb::EventOrder::Ordered;

    return orb::EventOrder::Unordered;
  }

  llvm::SmallVector<orb::Promotion> promote(uint64_t idA, Operation *a,
                                            uint64_t idB,
                                            Operation *b) const override {
    if (!isMemoryEvent(a) || !isMemoryEvent(b))
      return {};
    llvm::SmallVector<orb::Promotion> options;
    // Upgrade 'a' in-place (load→Acquire, store→Release, fence→AcqRel).
    if (isa<arm_atomic::AtomicLoadOp, arm_atomic::AtomicStoreOp,
            arm_atomic::AtomicFenceOp>(a)) {
      orb::Promotion p;
      p.action = orb::Promotion::UpgradeAction{a};
      options.push_back(p);
    }
    // Upgrade 'b' in-place — valid for relaxed loads, stores, and fences.
    if (isa<arm_atomic::AtomicLoadOp, arm_atomic::AtomicStoreOp,
            arm_atomic::AtomicFenceOp>(b)) {
      orb::Promotion p;
      p.action = orb::Promotion::UpgradeAction{b};
      options.push_back(p);
    }
    // Insert a new arm_atomic fence before 'b' (only when b is not itself a fence).
    if (!isa<arm_atomic::AtomicFenceOp>(b)) {
      orb::Promotion fence;
      fence.action = orb::Promotion::FenceAction{b};
      options.push_back(fence);
    }
    return options;
  }

  int cost(const orb::Promotion &p) const override {
    if (std::get_if<orb::Promotion::UpgradeAction>(&p.action))
      return 1;
    return 2; // FenceAction
  }

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
