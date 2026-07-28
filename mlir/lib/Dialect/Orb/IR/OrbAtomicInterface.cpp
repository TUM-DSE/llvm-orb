//===- OrbAtomicInterface.cpp - Orb atomic ordering interface implementation ===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/Analysis/AliasAnalysis.h"
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/Dominance.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Pass/AnalysisManager.h"
#include "llvm/ADT/BitVector.h"
#include <cstring>

using namespace mlir;
using namespace mlir::orb;

//===----------------------------------------------------------------------===//
// OrderMatrix
//===----------------------------------------------------------------------===//

EventOrder OrderMatrix::getOrder(uint64_t idA, uint64_t idB) const {
  auto itA = idToIdx.find(idA), itB = idToIdx.find(idB);
  if (itA == idToIdx.end() || itB == idToIdx.end())
    return EventOrder::Unreachable;
  return matrix[itA->second * n + itB->second];
}

Operation *OrderMatrix::getOpForId(uint64_t id) const {
  auto it = idToOp.find(id);
  return it != idToOp.end() ? it->second : nullptr;
}

unsigned OrderMatrix::idxOf(uint64_t id) const {
  auto it = idToIdx.find(id);
  assert(it != idToIdx.end() && "event ID not in matrix");
  return it->second;
}

void OrderMatrix::applyAcqUpgrade(unsigned aIdx) {
  // Row sweep (stride-1): set all Unordered in row aIdx → Ordered.
  EventOrder *row = &matrix[aIdx * n];
  for (unsigned x = 0; x < n; ++x)
    if (row[x] == EventOrder::Unordered)
      row[x] = EventOrder::Ordered;
}

void OrderMatrix::applyAcqPCUpgrade(
    unsigned aIdx, llvm::ArrayRef<OrbAtomicDialectInterface *> ifaces) {
  // [R & ACQPC];po;[W] — only set Unordered write entries in row aIdx → Ordered.
  EventOrder *row = &matrix[aIdx * n];
  for (unsigned x = 0; x < n; ++x) {
    if (row[x] != EventOrder::Unordered)
      continue;
    Operation *op = idToOp[ids[x]];
    for (auto *iface : ifaces)
      if (iface->isWriteEvent(op)) { row[x] = EventOrder::Ordered; break; }
  }
}

void OrderMatrix::applyRelUpgrade(unsigned bIdx) {
  // Column sweep (stride-n): set all Unordered in column bIdx → Ordered.
  for (unsigned x = 0; x < n; ++x)
    if (matrix[x * n + bIdx] == EventOrder::Unordered)
      matrix[x * n + bIdx] = EventOrder::Ordered;
}

