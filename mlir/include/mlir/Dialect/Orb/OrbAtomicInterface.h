//===- OrbAtomicInterface.h - Orb atomic ordering interface ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Defines OrbAtomicDialectInterface — a common DialectInterface for the
// CppAtomic and ArmAtomic dialects — along with the OrderMatrix analysis and
// the Promotion type used by the promote/cost API.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_ORB_ORBATOMICINTERFACE_H
#define MLIR_DIALECT_ORB_ORBATOMICINTERFACE_H

#include "mlir/Analysis/AliasAnalysis.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/DialectInterface.h"
#include "mlir/IR/Dominance.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <variant>

namespace mlir::orb {

/// Attribute name used to tag memory events with a stable integer ID.
/// Assigned by assignEventIds() on the CppAtomic IR; must be propagated by
/// CppAtomicToArmAtomic so the two matrices can be compared by ID.
static constexpr llvm::StringLiteral kEventIdAttr = "orb.event_id";

/// Ordering status between two memory events.
enum class EventOrder { Unreachable, Ordered, Unordered };

/// One option returned by OrbAtomicDialectInterface::promote().
struct Promotion {
  /// Insert an Orb fence before `insertBefore`.
  struct FenceAction {
    Operation *insertBefore; ///< nullptr means end of enclosing block.
  };
  /// Strengthen the memory order of `op` in-place.
  /// The dialect's promote() knows the target ordering.
  struct UpgradeAction {
    Operation *op;
  };
  using Action = std::variant<FenceAction, UpgradeAction>;

  Action action;
  /// Event pairs (by ID) that become ordered once this promotion is applied.
  llvm::SmallVector<std::pair<uint64_t, uint64_t>> newlyOrdered;
};

/// Ordering matrix indexed by stable event IDs (see kEventIdAttr).
/// Built by getOrderMatrix(); compared across the CppAtomic→ArmAtomic
/// boundary to drive fence synthesis.
class OrderMatrix {
public:
  EventOrder getOrder(uint64_t idA, uint64_t idB) const;
  /// Look up the current Operation* for a given event ID.
  Operation *getOpForId(uint64_t id) const;
  llvm::ArrayRef<uint64_t> eventIds() const { return ids; }

private:
  friend OrderMatrix getOrderMatrix(ModuleOp, AliasAnalysis &, DominanceInfo &);
  llvm::DenseMap<std::pair<uint64_t, uint64_t>, EventOrder> data;
  llvm::DenseMap<uint64_t, Operation *> idToOp;
  llvm::SmallVector<uint64_t> ids;
};

/// Per-dialect interface for atomic memory ordering analysis.
/// Registered by CppAtomicDialect and ArmAtomicDialect.
class OrbAtomicDialectInterface
    : public DialectInterface::Base<OrbAtomicDialectInterface> {
public:
  using Base::Base;

  /// Returns true if `op` is a memory event this dialect handles.
  /// May return true for ops from other dialects (e.g. ptr.load in CppAtomic).
  virtual bool isMemoryEvent(Operation *op) const = 0;

  /// Returns the ordering between two memory events.
  /// `aliasAnalysis` and `dominance` are provided to detect implicit ordering
  /// from data/control dependencies (essential for the ArmAtomic side).
  /// Returns Unreachable if either op is not recognised by this dialect.
  virtual EventOrder getOrder(Operation *a, Operation *b,
                              AliasAnalysis &aliasAnalysis,
                              DominanceInfo &dominance) const = 0;

  /// Returns promotion options for an UNORDERED pair (identified by ID).
  /// `a` and `b` are the current Operation* for those IDs.
  /// Returns {} if this dialect cannot promote the pair.
  virtual llvm::SmallVector<Promotion> promote(uint64_t idA, Operation *a,
                                               uint64_t idB,
                                               Operation *b) const = 0;

  /// Relative cost of a promotion. Lower is cheaper.
  virtual int cost(const Promotion &p) const = 0;
};

/// Assign sequential orb.event_id attributes to all memory events in `module`.
/// Call this on the CppAtomic IR before conversion; the conversion pass must
/// copy the attribute to the corresponding ArmAtomic ops.
void assignEventIds(ModuleOp module);

/// Build an ordering matrix over all memory events in `module`.
/// `aliasAnalysis` and `dominance` are forwarded to getOrder() so that
/// implicit orderings (data deps, program order, loop structure) are captured.
OrderMatrix getOrderMatrix(ModuleOp module, AliasAnalysis &aliasAnalysis,
                           DominanceInfo &dominance);

} // namespace mlir::orb

#endif // MLIR_DIALECT_ORB_ORBATOMICINTERFACE_H
