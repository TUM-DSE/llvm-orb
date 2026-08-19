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
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <variant>
#include <vector>

namespace mlir {
class AnalysisManager;
} // namespace mlir

namespace mlir::orb {

/// True if `op` is a ptr.load/ptr.store whose address is a stack alloca.
/// Stack-local memory is thread-private and needs no ordering.
bool isStackSlotAccess(Operation *op);

/// Attribute key for stable per-event integer IDs; propagated across dialect conversions.
constexpr llvm::StringLiteral kEventIdAttr = "orb.event_id";

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
  /// Strengthen two ops at once (e.g. store→REL + load→ACQPC).
  struct PairUpgradeAction {
    Operation *op1;
    int targetMemoryOrder1;
    Operation *op2;
    int targetMemoryOrder2;
  };
  /// No IR change; prior upgrades already satisfy the ordering rule but the
  /// matrix hasn't caught up. Cost 0.
  struct EmptyUpgradeAction {};
  using Action = std::variant<FenceAction, UpgradeAction, PairUpgradeAction,
                              EmptyUpgradeAction>;

  Action action;
  unsigned loopDepth = 0; ///< Loop depth of the promotion's target op.
};

/// Coverage context passed to cost(). Precomputed by FenceSynthesisPass.
struct CostContext {
  unsigned rowPressure;      ///< Unsatisfied pairs where idA is "before" (all b).
  unsigned rowWritePressure; ///< Subset of rowPressure where b is a write.
  unsigned colPressure;      ///< Unsatisfied pairs where idB is "after" (all c).
  unsigned colReadPressure;  ///< Subset of colPressure where c is a read.
  unsigned colWritePressure; ///< Subset of colPressure where c is a write.
  unsigned fenceCostBase = 2; ///< Base cost multiplier for FenceAction.
  unsigned numEvents = 1;     ///< Total events in the OrderMatrix (for collateral estimate).
};

class OrbAtomicDialectInterface; // forward declaration for OrderMatrix::addFence

/// Interprocedural reachability via call+return+CFG edges.
/// Computed by computeCallReachability().
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

  /// Block-level interprocedural reachability (precomputed, no depth limit).
  llvm::DenseMap<Block *, unsigned> blockIndex; ///< All blocks → dense index.
  llvm::SmallVector<Block *> allBlocks;         ///< Dense index → block.
  /// Sparse reachability: only event blocks (containing orb.event_id ops) have
  /// rows.  blockReachRows[eventRowIndex[block]] is a BitVector over blockIndex.
  llvm::DenseMap<Block *, unsigned> eventRowIndex;
  std::vector<llvm::BitVector> blockReachRows;

  /// Can `from` reach `to` via program order across function boundaries?
  /// Handles same-block ordering, intra-function CFG, and interprocedural
  /// call/return edges.  Both ops must reside in blocks known to blockIndex.
  bool canReach(Operation *from, Operation *to) const;
};

class OrderMatrix {
public:
  EventOrder getOrder(uint64_t idA, uint64_t idB) const;
  /// Cross-iteration view: returns matrix[2a, 2b+1].
  EventOrder getCrossIterOrder(uint64_t idA, uint64_t idB) const;
  /// True if (idA, idB) is Ordered in same-iteration OR cross-iteration view.
  bool isOrdered(uint64_t idA, uint64_t idB) const;
  /// Look up the current Operation* for a given event ID.
  Operation *getOpForId(uint64_t id) const;
  llvm::ArrayRef<uint64_t> eventIds() const { return ids; }
  unsigned numEvents() const { return nEvents; }
  /// Map event ID → matrix index. Asserts if id is not present.
  unsigned idxOf(uint64_t id) const;
  /// Count cells with a given order value.
  unsigned countCells(EventOrder order) const;