void OrderMatrix::addFence(Operation *f,
                           llvm::ArrayRef<OrbAtomicDialectInterface *> ifaces,
                           AliasAnalysis &aa, DominanceInfo &dom,
                           const CallReachability &reach) {
  auto idAttr = f->getAttrOfType<IntegerAttr>(kEventIdAttr);
  assert(idAttr && "fence must have orb.event_id before addFence");
  uint64_t fId = idAttr.getInt();

  unsigned nOld = n;
  unsigned nNew = n + 1;
  unsigned fIdx = nOld; // fence occupies the last index

  // Expand matrix from nOld×nOld to nNew×nNew in-place.
  // New cells (column nOld and row nOld) are initialized to Unreachable.
  matrix.resize(nNew * nNew, EventOrder::Unreachable);
  // Shift rows from back to front to avoid overwriting (row 0 is a no-op).
  for (int i = (int)nOld - 1; i > 0; --i) {
    memmove(&matrix[i * nNew], &matrix[i * nOld],
            nOld * sizeof(EventOrder));
    matrix[i * nNew + nOld] = EventOrder::Unreachable;
  }
  if (nOld > 0)
    matrix[nOld] = EventOrder::Unreachable; // column for row 0

  // Register fence in the index tables. From here on, n == nNew.
  n = nNew;
  ids.push_back(fId);
  idToIdx[fId] = fIdx;
  idToOp[fId] = f;

  Region *rF = f->getBlock()->getParent();

  // queryOrder: ask all ifaces for the ordering between two memory events.
  auto queryOrder = [&](Operation *a, Operation *b) -> EventOrder {
    for (auto *iface : ifaces)
      if (iface->isMemoryEvent(a) && iface->isMemoryEvent(b))
        return iface->getOrder(a, b, aa, dom);
    return EventOrder::Unreachable;
  };

  // Compute row/column for the new fence (indices 0..nOld-1 are existing events).
  for (unsigned evIdx = 0; evIdx < nOld; ++evIdx) {
    Operation *ev = idToOp[ids[evIdx]];
    Region *rEv = ev->getBlock()->getParent();
    if (rEv == rF || reach.reaches(rEv, rF))
      matrix[evIdx * n + fIdx] = queryOrder(ev, f);
    if (reach.opCanReach(f, rEv, dom))
      matrix[fIdx * n + evIdx] = queryOrder(f, ev);
  }

  // Fence closure: for all (a,b) where M[a][f]=Ordered AND M[f][b]=Ordered,
  // check getOrderThroughFence and set M[a][b]=Ordered if applicable.
  for (unsigned aIdx = 0; aIdx < nOld; ++aIdx) {
    if (matrix[aIdx * n + fIdx] != EventOrder::Ordered)
      continue;
    Operation *a = idToOp[ids[aIdx]];
    for (unsigned bIdx = 0; bIdx < nOld; ++bIdx) {
      if (bIdx == aIdx)
        continue;
      if (matrix[aIdx * n + bIdx] == EventOrder::Ordered)
        continue;
      if (matrix[fIdx * n + bIdx] != EventOrder::Ordered)
        continue;
      Operation *b = idToOp[ids[bIdx]];
      for (auto *iface : ifaces) {
        if (iface->getOrderThroughFence(a, f, b) == EventOrder::Ordered) {
          matrix[aIdx * n + bIdx] = EventOrder::Ordered;
          break;
        }
      }
    }
  }
}

void OrderMatrix::closeTransitively() {
  if (n == 0)
    return;
  // Build orderedAfter[a]: bitset of all b where matrix[a*n+b] == Ordered.
  llvm::SmallVector<llvm::BitVector> orderedAfter(n, llvm::BitVector(n));
  for (unsigned a = 0; a < n; ++a)
    for (unsigned b = 0; b < n; ++b)
      if (matrix[a * n + b] == EventOrder::Ordered)
        orderedAfter[a].set(b);

  unsigned added = 0;
  bool changed = true;
  while (changed) {
    changed = false;
    // Reverse walk order ≈ reverse topological: by the time we process c,
    // orderedAfter[c] already contains the full reachable set from c,
    // so one pass suffices for a DAG.
    for (int c = (int)n - 1; c >= 0; --c) {
      for (unsigned a = 0; a < n; ++a) {
        if ((unsigned)c == a || !orderedAfter[a].test(c))
          continue;
        // (a,c) Ordered: propagate c's orderings to a for Unordered cells.
        for (int b = orderedAfter[c].find_first(); b != -1;
             b = orderedAfter[c].find_next(b)) {
          if ((unsigned)b == a || orderedAfter[a].test(b))
            continue;
          if (matrix[a * n + b] == EventOrder::Unordered) {
            matrix[a * n + b] = EventOrder::Ordered;
            orderedAfter[a].set(b);
            ++added;
            changed = true;
          }
        }
      }
    }
  }
  llvm::errs() << "[FenceSynthesis] lob* closure: n=" << n
               << " added=" << added << "\n";
}

