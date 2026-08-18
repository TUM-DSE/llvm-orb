//===- ArmAtomicDialect.cpp - ArmAtomic dialect implementation ------------===//
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
#include <limits>

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

/// Returns the address operand of a memory event, or {} for fences.
static Value getMemoryAddress(Operation *op) {
  if (auto ld = dyn_cast<arm_atomic::AtomicLoadOp>(op))  return ld.getAddr();
  if (auto st = dyn_cast<arm_atomic::AtomicStoreOp>(op)) return st.getAddr();
  if (auto ld = dyn_cast<ptr::LoadOp>(op))               return ld.getPtr();
  if (auto st = dyn_cast<ptr::StoreOp>(op))               return st.getPtr();
  return {};
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
    if (isa<arm_atomic::AtomicLoadOp, arm_atomic::AtomicStoreOp,
            arm_atomic::AtomicFenceOp>(op))
      return true;
    if (isa<ptr::LoadOp, ptr::StoreOp>(op))
      return !orb::isStackSlotAccess(op);
    return false;
  }

  bool isFenceEvent(Operation *op) const override {
    return isa<arm_atomic::AtomicFenceOp>(op);
  }

  bool isWriteEvent(Operation *op) const override {
    return isa<arm_atomic::AtomicStoreOp, ptr::StoreOp>(op);
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
  ///                 | [W & REL];po;[R & ACQPC]
  ///                 | po;[W & REL] | [R & (ACQ | ACQPC)];po
  ///
  /// NOTE: again split fences
  /// bob2            = po;[F & ACQREL]         // 1
  ///                 | [F & ACQREL];po         // 2
  ///                 | [R];po;[F & ACQ]        // 3
  ///                 | [F & ACQ];po            // 4
  ///                 | [W];po;[F & REL]        // 5
  ///                 | [F & REL];po;[W]        // 6

  orb::EventOrder tryOrderBob2(Operation *a, Operation *b) const {
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

  bool tryOrderDob(Operation *a, Operation *b, orb::EventOrder &ret) const {
    if (!isa<arm_atomic::AtomicLoadOp, ptr::LoadOp>(a))
      return false;
    ValueRange sources = a->getResults();

    // addr dep
    Value addr;
    if (auto op = dyn_cast<arm_atomic::AtomicLoadOp>(b))  addr = op.getAddr();
    else if (auto op = dyn_cast<arm_atomic::AtomicStoreOp>(b)) addr = op.getAddr();
    else if (auto op = dyn_cast<ptr::LoadOp>(b))          addr = op.getPtr();
    else if (auto op = dyn_cast<ptr::StoreOp>(b))         addr = op.getPtr();
    if (addr && transitivelyReaches(sources, addr, b)) {
      ret = orb::EventOrder::Ordered;
      return true;
    }

    // data dep (stores only)
    Value data;
    if (auto op = dyn_cast<arm_atomic::AtomicStoreOp>(b)) data = op.getValue();
    else if (auto op = dyn_cast<ptr::StoreOp>(b))         data = op.getValue();
    if (data && transitivelyReaches(sources, data, b)) {
      ret = orb::EventOrder::Ordered;
      return true;
    }

    // ctrl;[W]: a's value controls a branch toward b's block, b is a write
    if (isa<arm_atomic::AtomicStoreOp, ptr::StoreOp>(b) &&
        transitivelyReaches(sources, Value{}, b)) {
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

    bool sameRegion = a->getBlock()->getParent() == b->getBlock()->getParent();
    if (sameRegion) {
      if (a->getBlock() == b->getBlock()) {
        if (!dominance.dominates(a, b))
          return orb::EventOrder::Unreachable;
      } else if (!a->getBlock()->isReachable(b->getBlock())) {
        return orb::EventOrder::Unreachable;
      }
    }

    if (isa<arm_atomic::AtomicFenceOp>(a) || isa<arm_atomic::AtomicFenceOp>(b))
      return tryOrderBob2(a, b);

    if (sameRegion) {
      orb::EventOrder ret;
      if (tryOrderDob(a, b, ret))
        return ret;
    }

    // bob1: [R & (ACQ|ACQPC|ACQREL)];po — acquire/acquire-pc orders before all
    // po-successors.
    if (isa<arm_atomic::AtomicLoadOp>(a)) {
      auto mo = getArmMemoryOrder(a);
      if (mo == arm_atomic::MemoryOrder::Acquire ||
          mo == arm_atomic::MemoryOrder::AcquirePC ||
          mo == arm_atomic::MemoryOrder::AcqRel)
        return orb::EventOrder::Ordered;
    }
    // bob1: po;[W & (REL|ACQREL)]
    if (isa<arm_atomic::AtomicStoreOp>(b)) {
      auto mo = getArmMemoryOrder(b);
      if (mo == arm_atomic::MemoryOrder::Release ||
          mo == arm_atomic::MemoryOrder::AcqRel)
        return orb::EventOrder::Ordered;
    }
    // bob: [L];po;[A] — STLR→LDAR ordering (aarch64.cat line 129).
    if (isa<arm_atomic::AtomicStoreOp>(a) && isa<arm_atomic::AtomicLoadOp>(b)) {
      auto moa = getArmMemoryOrder(a);
      auto mob = getArmMemoryOrder(b);
      if ((moa == arm_atomic::MemoryOrder::Release ||
           moa == arm_atomic::MemoryOrder::AcqRel) &&
          (mob == arm_atomic::MemoryOrder::Acquire ||
           mob == arm_atomic::MemoryOrder::AcqRel))
        return orb::EventOrder::Ordered;
    }

    // lwfs: [M];po-loc;[W] — any memory event before a same-address write.
    if (isWriteEvent(b)) {
      Value addrA = getMemoryAddress(a);
      Value addrB = getMemoryAddress(b);
      if (addrA && addrB &&
          (addrA == addrB || aliasAnalysis.alias(addrA, addrB).isMust()))
        return orb::EventOrder::Ordered;
    }

    return orb::EventOrder::Unordered;
  }

  orb::EventOrder getOrderThroughFence(Operation *a, Operation *f,
                                       Operation *b) const override {
    if (!isa<arm_atomic::AtomicFenceOp>(f))
      return orb::EventOrder::Unordered;
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

  /// Promotions for an unordered pair (a, b).
  ///
  /// Access upgrades (from aarch64.cat bob rules):
  ///   [A|Q];po  — load→ACQPC or load→ACQ orders before all successors
  ///   po;[L]    — store→REL orders after all predecessors
  ///   [L];po;[A] — REL store before ACQ load (not ACQPC)
  ///
  /// Fence insertions (from aarch64.cat bob rules):
  ///   DMB LD: [R];po;[*]   DMB ST: [W];po;[W]   DMB SY: [*];po;[*]
  llvm::SmallVector<orb::Promotion> promote(uint64_t idA, Operation *a,
                                            uint64_t idB,
                                            Operation *b) const override {
    if (!isMemoryEvent(a) || !isMemoryEvent(b))
      return {};
    llvm::SmallVector<orb::Promotion> options;

    bool aIsRead  = isa<arm_atomic::AtomicLoadOp, ptr::LoadOp>(a);
    bool aIsWrite = isa<arm_atomic::AtomicStoreOp, ptr::StoreOp>(a);
    bool bIsWrite = isa<arm_atomic::AtomicStoreOp, ptr::StoreOp>(b);

    // --- Access upgrades ---

    // [A|Q];po — load a → ACQPC (LDAPR, cheap) or ACQ (LDAR).
    if (isa<arm_atomic::AtomicLoadOp>(a)) {
      auto mo = getArmMemoryOrder(a);
      if (mo == arm_atomic::MemoryOrder::Relaxed) {
        options.push_back(
            {orb::Promotion::UpgradeAction{a, (int)arm_atomic::MemoryOrder::AcquirePC}});
        options.push_back(
            {orb::Promotion::UpgradeAction{a, (int)arm_atomic::MemoryOrder::Acquire}});
      } else if (mo == arm_atomic::MemoryOrder::AcquirePC) {
        options.push_back(
            {orb::Promotion::UpgradeAction{a, (int)arm_atomic::MemoryOrder::Acquire}});
      }
    }

    // po;[L] — store b → REL (STLR).
    if (isa<arm_atomic::AtomicStoreOp>(b)) {
      auto mo = getArmMemoryOrder(b);
      if (mo != arm_atomic::MemoryOrder::Release &&
          mo != arm_atomic::MemoryOrder::AcqRel)
        options.push_back(
            {orb::Promotion::UpgradeAction{b, (int)arm_atomic::MemoryOrder::Release}});
    }

    // store a, load b → paired REL+ACQPC (po;[L] + [Q];po in one step).
    if (isa<arm_atomic::AtomicStoreOp>(a) && isa<arm_atomic::AtomicLoadOp>(b)) {
      auto moA = getArmMemoryOrder(a);
      auto moB = getArmMemoryOrder(b);
      bool aIsREL = moA == arm_atomic::MemoryOrder::Release ||
                    moA == arm_atomic::MemoryOrder::AcqRel;
      bool bIsAcq = moB == arm_atomic::MemoryOrder::AcquirePC ||
                    moB == arm_atomic::MemoryOrder::Acquire ||
                    moB == arm_atomic::MemoryOrder::AcqRel;
      if (!aIsREL && !bIsAcq)
        options.push_back({orb::Promotion::PairUpgradeAction{
            a, (int)arm_atomic::MemoryOrder::Release,
            b, (int)arm_atomic::MemoryOrder::AcquirePC}});
      else if (!aIsREL)
        options.push_back(
            {orb::Promotion::UpgradeAction{a, (int)arm_atomic::MemoryOrder::Release}});
      else if (!bIsAcq)
        options.push_back(
            {orb::Promotion::UpgradeAction{b, (int)arm_atomic::MemoryOrder::AcquirePC}});
      // [L];po;[A]: offer upgrade path toward STLR→LDAR ordering.
      if (moB != arm_atomic::MemoryOrder::Acquire &&
          moB != arm_atomic::MemoryOrder::AcqRel) {
        if (aIsREL)
          options.push_back(
              {orb::Promotion::UpgradeAction{b, (int)arm_atomic::MemoryOrder::Acquire}});
        else
          options.push_back({orb::Promotion::PairUpgradeAction{
              a, (int)arm_atomic::MemoryOrder::Release,
              b, (int)arm_atomic::MemoryOrder::Acquire}});
      } else if (aIsREL) {
        // [L];po;[A] already satisfied but matrix may not reflect it
        // (upgrades arrived in separate iterations). Empty upgrade lets
        // the synthesis loop fix the matrix at cost 0.
        options.push_back({orb::Promotion::EmptyUpgradeAction{}});
      }
    }

    // --- Fence upgrades ---

    for (Operation *fenceOp : {a, b}) {
      auto fence = dyn_cast<arm_atomic::AtomicFenceOp>(fenceOp);
      if (!fence)
        continue;
      auto curMO = fence.getMemoryOrder();
      if (curMO == arm_atomic::MemoryOrder::Relaxed) {
        for (auto mo : {arm_atomic::MemoryOrder::Acquire,
                        arm_atomic::MemoryOrder::Release,
                        arm_atomic::MemoryOrder::AcqRel})
          options.push_back({orb::Promotion::UpgradeAction{fenceOp, (int)mo}});
      } else if (curMO != arm_atomic::MemoryOrder::AcqRel) {
        options.push_back(
            {orb::Promotion::UpgradeAction{fenceOp,
                                           (int)arm_atomic::MemoryOrder::AcqRel}});
      }
    }

    // --- Fence insertions ---

    llvm::SmallVector<arm_atomic::MemoryOrder, 3> fenceMOs;
    if (aIsRead)
      fenceMOs.push_back(arm_atomic::MemoryOrder::Acquire);   // DMB LD
    if (aIsWrite && bIsWrite)
      fenceMOs.push_back(arm_atomic::MemoryOrder::Release);   // DMB ST
    fenceMOs.push_back(arm_atomic::MemoryOrder::AcqRel);      // DMB SY

    for (auto fenceMO : fenceMOs) {
      int mo = static_cast<int>(fenceMO);
      if (!isa<arm_atomic::AtomicFenceOp>(a) && a->getNextNode())
        options.push_back({orb::Promotion::FenceAction{a->getNextNode(), mo}});
      if (!isa<arm_atomic::AtomicFenceOp>(b) && b->getPrevNode())
        options.push_back({orb::Promotion::FenceAction{b, mo}});
    }

    return options;
  }

  /// Cost model for promotions.
  ///
  /// Access upgrades: base = 1000/coverage + collateral.
  ///   ACQPC is 1 cheaper than ACQ (same [A|Q];po coverage, cheaper hardware).
  ///   Both scale with loop depth (K=1).
  ///
  /// Fences: base = fenceCostBase * hwMult * 1000/coverage.
  ///   New insertion gets +1 over upgrade (prefer upgrading existing fences).
  ///   Scale aggressively with loop depth (K=4).
  ///
  /// EmptyUpgrade: cost = 0 (matrix catch-up, no IR change).
  /// PairUpgrade: cost = sum of the two component upgrade costs.
  int cost(const orb::Promotion &p, const orb::CostContext &ctx) const override {
    if (std::get_if<orb::Promotion::EmptyUpgradeAction>(&p.action))
      return 0;

    // --- Shared helpers ---
    auto collateral = [&](unsigned covered) -> int {
      if (ctx.numEvents <= 1) return 0;
      int waste = (int)ctx.numEvents - 1 - (int)covered;
      return waste > 0 ? 1000 * waste / ((int)ctx.numEvents - 1) : 0;
    };
    int loopMult = 1 + (int)p.loopDepth;

    // --- PairUpgrade: combined cost of store→REL + load→ACQPC ---
    if (std::get_if<orb::Promotion::PairUpgradeAction>(&p.action)) {
      int loadCost = (1000 / (int)std::max(ctx.rowPressure, 1u)
                      + collateral(ctx.rowPressure) - 1) * loopMult;
      int storeCost = (1000 / (int)std::max(ctx.colPressure, 1u)
                       + collateral(ctx.colPressure)) * loopMult * 3;
      return loadCost + storeCost;
    }

    const auto *ua = std::get_if<orb::Promotion::UpgradeAction>(&p.action);

    // --- Fence cost (insertion or upgrade) ---
    auto fenceCost = [&](arm_atomic::MemoryOrder fmo, bool isNew) -> int {
      unsigned cov, hw;
      switch (fmo) {
      case arm_atomic::MemoryOrder::Acquire: // DMB LD: [R];po;[*]
        cov = std::max(ctx.rowPressure + ctx.colReadPressure, 1u);
        if (ctx.colWritePressure < cov) cov -= ctx.colWritePressure; else cov = 1u;
        hw = 1; break;
      case arm_atomic::MemoryOrder::Release: // DMB ST: [W];po;[W]
        cov = std::max(ctx.rowWritePressure + ctx.colWritePressure, 1u);
        if (ctx.colReadPressure < cov) cov -= ctx.colReadPressure; else cov = 1u;
        hw = 1; break;
      default: // DMB SY: [*];po;[*]
        cov = std::max(ctx.rowPressure + ctx.colPressure, 1u);
        hw = 2; break;
      }
      long long raw = (long long)ctx.fenceCostBase * hw * 1000 / cov + (isNew ? 1 : 0);
      raw *= (1 + p.loopDepth * 4);
      return (int)std::min(raw, (long long)std::numeric_limits<int>::max());
    };

    if (!ua) {
      const auto &fa = std::get<orb::Promotion::FenceAction>(p.action);
      return fenceCost(static_cast<arm_atomic::MemoryOrder>(fa.memoryOrder), true);
    }
    auto mo = static_cast<arm_atomic::MemoryOrder>(ua->targetMemoryOrder);
    if (isa<arm_atomic::AtomicFenceOp>(ua->op))
      return fenceCost(mo, false);

    // --- Access upgrade cost ---
    switch (mo) {
    case arm_atomic::MemoryOrder::AcquirePC: // LDAPR — cheaper than LDAR
      return (1000 / (int)std::max(ctx.rowPressure, 1u) + collateral(ctx.rowPressure) - 1) * loopMult;
    case arm_atomic::MemoryOrder::Acquire:   // LDAR
      return (1000 / (int)std::max(ctx.rowPressure, 1u) + collateral(ctx.rowPressure)) * loopMult;
    case arm_atomic::MemoryOrder::Release:   // STLR — store buffer drain, costlier than LDAPR
      return (1000 / (int)std::max(ctx.colPressure, 1u) + collateral(ctx.colPressure)) * loopMult * 3;
    default: { // AcqRel
      unsigned cov = std::max(ctx.rowPressure + ctx.colPressure, 1u);
      return (1000 / (int)cov + collateral(cov)) * loopMult;
    }
    }
  }

  Operation *applyPromotion(const orb::Promotion &p,
                            OpBuilder &builder) const override {
    if (std::get_if<orb::Promotion::EmptyUpgradeAction>(&p.action))
      return nullptr;
    if (const auto *fa =
            std::get_if<orb::Promotion::FenceAction>(&p.action)) {
      auto mo = static_cast<arm_atomic::MemoryOrder>(fa->memoryOrder);
      builder.setInsertionPoint(fa->insertBefore);
      return arm_atomic::AtomicFenceOp::create(builder,
                                               fa->insertBefore->getLoc(),
                                               mo, /*syncscope=*/StringAttr{});
    }
    if (const auto *pa =
            std::get_if<orb::Promotion::PairUpgradeAction>(&p.action)) {
      if (auto store = dyn_cast<arm_atomic::AtomicStoreOp>(pa->op1))
        store.setMemoryOrder(
            static_cast<arm_atomic::MemoryOrder>(pa->targetMemoryOrder1));
      if (auto load = dyn_cast<arm_atomic::AtomicLoadOp>(pa->op2))
        load.setMemoryOrder(
            static_cast<arm_atomic::MemoryOrder>(pa->targetMemoryOrder2));
      return nullptr;
    }
    if (const auto *ua =
            std::get_if<orb::Promotion::UpgradeAction>(&p.action)) {
      auto mo = static_cast<arm_atomic::MemoryOrder>(ua->targetMemoryOrder);
      if (auto load = dyn_cast<arm_atomic::AtomicLoadOp>(ua->op))
        load.setMemoryOrder(mo);
      else if (auto store = dyn_cast<arm_atomic::AtomicStoreOp>(ua->op))
        store.setMemoryOrder(mo);
      else if (auto fence = dyn_cast<arm_atomic::AtomicFenceOp>(ua->op))
        fence.setMemoryOrder(mo);
    }
    return nullptr;
  }

  // ctrl;[W] cross-call: load in caller controls (via branch) whether a callee call runs.
  orb::EventOrder getOrderCrossRegion(Operation *a, Operation *b,
                                      AliasAnalysis &aa, DominanceInfo &dom,
                                      const orb::CallReachability &reach) const override {
    if (!isa<arm_atomic::AtomicLoadOp, ptr::LoadOp>(a))
      return orb::EventOrder::Unordered;
    if (!isa<arm_atomic::AtomicStoreOp, ptr::StoreOp>(b))
      return orb::EventOrder::Unordered;

    Region *fromRegion = a->getBlock()->getParent();
    Region *toRegion   = b->getBlock()->getParent();
    auto it = reach.directCalls.find({fromRegion, toRegion});
    if (it == reach.directCalls.end())
      return orb::EventOrder::Unordered;

    ValueRange sources = a->getResults();
    if (sources.empty())
      return orb::EventOrder::Unordered;

    for (Operation *callOp : it->second) {
      if (!dom.dominates(a, callOp))
        continue;
      if (transitivelyReaches(sources, Value{}, callOp))
        return orb::EventOrder::Ordered;
    }
    return orb::EventOrder::Unordered;
  }

  /// Incrementally update the order matrix after applying a promotion.
  ///
  /// Bob rules applied:
  ///   [A|Q];po  — ACQ/ACQPC load orders before all successors
  ///   po;[L]    — REL store orders after all predecessors
  ///   [L];po;[A] — REL store → ACQ load (not ACQPC)
  void updateOrderMatrix(const orb::Promotion &p, Operation *newOp,
                         uint64_t idA, uint64_t idB, orb::OrderMatrix &mb,
                         AliasAnalysis &aa, DominanceInfo &dom,
                         const orb::CallReachability &reach) const override {
    if (std::get_if<orb::Promotion::EmptyUpgradeAction>(&p.action)) {
      // Matrix catch-up: mark (idA, idB) ordered.
      mb.markOrdered(idA, idB);
      return;
    }
    if (std::get_if<orb::Promotion::FenceAction>(&p.action)) {
      mb.addFence(newOp, this, aa, dom, reach);
      return;
    }
    // PairUpgradeAction: apply po;[L] + [A|Q];po.
    if (const auto *pa =
            std::get_if<orb::Promotion::PairUpgradeAction>(&p.action)) {
      uint64_t storeId = (pa->op1 == mb.getOpForId(idA)) ? idA : idB;
      uint64_t loadId  = (pa->op2 == mb.getOpForId(idA)) ? idA : idB;
      for (uint64_t x : mb.eventIds())
        mb.markOrdered(x, storeId);   // po;[L]
      for (uint64_t x : mb.eventIds())
        mb.markOrdered(loadId, x);    // [Q];po
      return;
    }

    const auto &ua = std::get<orb::Promotion::UpgradeAction>(p.action);
    auto mo = static_cast<arm_atomic::MemoryOrder>(ua.targetMemoryOrder);

    if (isa<arm_atomic::AtomicLoadOp>(ua.op)) {
      uint64_t loadId = (ua.op == mb.getOpForId(idA)) ? idA : idB;
      // [A|Q];po
      for (uint64_t x : mb.eventIds())
        mb.markOrdered(loadId, x);
      // [L];po;[A] — only for ACQ, not ACQPC.
      if (mo == arm_atomic::MemoryOrder::Acquire ||
          mo == arm_atomic::MemoryOrder::AcqRel) {
        for (uint64_t x : mb.eventIds()) {
          Operation *op = mb.getOpForId(x);
          if (!isa<arm_atomic::AtomicStoreOp>(op)) continue;
          auto xmo = getArmMemoryOrder(op);
          if (xmo == arm_atomic::MemoryOrder::Release ||
              xmo == arm_atomic::MemoryOrder::AcqRel)
            mb.markOrdered(x, loadId);
        }
      }
    } else if (isa<arm_atomic::AtomicStoreOp>(ua.op)) {
      uint64_t storeId = (ua.op == mb.getOpForId(idA)) ? idA : idB;
      // po;[L]
      for (uint64_t x : mb.eventIds())
        mb.markOrdered(x, storeId);
      // [L];po;[A] — mark ACQ load successors.
      for (uint64_t x : mb.eventIds()) {
        Operation *op = mb.getOpForId(x);
        if (!isa<arm_atomic::AtomicLoadOp>(op)) continue;
        auto xmo = getArmMemoryOrder(op);
        if (xmo == arm_atomic::MemoryOrder::Acquire ||
            xmo == arm_atomic::MemoryOrder::AcqRel)
          mb.markOrdered(storeId, x);
      }
    } else {
      uint64_t fId = (ua.op == mb.getOpForId(idA)) ? idA : idB;
      mb.applyFenceUpgrade(mb.idxOf(fId), this, aa, dom, reach);
    }
  }

  void refineInitialOrderMatrix(orb::OrderMatrix &matrix) const override {
    // matrix.closeTransitively(4); // disabled temporarily
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
