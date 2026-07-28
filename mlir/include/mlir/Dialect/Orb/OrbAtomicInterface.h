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
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/DialectInterface.h"
#include "mlir/IR/Dominance.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <variant>
#include <vector>

namespace mlir {
class AnalysisManager;
} // namespace mlir

namespace mlir::orb {

/// Attribute name used to tag memory events with a stable integer ID.
/// Assigned by assignEventIds() on the source IR; must be propagated by
/// <Source>AtomicTo<Target>Atomic so the two matrices can be compared by ID.
static constexpr llvm::StringLiteral kEventIdAttr = "orb.event_id";


/// Ordering status between two memory events.
enum class EventOrder : uint8_t { Unreachable, Ordered, Unordered };

/// One option returned by OrbAtomicDialectInterface::promote().
struct Promotion {
  /// Insert an Orb fence before `insertBefore`.
  struct FenceAction {
    Operation *insertBefore;
    int memoryOrder; ///< Dialect-specific memory order enum value.
  };
  /// Strengthen the memory order of `op` in-place.
  struct UpgradeAction {
    Operation *op;
    int targetMemoryOrder; ///< Dialect-specific memory order enum value.
  };
  using Action = std::variant<FenceAction, UpgradeAction>;

  Action action;
};

/// Coverage context passed to cost(). Precomputed by FenceSynthesisPass from
/// the required-pairs pressure maps for the pair (idA, idB) being promoted.
/// rowPressure: unsatisfied pairs where idA is the "before" event.
/// colPressure: unsatisfied pairs where idB is the "after" event.
struct CostContext {
  unsigned rowPressure;      ///< Unsatisfied pairs where idA is "before" (all b).
  unsigned rowWritePressure; ///< Subset of rowPressure where b is a write.
  unsigned colPressure;      ///< Unsatisfied pairs where idB is "after" (all c).
  unsigned colReadPressure;  ///< Subset of colPressure where c is a read.
  unsigned colWritePressure; ///< Subset of colPressure where c is a write.
  unsigned fenceCostBase = 2; ///< Base cost multiplier for FenceAction.
};

class OrbAtomicDialectInterface; // forward declaration for OrderMatrix::addFence

/// Interprocedural region reachability via call+return edges.
/// Computed once per pass by computeCallReachability(); stable across synthesis
/// iterations because synthesis never adds new call ops.
struct CallReachability {
  /// Region-level reachability (bidirectional: call + return edges).
  llvm::DenseMap<Region *, llvm::DenseSet<Region *>> data;
  bool reaches(Region *from, Region *to) const {
    auto it = data.find(from);
    return it != data.end() && it->second.count(to);
  }

  /// Direct call ops: directCalls[{callerRegion, calleeRegion}] = list of
  /// CallOps in callerRegion that directly call calleeRegion.
  llvm::DenseMap<std::pair<Region *, Region *>,
                 llvm::SmallVector<Operation *>>
      directCalls;

  /// Returns true if op `a` in its region can execute before events in
  /// `toRegion`. Requires that `a` dominates at least one direct call from
  /// `a`'s region to `toRegion`. This is stricter than `reaches()`: it rules
  /// out ops that only appear AFTER the call to `toRegion`.
  bool opCanReach(Operation *a, Region *toRegion, DominanceInfo &dom) const {
    Region *fromRegion = a->getBlock()->getParent();
    if (fromRegion == toRegion)
      return true;
    auto it = directCalls.find({fromRegion, toRegion});
    if (it == directCalls.end())
      return false;
    return llvm::any_of(it->second, [&](Operation *callOp) {
      return dom.dominates(a, callOp);
    });
  }
};

class OrderMatrix {
public:
  EventOrder getOrder(uint64_t idA, uint64_t idB) const;
  /// Look up the current Operation* for a given event ID.
  Operation *getOpForId(uint64_t id) const;
  llvm::ArrayRef<uint64_t> eventIds() const { return ids; }
  /// Map event ID → matrix index. Asserts if id is not present.
  unsigned idxOf(uint64_t id) const;

  /// Apply ACQ upgrade: row sweep — set all Unordered in row aIdx → Ordered.
  /// (stride-1, cache-friendly)
  void applyAcqUpgrade(unsigned aIdx);

