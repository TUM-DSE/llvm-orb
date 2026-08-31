//===- CppAtomicDialect.cpp - CppAtomic dialect implementation ----------------===//
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
#include "mlir/IR/DialectImplementation.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

using namespace mlir;

#include "mlir/Dialect/Orb/CppAtomicDialect.cpp.inc"

#include "mlir/Dialect/Orb/CppAtomicEnums.cpp.inc"

//===----------------------------------------------------------------------===//
// CppAtomicDialect attribute parsing/printing
//===----------------------------------------------------------------------===//

::mlir::Attribute cpp_atomic::CppAtomicDialect::parseAttribute(
    ::mlir::DialectAsmParser &parser, ::mlir::Type) const {
  llvm::StringRef mnemonic;
  if (parser.parseKeyword(&mnemonic))
    return {};
  if (mnemonic == "memory_order") {
    if (parser.parseLess())
      return {};
    auto mo = FieldParser<cpp_atomic::MemoryOrder, cpp_atomic::MemoryOrder>::parse(parser);
    if (failed(mo))
      return {};
    if (parser.parseGreater())
      return {};
    return cpp_atomic::MemoryOrderAttr::get(parser.getContext(), *mo);
  }
  parser.emitError(parser.getNameLoc()) << "unknown cpp_atomic attribute: " << mnemonic;
  return {};
}

void cpp_atomic::CppAtomicDialect::printAttribute(
    ::mlir::Attribute attr, ::mlir::DialectAsmPrinter &printer) const {
  if (auto mo = ::mlir::dyn_cast<cpp_atomic::MemoryOrderAttr>(attr)) {
    printer << "memory_order<" << stringifyMemoryOrder(mo.getValue()) << ">";
  }
}

//===----------------------------------------------------------------------===//
// CppAtomic OrbAtomicDialectInterface implementation
//===----------------------------------------------------------------------===//

namespace {

/// Returns the MemoryOrder attribute of a cpp_atomic memory event op.
static cpp_atomic::MemoryOrder getCppMemoryOrder(Operation *op) {
  if (isa<ptr::LoadOp, ptr::StoreOp>(op))
    return cpp_atomic::MemoryOrder::NA;
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
    if (isa<cpp_atomic::AtomicLoadOp, cpp_atomic::AtomicStoreOp,
            cpp_atomic::AtomicFenceOp>(op))
      return true;
    if (isa<ptr::LoadOp, ptr::StoreOp>(op))
      return !orb::isStackSlotAccess(op);
    return false;
  }

  bool isFenceEvent(Operation *op) const override {
    return isa<cpp_atomic::AtomicFenceOp>(op);
  }

  /// ppo_rc11 for order

  /// Local order based on memory order annotations
  /// ppo_fence1  = [R & (ACQ | ACQREL | SC)];po
  ///             | po;[W & (REL | ACQREL | SC)]
  ///
  /// Local order from fences
  /// NOTE: pairwise split, 1 only pairs with 2, 3 only with 4, 5 with 6
  /// We do not care about order to fences, but their "transitive" order between access pairs
  /// ppo_fence2  = [R];po;[F & (ACQ | ACQREL | SC)]  // 1
  ///             | [F & (ACQ | ACQREL | SC)];po      // 2
  ///             | po;[F & (REL | ACQREL | SC)]      // 3
  ///             | [F & (REL | ACQREL | SC)];po;[W]  // 4
  ///             | po;[F & (ACQREL | SC)]            // 5
  ///             | [F & (ACQREL | SC)];po            // 6
  ///
  /// Local order approxiamting release sequences
  /// NOTE: As a source-dialect this UNDER-approximates executions.
  /// Thus po-loc, means any po that is must- or may-alias.
  /// ppo_rs  = [W];po-loc;[W \ NA]
  ///         | rmw
  ///
  /// Local order approximating sc-order
  /// ppo_sc1 = [W & SC];po;[R & SC]
  ///
  /// NOTE: again, split fence. Order not in isolation (to/from the fence) but to the encosing accesses
  /// ppo_sc2 = [W];po;[F & SC]   // 1
  ///         | [F & SC];po;[R]   // 2