void OrderMatrix::applyFenceUpgrade(
    unsigned fIdx, llvm::ArrayRef<OrbAtomicDialectInterface *> ifaces,
    AliasAnalysis &aa, DominanceInfo &dom, const CallReachability &reach) {
  Operation *f = idToOp[ids[fIdx]];
  Region *rF = f->getBlock()->getParent();

  auto queryOrder = [&](Operation *a, Operation *b) -> EventOrder {
    for (auto *iface : ifaces)
      if (iface->isMemoryEvent(a) && iface->isMemoryEvent(b))
        return iface->getOrder(a, b, aa, dom);
    return EventOrder::Unreachable;
  };

  // Recompute row/column for the fence (memory order has changed to AcqRel).
  for (unsigned evIdx = 0; evIdx < n; ++evIdx) {
    if (evIdx == fIdx)
      continue;
    Operation *ev = idToOp[ids[evIdx]];
    Region *rEv = ev->getBlock()->getParent();
    if (rEv == rF || reach.reaches(rEv, rF))
      matrix[evIdx * n + fIdx] = queryOrder(ev, f);
    if (reach.opCanReach(f, rEv, dom))
      matrix[fIdx * n + evIdx] = queryOrder(f, ev);
  }

  // Fence closure: (a, f) Ordered AND (f, b) Ordered → check getOrderThroughFence.
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    if (aIdx == fIdx)
      continue;
    if (matrix[aIdx * n + fIdx] != EventOrder::Ordered)
      continue;
    Operation *a = idToOp[ids[aIdx]];
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (bIdx == fIdx || bIdx == aIdx)
        continue;
      if (matrix[aIdx * n + bIdx] == EventOrder::Ordered)
        continue;
      if (matrix[fIdx * n + bIdx] != EventOrder::Ordered)
        continue;
      Operation *b = idToOp[ids[bIdx]];
      for (auto *iface : ifaces) {
        if (iface->getOrderThroughFence(a, f, b) == EventOrder::Ordered) {
          matrix[aIdx * n + bIdx] = EventOrder::Ordered;
          break;
        }
      }
    }
  }
}

//===----------------------------------------------------------------------===//
// assignEventIds
//===----------------------------------------------------------------------===//

void mlir::orb::assignEventIds(ModuleOp module) {
  uint64_t nextId = 0;
  module.walk([&](Operation *op) {
    Dialect *d = op->getDialect();
    bool isOrbEvent =
        d->getRegisteredInterface<OrbAtomicDialectInterface>() &&
        d->getRegisteredInterface<OrbAtomicDialectInterface>()->isMemoryEvent(
            op);
    bool isPtrAccess = isa<ptr::LoadOp, ptr::StoreOp>(op);
    if (isOrbEvent || isPtrAccess) {
      OpBuilder b(op->getContext());
      op->setAttr(kEventIdAttr, b.getI64IntegerAttr(nextId++));
    }
  });
}

//===----------------------------------------------------------------------===//
// getOrderMatrix
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// OrderAnalysis
//===----------------------------------------------------------------------===//

void mlir::orb::OrderAnalysis::pairsWithFence(
    uint64_t idF, llvm::SmallVectorImpl<uint64_t> &before,
    llvm::SmallVectorImpl<uint64_t> &after) const {
  for (auto [a, b] : pairs) {
    if (b == idF)
      before.push_back(a);
    if (a == idF)
      after.push_back(b);
  }
}

mlir::orb::OrderAnalysis::OrderAnalysis(Operation *op, AnalysisManager &am) {
  auto module = dyn_cast<ModuleOp>(op);
  if (!module)
    return;
  llvm::errs() << "[OrderAnalysis] computing (recompute or first-time)\n";
  auto &aa  = am.getAnalysis<AliasAnalysis>();
  auto &dom = am.getAnalysis<DominanceInfo>();
  OrderMatrix matrix = getOrderMatrix(module, aa, dom);
  for (uint64_t idA : matrix.eventIds())
    for (uint64_t idB : matrix.eventIds())
      if (idA != idB && matrix.getOrder(idA, idB) == EventOrder::Ordered)
        pairs.emplace_back(idA, idB);
}

//===----------------------------------------------------------------------===//
// computeCallReachability
//===----------------------------------------------------------------------===//

