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
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <variant>
#include <vector>

namespace mlir {
class AnalysisManager;
} // namespace mlir

namespace mlir::orb {


/// Helper Functions for RMWOps to find there PartnerIDs and know which ID belongs to the read and which to the write  
constexpr uint64_t kRmwMask = 1ULL << 63;

inline bool isRmwId(uint64_t id) { 
  return (id & kRmwMask) != 0; 
}
inline bool isRmwReadId(uint64_t id) { 
  return isRmwId(id) && (id & 1) == 0; 
}
inline bool isRmwWriteId(uint64_t id) { 
  return isRmwId(id) && (id & 1) == 1; 
}
inline uint64_t getPartnerId(uint64_t id) { 
  assert(isRmwId(id));
  return id ^ 1;
}  

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
  using Action = std::variant<FenceAction, UpgradeAction>;

  Action action;
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

/// Interprocedural region reachability via call+return edges.
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

  /// True if `a` dominates at least one direct call from its region to `toRegion`.
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
  OrbAtomicDialectInterface *iface = nullptr;

  EventOrder getOrder(uint64_t idA, uint64_t idB) const;

  llvm::ArrayRef<uint64_t> eventIds() const;
  /// Map event ID → matrix index. Asserts if id is not present.
  unsigned idxOf(uint64_t id) const;

  /// Set (idA, idB) to Ordered if currently Unordered; no-op otherwise.
  void markOrdered(uint64_t idA, uint64_t idB);
  void addFence(Operation *f, const OrbAtomicDialectInterface *iface,
                AliasAnalysis &aa, DominanceInfo &dom,
                const CallReachability &reach);
  void applyFenceUpgrade(unsigned fIdx, const OrbAtomicDialectInterface *iface,
                         AliasAnalysis &aa, DominanceInfo &dom,
                         const CallReachability &reach);
  /// Close the Ordered relation transitively; call once on the initial matrix.
  void closeTransitively();

private:
  friend OrderMatrix getOrderMatrix(ModuleOp, AliasAnalysis &, DominanceInfo &);
  friend OrderMatrix getOrderMatrix(ModuleOp, AliasAnalysis &, DominanceInfo &,
                                    const OrbAtomicDialectInterface *,
                                    const CallReachability &);
  // Flat n×n array of EventOrder (uint8_t), indexed by consecutive event indices.
  std::vector<EventOrder> matrix;
  llvm::DenseMap<uint64_t, unsigned> idToIdx;
  unsigned n = 0;

  void setOrder(unsigned aIdx, unsigned bIdx, EventOrder order) {
    matrix[aIdx * n + bIdx] = order;
  }
  EventOrder queryOrder(Operation *a, Operation *b,
                        const OrbAtomicDialectInterface *iface,
                        AliasAnalysis &aa, DominanceInfo &dom) const;
  void applyFenceClosure(unsigned fIdx, const OrbAtomicDialectInterface *iface);
};

/// Per-dialect interface for atomic memory ordering analysis.
/// Registered by CppAtomicDialect and ArmAtomicDialect.
class OrbAtomicDialectInterface
    : public DialectInterface::Base<OrbAtomicDialectInterface> {
public:
  using Base::Base;

  llvm::DenseMap<uint64_t, Operation *> idToOp;
  llvm::SmallVector<uint64_t> ids;

  Operation *getOpForId(uint64_t id) const {
    auto it = idToOp.find(id);
    return it != idToOp.end() ? it->second : nullptr;
  }

  virtual bool isMemoryEvent(Operation* op) const = 0;
  virtual bool isFenceEvent(uint64_t id) const { return false; }
  virtual bool isReadEvent(uint64_t id) const { return false; }
  virtual bool isWriteEvent(uint64_t id) const { return false; }
  virtual bool isRMWEvent(Operation* op) const { return false; }

  // virtual int getSuccessOrder(uint64_t id) const { return 0; }
  // virtual int getFailureOrder(uint64_t id) const { return 0; }
  // virtual int getReadOrder(uint64_t id) const { return 0; }
  // virtual int getWriteOrder(uint64_t id) const { return 0; }

  virtual EventOrder getOrder(uint64_t idA, uint64_t idB,
                              AliasAnalysis &aliasAnalysis,
                              DominanceInfo &dominance) const = 0;
  /// Returns Ordered if `f` (a fence op) orders (a, b) per dialect fence rules.
  virtual EventOrder getOrderThroughFence(uint64_t idA, uint64_t idF,
                                          uint64_t idB) const = 0;
  virtual llvm::SmallVector<Promotion> promote(uint64_t idA,
                                               uint64_t idB) const = 0;
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
  /// Ordering for cross-region pairs where opCanReach() is true but getOrder() returned Unordered.
  virtual EventOrder getOrderCrossRegion(uint64_t idA, uint64_t idB,
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

  /// Fills `before`/`after` with IDs paired with fence `idF` in required pairs.
  void pairsWithFence(uint64_t idF,
                      llvm::SmallVectorImpl<uint64_t> &before,
                      llvm::SmallVectorImpl<uint64_t> &after) const;

private:
  llvm::SmallVector<std::pair<uint64_t, uint64_t>> pairs;
};

} // namespace mlir::orb

#endif // MLIR_DIALECT_ORB_ORBATOMICINTERFACE_H
