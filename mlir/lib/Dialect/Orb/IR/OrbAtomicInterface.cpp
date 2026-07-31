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
#include <algorithm>

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

llvm::ArrayRef<uint64_t> OrderMatrix::eventIds(OrbAtomicDialectInterface *iface) const { 
    return iface ? llvm::ArrayRef<uint64_t>(iface->ids) : llvm::ArrayRef<uint64_t>(); 
}

unsigned OrderMatrix::idxOf(uint64_t id) const {
  auto it = idToIdx.find(id);
  assert(it != idToIdx.end() && "event ID not in matrix");
  return it->second;
}

void OrderMatrix::markOrdered(uint64_t idA, uint64_t idB) {
  auto itA = idToIdx.find(idA), itB = idToIdx.find(idB);
  if (itA == idToIdx.end() || itB == idToIdx.end())
    return;
  auto &cell = matrix[itA->second * n + itB->second];
  if (cell == EventOrder::Unordered)
    cell = EventOrder::Ordered;
}

void OrderMatrix::addFence(Operation *f,
                           AliasAnalysis &aa, DominanceInfo &dom, 
                           OrbAtomicDialectInterface *iface,
                           const CallReachability &reach) {
  auto idAttr = f->getAttrOfType<IntegerAttr>(kEventIdAttr);
  assert(idAttr && "fence must have orb.event_id before addFence");
  uint64_t fId = idAttr.getInt();

  unsigned nOld = n;
  unsigned nNew = n + 1;
  unsigned fIdx = nOld;

  // Expand matrix from nOld×nOld to nNew×nNew in-place (backward to avoid overwrite).
  matrix.resize(nNew * nNew, EventOrder::Unreachable);
  for (int i = (int)nOld - 1; i >= 0; --i) {
    auto *row = &matrix[i * nNew];
    std::copy_backward(&matrix[i * nOld], &matrix[i * nOld] + nOld, row + nOld);
    row[nOld] = EventOrder::Unreachable;
  }

  n = nNew;
  idToIdx[fId] = fIdx;
  iface->ids.push_back(fId);
  iface->idToOp[fId] = f;

  Region *rF = f->getBlock()->getParent();
  for (unsigned evIdx = 0; evIdx < nOld; ++evIdx) {
    uint64_t evId = iface->ids[evIdx];
    Operation *ev = iface->getOpForId(evId);
    if (!ev) continue;

    Region *rEv = ev->getBlock()->getParent();
    if (rEv == rF || reach.reaches(rEv, rF))
      matrix[evIdx * n + fIdx] = queryOrder(evId, fId, aa, dom, iface);
    if (reach.opCanReach(f, rEv, dom))
      matrix[fIdx * n + evIdx] = queryOrder(fId, evId, aa, dom, iface);
  }
  applyFenceClosure(fIdx, iface);
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
  llvm::errs() << "[FenceSynthesis] lob* closure: n=" << n << " added=" << added << "\n";
}

void OrderMatrix::applyFenceUpgrade(
    unsigned fIdx, AliasAnalysis &aa, DominanceInfo &dom, 
    OrbAtomicDialectInterface *iface, const CallReachability &reach) {
  
  uint64_t fId = iface->ids[fIdx];
  Operation *f = iface->getOpForId(fId);
  if (!f) return;

  Region *rF = f->getBlock()->getParent();
  for (unsigned evIdx = 0; evIdx < n; ++evIdx) {
    if (evIdx == fIdx) continue;

    uint64_t evId = iface->ids[evIdx];
    Operation *ev = iface->getOpForId(evId);
    if (!ev) continue;

    Region *rEv = ev->getBlock()->getParent();
    if (rEv == rF || reach.reaches(rEv, rF))
      matrix[evIdx * n + fIdx] = queryOrder(evId, fId, aa, dom, iface);
    if (reach.opCanReach(f, rEv, dom))
      matrix[fIdx * n + evIdx] = queryOrder(fId, evId, aa, dom, iface);
  }
  applyFenceClosure(fIdx, iface);
}