  /// Apply ACQPC upgrade: row sweep — set Unordered write entries in row aIdx → Ordered.
  /// [R & ACQPC];po;[W] — weaker than ACQ; only orders before writes.
  void applyAcqPCUpgrade(unsigned aIdx,
                          llvm::ArrayRef<OrbAtomicDialectInterface *> ifaces);

  /// Apply REL upgrade: column sweep — set all Unordered in column bIdx → Ordered.
  /// (stride-n, cache-unfriendly but unavoidable)
  void applyRelUpgrade(unsigned bIdx);

  /// Extend the matrix for a newly inserted fence op `f`.
  /// `f` must already have an orb.event_id attribute.
  /// Expands the n×n matrix to (n+1)×(n+1), computes the fence's row/column
  /// via queryOrder, and applies the fence closure for all existing event pairs.
  void addFence(Operation *f,
                llvm::ArrayRef<OrbAtomicDialectInterface *> ifaces,
                AliasAnalysis &aa, DominanceInfo &dom,
                const CallReachability &reach);

  /// Re-evaluate ordering for an existing fence at `fIdx` after its memory
  /// order was upgraded to AcqRel. Recomputes the fence's row/column via
  /// queryOrder and applies fence closure. No matrix expansion.
  void applyFenceUpgrade(unsigned fIdx,
                         llvm::ArrayRef<OrbAtomicDialectInterface *> ifaces,
                         AliasAnalysis &aa, DominanceInfo &dom,
                         const CallReachability &reach);

  /// Close the Ordered relation under transitivity, only over Unordered cells.
  /// Call at most once per matrix (on the initial target matrix before synthesis).
  void closeTransitively();

private:
  friend OrderMatrix getOrderMatrix(ModuleOp, AliasAnalysis &, DominanceInfo &);
  friend OrderMatrix getOrderMatrix(ModuleOp, AliasAnalysis &, DominanceInfo &,
                                    const CallReachability &);
  // Flat n×n array indexed by consecutive event indices — avoids DenseMap
  // cache misses for the O(n²) pairwise pass and O(n²) fence closure.
  // EventOrder is uint8_t-backed; at n=7941 (all events + fences): ~63MB.
  std::vector<EventOrder> matrix; // size n*n
  llvm::DenseMap<uint64_t, unsigned> idToIdx; // id → row/col index
  llvm::DenseMap<uint64_t, Operation *> idToOp;
  llvm::SmallVector<uint64_t> ids;
  unsigned n = 0; // total events (loads + stores + fences)