  /// Set the required-pair set for incremental ordered/overspecified tracking.
  void setRequiredSet(
      const llvm::DenseSet<std::pair<uint64_t, uint64_t>> *s) {
    requiredSet = s;
    coveredCount = 0;
    overspecifiedCount = 0;
    // Count existing Ordered cells against required set.
    for (unsigned a = 0; a < nEvents; ++a)
      for (unsigned b = 0; b < nEvents; ++b) {
        if (a == b) continue;
        // Same-iteration (even,even)
        if (matrix[2 * a * n + 2 * b] == EventOrder::Ordered)
          trackNewOrdered(2 * a, 2 * b);
        // Cross-iteration (even,odd)
        if (matrix[2 * a * n + 2 * b + 1] == EventOrder::Ordered)
          trackNewOrdered(2 * a, 2 * b + 1);
      }
  }
  /// Return (covered, overspecified) counts accumulated since setRequiredSet.
  std::pair<unsigned, unsigned> orderedCounts() const {
    return {coveredCount, overspecifiedCount};
  }

  /// Set (idA, idB) to Ordered if currently Unordered; no-op otherwise.
  void markOrdered(uint64_t idA, uint64_t idB);
  void addFence(Operation *f, const OrbAtomicDialectInterface *iface,
                AliasAnalysis &aa, DominanceInfo &dom,
                const CallReachability &reach);
  void applyFenceUpgrade(unsigned fIdx, const OrbAtomicDialectInterface *iface,
                         AliasAnalysis &aa, DominanceInfo &dom,
                         const CallReachability &reach);
  /// Close the Ordered relation transitively. maxRounds=0 means no limit.
  void closeTransitively(unsigned maxRounds = 0);
  /// Incrementally propagate only edges added since the last closure call.
  void closeIncrementally();

private:
  friend OrderMatrix getOrderMatrix(ModuleOp, AliasAnalysis &, DominanceInfo &);
  friend OrderMatrix getOrderMatrix(ModuleOp, AliasAnalysis &, DominanceInfo &,
                                    const OrbAtomicDialectInterface *,
                                    const CallReachability &);
  // Flat n×n array of EventOrder (uint8_t), indexed by consecutive event indices.
  std::vector<EventOrder> matrix;
  std::vector<unsigned> idToIdx;   // indexed by event ID → matrix row/col
  std::vector<Operation *> idToOp; // indexed by event ID → Operation*
  llvm::SmallVector<uint64_t> ids;
  unsigned n = 0;
  /// Number of original events. Matrix dimension `n` = 2 * nEvents (doubled).
  /// Even indices (2i) = same-iteration copy, odd (2i+1) = cross-iteration.
  unsigned nEvents = 0;
  bool closureReported = false;
  llvm::SmallVector<std::pair<unsigned, unsigned>> pendingEdges;
  const llvm::DenseSet<std::pair<uint64_t, uint64_t>> *requiredSet = nullptr;
  unsigned coveredCount = 0;
  unsigned overspecifiedCount = 0;

  void trackNewOrdered(unsigned aIdx, unsigned bIdx) {
    if (!requiredSet)
      return;
    // Track same-iteration (even,even) and cross-iteration (even,odd) pairs.
    // Skip (odd,*) — those are shifted copies.
    if (aIdx % 2 != 0)
      return;
    unsigned origA = aIdx / 2;
    unsigned origB = bIdx / 2;
    if (origA == origB)
      return;
    auto pair = std::make_pair(ids[origA], ids[origB]);
    bool isRequired = requiredSet->count(pair);
    // Avoid double-counting: if this is (even,odd) but (even,even) is already
    // Ordered, the pair was already counted. Vice versa.
    bool otherAlsoOrdered;
    if (bIdx % 2 == 0) // same-iter cell being set — check if cross-iter already Ordered
      otherAlsoOrdered = matrix[aIdx * n + bIdx + 1] == EventOrder::Ordered;
    else // cross-iter cell being set — check if same-iter already Ordered
      otherAlsoOrdered = matrix[aIdx * n + bIdx - 1] == EventOrder::Ordered;
    if (otherAlsoOrdered)
      return; // already counted via the other cell
    if (isRequired)
      ++coveredCount;
    else
      ++overspecifiedCount;
  }