  orb::EventOrder tryOrderFromFence(Operation *a, Operation *b) const {
    auto mof = getCppMemoryOrder(a);
    if (isa<cpp_atomic::AtomicStoreOp, ptr::StoreOp>(b) &&
        mof == cpp_atomic::MemoryOrder::Release)
      return orb::EventOrder::Ordered;
    if (mof == cpp_atomic::MemoryOrder::Acquire ||
        mof == cpp_atomic::MemoryOrder::AcqRel ||
        mof == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;
    return orb::EventOrder::Unordered;
  }

  orb::EventOrder tryOrderToFence(Operation *a, Operation *b) const {
    auto mof = getCppMemoryOrder(b);
    if (isa<cpp_atomic::AtomicLoadOp, ptr::LoadOp>(a) &&
        mof == cpp_atomic::MemoryOrder::Acquire)
      return orb::EventOrder::Ordered;
    if (mof == cpp_atomic::MemoryOrder::Release ||
        mof == cpp_atomic::MemoryOrder::AcqRel ||
        mof == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;
    return orb::EventOrder::Unordered;
  }

  orb::EventOrder tryOrderFromLoad(Operation *a, Operation *b) const {
    auto mo = getCppMemoryOrder(a);
    if (mo == cpp_atomic::MemoryOrder::Acquire ||
        mo == cpp_atomic::MemoryOrder::AcqRel ||
        mo == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;
    if (isa<cpp_atomic::AtomicStoreOp, ptr::StoreOp>(b)) {
      auto mo2 = getCppMemoryOrder(b);
      if (mo2 == cpp_atomic::MemoryOrder::Release ||
          mo2 == cpp_atomic::MemoryOrder::AcqRel ||
          mo2 == cpp_atomic::MemoryOrder::SeqCst)
        return orb::EventOrder::Ordered;
    }
    return orb::EventOrder::Unordered;
  }

  orb::EventOrder tryOrderFromStore(Operation *a, Operation *b,
                                    AliasAnalysis &aa) const {
    if (auto sb = dyn_cast<cpp_atomic::AtomicStoreOp>(b)) {
      // ppo_fence1: po;[W & (REL | ACQREL | SC)]
      auto mo = getCppMemoryOrder(b);
      if (mo == cpp_atomic::MemoryOrder::Release ||
          mo == cpp_atomic::MemoryOrder::AcqRel ||
          mo == cpp_atomic::MemoryOrder::SeqCst)
        return orb::EventOrder::Ordered;
      // ppo_rs: must-alias writes
      auto sa = cast<cpp_atomic::AtomicStoreOp>(a);
      if (aa.alias(sa.getAddr(), sb.getAddr()) != AliasResult::NoAlias)
        return orb::EventOrder::Ordered;
    }
    // ppo_sc1
    if (getCppMemoryOrder(a) == cpp_atomic::MemoryOrder::SeqCst &&
        getCppMemoryOrder(b) == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;
    return orb::EventOrder::Unordered;
  }

  orb::EventOrder tryOrderFromPlainStore(Operation *a, Operation *b,
                                         AliasAnalysis &aa) const {
    if (auto sb = dyn_cast<cpp_atomic::AtomicStoreOp>(b)) {
      // ppo_fence1: po;[W & (REL | ACQREL | SC)]
      auto mo = getCppMemoryOrder(b);
      if (mo == cpp_atomic::MemoryOrder::Release ||
          mo == cpp_atomic::MemoryOrder::AcqRel ||
          mo == cpp_atomic::MemoryOrder::SeqCst)
        return orb::EventOrder::Ordered;
      // ppo_rs: [W];po-loc;[W \ NA]
      auto sa = cast<ptr::StoreOp>(a);
      if (aa.alias(sa.getPtr(), sb.getAddr()) != AliasResult::NoAlias)
        return orb::EventOrder::Ordered;
    }
    return orb::EventOrder::Unordered;
  }

  orb::EventOrder tryOrderFromPlainLoad(Operation *a, Operation *b) const {
    // ppo_release: plain load before a release/acqrel/sc store is ordered
    if (isa<cpp_atomic::AtomicStoreOp>(b)) {
      auto mo = getCppMemoryOrder(b);
      if (mo == cpp_atomic::MemoryOrder::Release ||
          mo == cpp_atomic::MemoryOrder::AcqRel ||
          mo == cpp_atomic::MemoryOrder::SeqCst)
        return orb::EventOrder::Ordered;
    }
    return orb::EventOrder::Unordered;
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

    if (isa<cpp_atomic::AtomicFenceOp>(a) && isa<cpp_atomic::AtomicFenceOp>(b))
      return orb::EventOrder::Unreachable;
    if (isa<cpp_atomic::AtomicFenceOp>(a))
      return tryOrderFromFence(a, b);
    if (isa<cpp_atomic::AtomicFenceOp>(b))
      return tryOrderToFence(a, b);
    if (isa<cpp_atomic::AtomicLoadOp>(a))
      return tryOrderFromLoad(a, b);
    if (isa<cpp_atomic::AtomicStoreOp>(a))
      return tryOrderFromStore(a, b, aliasAnalysis);
    if (isa<ptr::StoreOp>(a))
      return tryOrderFromPlainStore(a, b, aliasAnalysis);
    if (isa<ptr::LoadOp>(a))
      return tryOrderFromPlainLoad(a, b);
    return orb::EventOrder::Unordered;
  }

  orb::EventOrder getOrderThroughFence(Operation *a, Operation *f,
                                       Operation *b) const override {
    if (!isa<cpp_atomic::AtomicFenceOp>(f))
      return orb::EventOrder::Unordered;
    auto mof = getCppMemoryOrder(f);
    bool aIsRead  = isa<cpp_atomic::AtomicLoadOp, ptr::LoadOp>(a);
    bool bIsWrite = isa<cpp_atomic::AtomicStoreOp, ptr::StoreOp>(b);
    // ppo_fence2 pairs 5&6: ACQREL/SC — any a, any b
    if (mof == cpp_atomic::MemoryOrder::AcqRel ||
        mof == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;
    // ppo_fence2 pairs 1&2: ACQ — a is Read
    if (mof == cpp_atomic::MemoryOrder::Acquire && aIsRead)
      return orb::EventOrder::Ordered;
    // ppo_fence2 pairs 3&4: REL — b is Write
    if (mof == cpp_atomic::MemoryOrder::Release && bIsWrite)
      return orb::EventOrder::Ordered;
    return orb::EventOrder::Unordered;
  }

  llvm::SmallVector<orb::Promotion> promote(uint64_t, Operation *, uint64_t,
                                            Operation *,
                                            const orb::OrderMatrix &) const override {
    llvm_unreachable("CppAtomic is never the synthesis target");
  }
  int cost(const orb::Promotion &, const orb::CostContext &) const override {
    llvm_unreachable("CppAtomic is never the synthesis target");
  }
  Operation *applyPromotion(const orb::Promotion &, OpBuilder &,
                            orb::OrderMatrix *) const override {
    llvm_unreachable("CppAtomic is never the synthesis target");
  }
  void updateOrderMatrix(const orb::Promotion &, Operation *, uint64_t, uint64_t,
                         orb::OrderMatrix &, AliasAnalysis &, DominanceInfo &,
                         PostDominanceInfo &,
                         const orb::CallReachability &) const override {
    llvm_unreachable("CppAtomic is never the synthesis target");
  }
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