CallReachability mlir::orb::computeCallReachability(ModuleOp module) {
  // Build call edges by walking CallOpInterface ops.
  // Avoids mlir::CallGraph which asserts on ops with empty getCallableForCallee().
  llvm::DenseMap<Region *, llvm::SmallVector<Region *>> callEdges;
  llvm::DenseMap<Region *, llvm::SmallVector<Region *>> callerEdges;
  CallReachability reach;

  module.walk([&](Operation *op) {
    auto call = dyn_cast<CallOpInterface>(op);
    if (!call)
      return;
    CallInterfaceCallable callable = call.getCallableForCallee();
    if (callable.isNull())
      return;
    auto symRef = dyn_cast<SymbolRefAttr>(callable);
    if (!symRef)
      return;
    auto *calleeOp = SymbolTable::lookupNearestSymbolFrom(op, symRef);
    auto calleeCallable = dyn_cast_or_null<CallableOpInterface>(calleeOp);
    if (!calleeCallable)
      return;
    Region *calleeRegion = calleeCallable.getCallableRegion();
    if (!calleeRegion)
      return;
    Region *callerRegion = nullptr;
    for (auto *parent = op->getParentOp(); parent;
         parent = parent->getParentOp()) {
      if (auto c = dyn_cast<CallableOpInterface>(parent)) {
        callerRegion = c.getCallableRegion();
        break;
      }
    }
    if (!callerRegion)
      return;
    callEdges[callerRegion].push_back(calleeRegion);
    callerEdges[calleeRegion].push_back(callerRegion);
    // Record the direct call op for position-aware reachability.
    reach.directCalls[{callerRegion, calleeRegion}].push_back(op);
  });

  // Collect all regions that appear in any edge.
  llvm::DenseSet<Region *> allRegions;
  for (auto &[r, _] : callEdges) allRegions.insert(r);
  for (auto &[r, _] : callerEdges) allRegions.insert(r);

  // BFS per region: reachable via call+return edges, with cycle safety.
  for (Region *startRegion : allRegions) {
    auto &reachable = reach.data[startRegion];
    llvm::DenseSet<Region *> visited;
    llvm::SmallVector<Region *> worklist = {startRegion};
    while (!worklist.empty()) {
      Region *r = worklist.pop_back_val();
      if (!visited.insert(r).second)
        continue;
      reachable.insert(r);
      for (Region *callee : callEdges[r])
        worklist.push_back(callee);
      for (Region *caller : callerEdges[r])
        worklist.push_back(caller);
    }
  }
  return reach;
}

//===----------------------------------------------------------------------===//
// getOrderMatrix
//===----------------------------------------------------------------------===//