  void setOrder(unsigned aIdx, unsigned bIdx, EventOrder order) {
    matrix[aIdx * n + bIdx] = order;
  }
  /// Set order and track the edge for incremental closure.
  void setOrderTracked(unsigned aIdx, unsigned bIdx, EventOrder order) {
    auto &cell = matrix[aIdx * n + bIdx];
    if (cell != order && order == EventOrder::Ordered) {
      cell = order;
      pendingEdges.push_back({aIdx, bIdx});
      trackNewOrdered(aIdx, bIdx);
    } else {
      cell = order;
    }
  }
  EventOrder queryOrder(Operation *a, Operation *b,
                        const OrbAtomicDialectInterface *iface,
                        AliasAnalysis &aa, DominanceInfo &dom) const;
  void applyFenceClosure(unsigned fOrigIdx, const OrbAtomicDialectInterface *iface);
};

/// Per-dialect interface for atomic memory ordering analysis.
/// Registered by CppAtomicDialect and ArmAtomicDialect.
class OrbAtomicDialectInterface
    : public DialectInterface::Base<OrbAtomicDialectInterface> {
public:
  using Base::Base;

  virtual bool isMemoryEvent(Operation *op) const = 0;
  virtual bool isFenceEvent(Operation *op) const { return false; }
  virtual bool isWriteEvent(Operation *op) const { return false; }
  virtual EventOrder getOrder(Operation *a, Operation *b,
                              AliasAnalysis &aliasAnalysis,
                              DominanceInfo &dominance) const = 0;
  /// Returns Ordered if `f` (a fence op) orders (a, b) per dialect fence rules.
  virtual EventOrder getOrderThroughFence(Operation *a, Operation *f,
                                          Operation *b) const = 0;
  virtual llvm::SmallVector<Promotion> promote(uint64_t idA, Operation *a,
                                               uint64_t idB,
                                               Operation *b) const = 0;
  virtual int cost(const Promotion &p, const CostContext &ctx) const = 0;
  /// FenceAction: creates and returns the fence op. UpgradeAction: mutates in-place, returns nullptr.
  virtual Operation *applyPromotion(const Promotion &p,
                                    OpBuilder &builder) const = 0;
  /// Update `mb` to reflect all new orderings introduced by `p`.
  /// For FenceAction, `newOp` is the op returned by applyPromotion() with its
  /// orb.event_id already set. For UpgradeAction, `newOp` is nullptr.
  virtual void updateOrderMatrix(const Promotion &p, Operation *newOp,
                                 uint64_t idA, uint64_t idB, OrderMatrix &mb,
                                 AliasAnalysis &aa, DominanceInfo &dom,
                                 const CallReachability &reach) const = 0;
  /// Apply model-specific derived orderings to the initial target matrix (e.g. lob* for ARM).
  virtual void refineInitialOrderMatrix(OrderMatrix &matrix) const {}
  /// Ordering for cross-region pairs where canReach() is true but getOrder() returned Unordered.
  virtual EventOrder getOrderCrossRegion(Operation *a, Operation *b,
                                         AliasAnalysis &aa, DominanceInfo &dom,
                                         const CallReachability &reach) const {
    return EventOrder::Unordered;
  }
};

void assignEventIds(ModuleOp module);
CallReachability computeCallReachability(ModuleOp module);
/// Build the order matrix using `iface` as the sole dialect interface.
/// Use this overload from passes that have already resolved the interface.
OrderMatrix getOrderMatrix(ModuleOp module, AliasAnalysis &aliasAnalysis,
                           DominanceInfo &dominance,
                           const OrbAtomicDialectInterface *iface,
                           const CallReachability &reach);
/// Auto-discovers the single registered OrbAtomicDialectInterface.
/// Use this overload from dialect-agnostic analyses (e.g. OrderAnalysis).
OrderMatrix getOrderMatrix(ModuleOp module, AliasAnalysis &aliasAnalysis,
                           DominanceInfo &dominance);

class OrderAnalysis {
public:
  explicit OrderAnalysis(Operation *op, AnalysisManager &am);

  llvm::ArrayRef<std::pair<uint64_t, uint64_t>> requiredPairs() const {
    return pairs;
  }
  bool empty() const { return pairs.empty(); }

private:
  llvm::SmallVector<std::pair<uint64_t, uint64_t>> pairs;
};

} // namespace mlir::orb

#endif // MLIR_DIALECT_ORB_ORBATOMICINTERFACE_H