  void setOrder(unsigned aIdx, unsigned bIdx, EventOrder order) {
    matrix[aIdx * n + bIdx] = order;
  }
};

/// Per-dialect interface for atomic memory ordering analysis.
/// Registered by CppAtomicDialect and ArmAtomicDialect.
class OrbAtomicDialectInterface
    : public DialectInterface::Base<OrbAtomicDialectInterface> {
public:
  using Base::Base;

  /// Returns true if `op` is a memory event this dialect handles.
  /// May return true for ops from other dialects (e.g. ptr.load).
  virtual bool isMemoryEvent(Operation *op) const = 0;

  /// Returns true if `op` is a fence op (not a load/store/rmw).
  /// Fences are kept separate from the main event matrix to avoid O(n³) blowup.
  virtual bool isFenceEvent(Operation *op) const { return false; }

  /// Returns true if `op` is a write (store) event.
  /// Used by applyAcqPCUpgrade to restrict ACQPC ordering to writes.
  virtual bool isWriteEvent(Operation *op) const { return false; }

  /// Returns the ordering between two memory events.
  /// Returns Unreachable if either op is not recognised by this dialect.
  /// For same-region pairs, may use `dominance`; for cross-region pairs
  /// (already vetted for call reachability by getOrderMatrix), skips dominance.
  virtual EventOrder getOrder(Operation *a, Operation *b,
                              AliasAnalysis &aliasAnalysis,
                              DominanceInfo &dominance) const = 0;

  /// Returns Ordered if f orders (a, b) by the dialect's fence rules.
  /// `f` must be a fence op. Dominance/reachability is the caller's concern.
  virtual EventOrder getOrderThroughFence(Operation *a, Operation *f,
                                          Operation *b) const = 0;

  /// Returns promotion options for an UNORDERED pair (identified by ID).
  /// `a` and `b` are the current Operation* for those IDs.
  /// Returns {} if this dialect cannot promote the pair.
  virtual llvm::SmallVector<Promotion> promote(uint64_t idA, Operation *a,
                                               uint64_t idB,
                                               Operation *b) const = 0;

  /// Coverage-adjusted cost of a promotion. Lower is cheaper.
  /// ctx carries the unsatisfied-pair counts for the pair being promoted.
  virtual int cost(const Promotion &p, const CostContext &ctx) const = 0;

  /// Apply a promotion to the IR.
  /// For FenceAction: sets builder insertion point and creates the dialect's
  /// fence op; returns the created Operation*.
  /// For UpgradeAction: mutates the op's memory order attribute; returns nullptr.
  virtual Operation *applyPromotion(const Promotion &p,
                                    OpBuilder &builder) const = 0;

  /// Called once on the initial target OrderMatrix after getOrderMatrix(),
  /// before synthesis begins. Dialects may apply model-specific derived orderings
  /// (e.g. lob* transitive closure for ARM). Default: no-op.
  virtual void refineInitialOrderMatrix(OrderMatrix &matrix) const {}

  /// Called for cross-region (cross-function) pairs where opCanReach() returned
  /// true but getOrder() returned Unordered. Dialects may detect dependency
  /// orderings that cross function-call boundaries (e.g. ctrl;[W] when a load
  /// in the caller controls whether a call executes). Default: Unordered.
  virtual EventOrder getOrderCrossRegion(Operation *a, Operation *b,
                                         AliasAnalysis &aa, DominanceInfo &dom,
                                         const CallReachability &reach) const {
    return EventOrder::Unordered;
  }
};

/// Assign sequential orb.event_id attributes to all memory events in `module`.
/// Call this on the source IR before conversion; later conversion passes must
/// copy the attribute to the corresponding target ops.
void assignEventIds(ModuleOp module);

/// Compute interprocedural call+return reachability between callable regions.
/// Stable across synthesis iterations; call once per pass and reuse.
CallReachability computeCallReachability(ModuleOp module);

/// Build an ordering matrix over all memory events in `module`.
/// Uses precomputed call reachability (cheap, safe to call in a hot loop).
OrderMatrix getOrderMatrix(ModuleOp module, AliasAnalysis &aliasAnalysis,
                           DominanceInfo &dominance,
                           const CallReachability &reach);

/// Convenience overload: computes CallReachability internally.
/// Use for one-shot calls (e.g. OrderAnalysis); prefer the reach overload in loops.
OrderMatrix getOrderMatrix(ModuleOp module, AliasAnalysis &aliasAnalysis,
                           DominanceInfo &dominance);

/// MLIR analysis class wrapping the required ordering pairs.
/// Reads orb.required_orderings from the module attribute written by
/// OrderAnalysisPass. Use via getAnalysis<OrderAnalysis>() in passes that run
/// after OrderAnalysisPass (e.g. FenceSynthesisPass).
class OrderAnalysis {
public:
  explicit OrderAnalysis(Operation *op, AnalysisManager &am);

  llvm::ArrayRef<std::pair<uint64_t, uint64_t>> requiredPairs() const {
    return pairs;
  }
  bool empty() const { return pairs.empty(); }

  /// Fills `before` with all idC where (idC, idF) is an ordered pair,
  /// and `after` with all idD where (idF, idD) is an ordered pair.
  /// Used by FenceSynthesisPass to find access-access pairs mediated by fence idF.
  void pairsWithFence(uint64_t idF,
                      llvm::SmallVectorImpl<uint64_t> &before,
                      llvm::SmallVectorImpl<uint64_t> &after) const;

private:
  llvm::SmallVector<std::pair<uint64_t, uint64_t>> pairs;
};

} // namespace mlir::orb

#endif // MLIR_DIALECT_ORB_ORBATOMICINTERFACE_H
