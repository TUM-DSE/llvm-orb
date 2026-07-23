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
    return isa<cpp_atomic::AtomicLoadOp, cpp_atomic::AtomicStoreOp,
               cpp_atomic::AtomicFenceOp, ptr::LoadOp, ptr::StoreOp>(op);
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

  orb::EventOrder try_order_from_fence(Operation *a, Operation *b) const {
    auto mof = getCppMemoryOrder(a);
    if (isa<cpp_atomic::AtomicStoreOp, ptr::StoreOp>(b)) {
      if (mof == cpp_atomic::MemoryOrder::Release)
        return orb::EventOrder::Ordered;
    }
    if ( mof == cpp_atomic::MemoryOrder::Acquire || mof == cpp_atomic::MemoryOrder::AcqRel || mof == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;

    return orb::EventOrder::Unordered;
  }

  orb::EventOrder try_order_to_fence(Operation *a, Operation *b) const {
    auto mof = getCppMemoryOrder(b);
    if (isa<cpp_atomic::AtomicLoadOp, ptr::LoadOp>(a)) {
      if (mof == cpp_atomic::MemoryOrder::Acquire)
        return orb::EventOrder::Ordered;
    }
    if ( mof == cpp_atomic::MemoryOrder::Release || mof == cpp_atomic::MemoryOrder::AcqRel || mof == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;

    return orb::EventOrder::Unordered;
  }

  // Anything below can ignore fences

  orb::EventOrder try_order_from_load(Operation *a, Operation *b) const {
    // just ppo_fence1

    auto mo = getCppMemoryOrder(a);
    if ( mo == cpp_atomic::MemoryOrder::Acquire || mo == cpp_atomic::MemoryOrder::AcqRel || mo == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;

    if (isa<cpp_atomic::AtomicStoreOp, ptr::StoreOp>(b)) {
      auto mo2 = getCppMemoryOrder(b);
      if ( mo2 == cpp_atomic::MemoryOrder::Release || mo2 == cpp_atomic::MemoryOrder::AcqRel || mo2 == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;
    }
    return orb::EventOrder::Unordered;
  }

  orb::EventOrder try_order_from_store(Operation *a, Operation *b, AliasAnalysis &AA) const {
    auto moa = getCppMemoryOrder(a);
    auto mob = getCppMemoryOrder(b);
    // ppo_rs
    if (auto sb = dyn_cast<cpp_atomic::AtomicStoreOp>(b)) {
      auto sa = dyn_cast<cpp_atomic::AtomicStoreOp>(a);
      auto alias_result = AA.alias(sa.getAddr(), sb.getAddr());
      if (alias_result)
        return orb::EventOrder::Ordered;
    }

    // ppo_sc
    if (moa == cpp_atomic::MemoryOrder::SeqCst && mob == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;

    return orb::EventOrder::Unordered;
  }

  orb::EventOrder try_order_from_plain_store(Operation *a, Operation *b, AliasAnalysis &AA) const {
    // ppo_rs
    if (auto sb = dyn_cast<cpp_atomic::AtomicStoreOp>(b)) {
      auto sa = dyn_cast<ptr::StoreOp>(a);
      auto alias_result = AA.alias(sa.getPtr(), sb.getAddr());
      if (alias_result)
        return orb::EventOrder::Ordered;
    }
    return orb::EventOrder::Unordered;
  }

  orb::EventOrder getOrder(Operation *a, Operation *b,
                           AliasAnalysis &aliasAnalysis,
                           DominanceInfo &dominance) const override {
    if (!isMemoryEvent(a) || !isMemoryEvent(b))
      return orb::EventOrder::Unreachable;

    if (!dominance.dominates(a,b) && !a->getBlock()->isReachable(b->getBlock()))
      return orb::EventOrder::Unreachable;

    if (isa<cpp_atomic::AtomicFenceOp>(a))
      return try_order_from_fence(a, b);

    if (isa<cpp_atomic::AtomicFenceOp>(b))
      return try_order_to_fence(a, b);

    if (isa<cpp_atomic::AtomicLoadOp>(a))
      return try_order_from_load(a, b);

    if (isa<cpp_atomic::AtomicStoreOp>(a))
      return try_order_from_store(a, b, aliasAnalysis);

    if (isa<ptr::StoreOp>(a))
      return try_order_from_plain_store(a, b, aliasAnalysis);

    return orb::EventOrder::Unordered;
  }

  orb::EventOrder getOrderThroughFence(Operation *a, Operation *f, Operation *b,
                                       DominanceInfo &dom) const override {
    if (!isa<cpp_atomic::AtomicFenceOp>(f))
      return orb::EventOrder::Unordered;
    if (!dom.dominates(a, f) || !dom.dominates(f, b))
      return orb::EventOrder::Unreachable;

    auto mof = getCppMemoryOrder(f);
    bool aIsRead  = isa<cpp_atomic::AtomicLoadOp,  ptr::LoadOp>(a);
    bool aIsWrite = isa<cpp_atomic::AtomicStoreOp, ptr::StoreOp>(a);
    bool bIsWrite = isa<cpp_atomic::AtomicStoreOp, ptr::StoreOp>(b);

    // ppo_fence2 pair 5&6: ACQREL/SC — any a, any b (most permissive, check first)
    if (mof == cpp_atomic::MemoryOrder::AcqRel ||
        mof == cpp_atomic::MemoryOrder::SeqCst)
      return orb::EventOrder::Ordered;
    // ppo_fence2 pair 1&2: ACQ — a is Read, any b
    if (mof == cpp_atomic::MemoryOrder::Acquire && aIsRead)
      return orb::EventOrder::Ordered;
    // ppo_fence2 pair 3&4: REL — any a, b is Write
    if (mof == cpp_atomic::MemoryOrder::Release && bIsWrite)
      return orb::EventOrder::Ordered;

    (void)aIsWrite;
    return orb::EventOrder::Unordered;
  }

  llvm::SmallVector<orb::Promotion> promote(uint64_t idA, Operation *a,
                                            uint64_t idB,
                                            Operation *b) const override {

    llvm_unreachable("CppAtomic is never the synthesis target");
  }

  /// Cpp latice for cost
  /*
   *       SC: 4
   *        / \
   *  ACQ: 2   REL: 2
   *        \ /
   *      RLX: 1
   *         |
   *       NA: 0
   */

  int cost(const orb::Promotion &) const override { return 1; }

  void applyPromotion(const orb::Promotion &, OpBuilder &) const override {
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