//===----------------------------------------------------------------------===//
// assignEventIds
//===----------------------------------------------------------------------===//

void mlir::orb::assignEventIds(ModuleOp module) {
  uint64_t nextId = 0;
  OpBuilder b(module->getContext());

  module.walk([&](Operation *op) {
    auto *iface =
        op->getDialect()->getRegisteredInterface<OrbAtomicDialectInterface>();
       
    bool isMem = iface && iface->isMemoryEvent(op);
    bool isRmw = iface && iface->isRMWEvent(op);     

    if (isRmw) {
      uint64_t baseId;

      if ((nextId & 1) == 0) {
        baseId = nextId;
      } else {
        baseId = ++nextId;
      }
      nextId++;
      
      uint64_t readId = baseId | kRmwMask;       // Ends in 0, high bit set
      uint64_t writeId = (baseId + 1) | kRmwMask; // Ends in 1, high bit set
      
      op->setAttr(kEventIdAttr, b.getArrayAttr({
        b.getI64IntegerAttr(readId),
        b.getI64IntegerAttr(writeId)
      }));

    } else if (isMem) {
      op->setAttr(kEventIdAttr, b.getI64IntegerAttr(nextId++));
    }  
  });
}

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

  OrbAtomicDialectInterface *iface = nullptr;
  module.walk([&](Operation *op) -> WalkResult {
    if (auto *i = op->getDialect()
                      ->getRegisteredInterface<OrbAtomicDialectInterface>()) {
      iface = i;
      return WalkResult::interrupt();
    }
    return WalkResult::advance();
  });
  if (!iface) {
    llvm::errs() << "[OrderAnalysis] ERROR: no OrbAtomicDialectInterface found\n";
    return;
  }

  OrderMatrix matrix = getOrderMatrix(module, aa, dom, iface);
  for (uint64_t idA : matrix.eventIds(iface))
    for (uint64_t idB : matrix.eventIds(iface))
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
// OrderMatrix private helpers
//===----------------------------------------------------------------------===//

EventOrder OrderMatrix::queryOrder(
    uint64_t idA, uint64_t idB, AliasAnalysis &aa, DominanceInfo &dom, 
    OrbAtomicDialectInterface *iface) const {

  Operation *a = iface->getOpForId(idA);
  Operation *b = iface->getOpForId(idB);
  if (a && b)
    return iface->getOrder(idA, idB, aa, dom);    

  return EventOrder::Unreachable;
}

void OrderMatrix::applyFenceClosure(unsigned fIdx, 
    OrbAtomicDialectInterface *iface) {

  uint64_t idF = iface->ids[fIdx];
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    if (aIdx == fIdx || matrix[aIdx * n + fIdx] != EventOrder::Ordered)
      continue;
    uint64_t idA = iface->ids[aIdx];
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (bIdx == fIdx || bIdx == aIdx)
        continue;
      if (matrix[aIdx * n + bIdx] == EventOrder::Ordered)
        continue;
      if (matrix[fIdx * n + bIdx] != EventOrder::Ordered)
        continue;
      uint64_t idB = iface->ids[bIdx];
      if (iface->getOrderThroughFence(idA, idF, idB) == EventOrder::Ordered) {
        matrix[aIdx * n + bIdx] = EventOrder::Ordered;
      }
    }
  }
}

//===----------------------------------------------------------------------===//
// getOrderMatrix
//===----------------------------------------------------------------------===//