OrderMatrix mlir::orb::getOrderMatrix(ModuleOp module,
                                      AliasAnalysis &aliasAnalysis,
                                      DominanceInfo &dominance,
                                      const CallReachability &reach) {
  OrderMatrix result;

  // Pass 1: collect all OrbAtomic interfaces.
  llvm::SmallDenseSet<OrbAtomicDialectInterface *> ifaceSet;
  module.walk([&](Operation *op) {
    if (auto *iface =
            op->getDialect()->getRegisteredInterface<OrbAtomicDialectInterface>())
      ifaceSet.insert(iface);
  });
  llvm::SmallVector<OrbAtomicDialectInterface *> allIfaces(ifaceSet.begin(),
                                                            ifaceSet.end());

  // Pass 2: collect ALL events (loads, stores, fences) into result.ids.
  // Fences are included as regular matrix entries — their row/column is computed
  // in the pairwise pass, eliminating redundant dominance checks in fence closure.
  module.walk([&](Operation *op) {
    auto idAttr = op->getAttrOfType<IntegerAttr>(kEventIdAttr);
    if (!idAttr)
      return;
    uint64_t id = idAttr.getInt();
    result.ids.push_back(id);
    result.idToOp[id] = op;
  });

  // Allocate flat n×n matrix.
  result.n = result.ids.size();
  unsigned n = result.n;
  llvm::errs() << "[getOrderMatrix] n=" << n << "\n";
  result.matrix.assign(n * n, EventOrder::Unreachable);
  for (unsigned i = 0; i < n; ++i)
    result.idToIdx[result.ids[i]] = i;

  auto queryOrder = [&](Operation *a, Operation *b) -> EventOrder {
    for (auto *iface : allIfaces)
      if (iface->isMemoryEvent(a) && iface->isMemoryEvent(b))
        return iface->getOrder(a, b, aliasAnalysis, dominance);
    return EventOrder::Unreachable;
  };

  // Pairwise pass: O(n²) over ALL events including fences.
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    Operation *a = result.idToOp[result.ids[aIdx]];
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (aIdx == bIdx) continue;
      Operation *b = result.idToOp[result.ids[bIdx]];
      Region *rB = b->getBlock()->getParent();
      EventOrder order = reach.opCanReach(a, rB, dominance)
                             ? queryOrder(a, b)
                             : EventOrder::Unreachable;
      result.setOrder(aIdx, bIdx, order);
    }
  }

  // Identify fence indices.
  llvm::SmallVector<unsigned> fenceIdxs;
  for (unsigned i = 0; i < n; ++i) {
    Operation *op = result.idToOp[result.ids[i]];
    for (auto *iface : allIfaces)
      if (iface->isFenceEvent(op)) { fenceIdxs.push_back(i); break; }
  }

  if (fenceIdxs.empty())
    return result;

  // Fence closure using bitsets.
  // fences_after[evIdx]: bit fi set if matrix[evIdx][fenceIdxs[fi]] == Ordered
  // fences_before[evIdx]: bit fi set if matrix[fenceIdxs[fi]][evIdx] == Ordered
  // Read directly from the matrix — no redundant queryOrder or dominance check.
  unsigned nF = fenceIdxs.size();
  llvm::SmallVector<llvm::BitVector> fencesAfter(n, llvm::BitVector(nF));
  llvm::SmallVector<llvm::BitVector> fencesBefore(n, llvm::BitVector(nF));

  for (unsigned fi = 0; fi < nF; ++fi) {
    unsigned fMat = fenceIdxs[fi];
    for (unsigned ei = 0; ei < n; ++ei) {
      if (result.matrix[ei * n + fMat] == EventOrder::Ordered)
        fencesAfter[ei].set(fi);
      if (result.matrix[fMat * n + ei] == EventOrder::Ordered)
        fencesBefore[ei].set(fi);
    }
  }

  // For each (a, b) pair not yet ordered, check if any fence closes it.
  llvm::BitVector candidates(nF);
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    if (fencesAfter[aIdx].none()) continue;
    Operation *a = result.idToOp[result.ids[aIdx]];
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (bIdx == aIdx) continue;
      if (result.matrix[aIdx * n + bIdx] == EventOrder::Ordered) continue;
      if (fencesBefore[bIdx].none()) continue;

      Operation *b = result.idToOp[result.ids[bIdx]];
      // Same-region: only order a→b if a precedes b in program order.
      // Cross-region pairs are already gated by call reachability.
      if (a->getBlock()->getParent() == b->getBlock()->getParent() &&
          !dominance.dominates(a, b))
        continue;

      candidates = fencesAfter[aIdx];
      candidates &= fencesBefore[bIdx];
      if (candidates.none()) continue;
      for (int fi = candidates.find_first(); fi != -1;
           fi = candidates.find_next(fi)) {
        Operation *f = result.idToOp[result.ids[fenceIdxs[fi]]];
        for (auto *iface : allIfaces)
          if (iface->getOrderThroughFence(a, f, b) == EventOrder::Ordered) {
            result.matrix[aIdx * n + bIdx] = EventOrder::Ordered;
            goto next_pair;
          }
      }
      next_pair:;
    }
  }

  return result;
}

OrderMatrix mlir::orb::getOrderMatrix(ModuleOp module,
                                      AliasAnalysis &aliasAnalysis,
                                      DominanceInfo &dominance) {
  return getOrderMatrix(module, aliasAnalysis, dominance,
                        computeCallReachability(module));
}