OrderMatrix mlir::orb::getOrderMatrix(ModuleOp module,
                                      AliasAnalysis &aliasAnalysis,
                                      DominanceInfo &dominance, 
                                      OrbAtomicDialectInterface *iface, 
                                      const CallReachability &reach) {
  OrderMatrix result;

  module.walk([&](Operation *op) {
    if (op->getDialect()->getRegisteredInterface<OrbAtomicDialectInterface>() != iface) 
      return;

    if (iface->isRMWEvent(op)) {
      auto arrAttr = op->getAttrOfType<ArrayAttr>(kEventIdAttr);
      if (arrAttr && arrAttr.size() == 2) {

        uint64_t idRead = cast<IntegerAttr>(arrAttr[0]).getInt();
        uint64_t idWrite = cast<IntegerAttr>(arrAttr[1]).getInt();

        iface->ids.push_back(idRead);
        iface->ids.push_back(idWrite);
        iface->idToOp[idRead] = op;
        iface->idToOp[idWrite] = op;
      }
    } else {
      auto idAttr = op->getAttrOfType<IntegerAttr>(kEventIdAttr);

      if (idAttr) {
        uint64_t id = idAttr.getInt();
        iface->ids.push_back(id);
  
        iface->idToOp[id] = op;
      }
    }
  });

  result.n = iface->ids.size();
  unsigned n = result.n;
  llvm::errs() << "[getOrderMatrix] n=" << n << "\n";
  result.matrix.assign(n * n, EventOrder::Unreachable);
  for (unsigned i = 0; i < n; ++i)
    result.idToIdx[iface->ids[i]] = i;

  // Pairwise pass; cross-region pairs also check cross-function deps.
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    uint64_t idA = iface->ids[aIdx];
    Operation *a = iface->getOpForId(idA);
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (aIdx == bIdx)
        continue;

      uint64_t idB = iface->ids[bIdx];
      Operation *b = iface->getOpForId(idB);

      if (!reach.opCanReach(a, b->getBlock()->getParent(), dominance)) {
        result.setOrder(aIdx, bIdx, EventOrder::Unreachable);
        continue;
      }
      EventOrder order = result.queryOrder(idA, idB, aliasAnalysis, dominance, iface);
      if (order == EventOrder::Unordered &&
          a->getBlock()->getParent() != b->getBlock()->getParent()) {

        if (iface->getOrderCrossRegion(idA, idB, aliasAnalysis, dominance, reach) ==
            EventOrder::Ordered) {
          order = EventOrder::Ordered;
        }
      }
      result.setOrder(aIdx, bIdx, order);
    }
  }

  if (!iface)
    return result;

  llvm::SmallVector<unsigned> fenceIdxs;
  for (unsigned i = 0; i < n; ++i) {
    if (iface->isFenceEvent(iface->ids[i])) fenceIdxs.push_back(i);
  }
  if (fenceIdxs.empty()) return result;

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

  llvm::BitVector candidates(nF);
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    if (fencesAfter[aIdx].none())
      continue;

    uint64_t idA = iface->ids[aIdx];
    Operation *a = iface->getOpForId(idA);

    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (bIdx == aIdx || result.matrix[aIdx * n + bIdx] == EventOrder::Ordered)
        continue;
      if (fencesBefore[bIdx].none())
        continue;

      uint64_t idB = iface->ids[bIdx];
      Operation *b = iface->getOpForId(idB);

      if (a->getBlock()->getParent() == b->getBlock()->getParent() &&
          !dominance.dominates(a, b))
        continue;
      candidates = fencesAfter[aIdx];
      candidates &= fencesBefore[bIdx];
      if (candidates.none())
        continue;
      [&] {
        for (int fi = candidates.find_first(); fi != -1;
             fi = candidates.find_next(fi)) {
          uint64_t idF = iface->ids[fenceIdxs[fi]];
          if (iface->getOrderThroughFence(idA, idF, idB) == EventOrder::Ordered) {
            result.matrix[aIdx * n + bIdx] = EventOrder::Ordered;
            return;
          }
        }
      }();
    }
  }

  return result;
}

OrderMatrix mlir::orb::getOrderMatrix(ModuleOp module, AliasAnalysis &aliasAnalysis,
                                      DominanceInfo &dominance, 
                                      OrbAtomicDialectInterface *iface) {
  return getOrderMatrix(module, aliasAnalysis, dominance, iface,
                        computeCallReachability(module));
}
