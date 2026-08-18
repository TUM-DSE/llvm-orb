//===- OrbAtomicInterface.cpp - Orb atomic ordering interface implementation ===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Orb/OrbAtomicInterface.h"
#include "mlir/Analysis/AliasAnalysis.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "mlir/Dialect/Ptr/IR/PtrOps.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/Dominance.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/ViewLikeInterface.h"
#include "mlir/Pass/AnalysisManager.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/Support/Debug.h"
#include <algorithm>

#define DEBUG_TYPE "order-analysis"

using namespace mlir;
using namespace mlir::orb;

bool mlir::orb::isStackSlotAccess(Operation *op) {
  Value addr;
  if (auto load = dyn_cast<ptr::LoadOp>(op))
    addr = load.getPtr();
  else if (auto store = dyn_cast<ptr::StoreOp>(op))
    addr = store.getPtr();
  else
    return false;
  while (auto view =
             dyn_cast_or_null<ViewLikeOpInterface>(addr.getDefiningOp()))
    addr = view.getViewSource();
  return isa_and_nonnull<LLVM::AllocaOp>(addr.getDefiningOp());
}

//===----------------------------------------------------------------------===//
// OrderMatrix
//===----------------------------------------------------------------------===//

EventOrder OrderMatrix::getOrder(uint64_t idA, uint64_t idB) const {
  if (idA >= idToIdx.size() || idB >= idToIdx.size())
    return EventOrder::Unreachable;
  unsigned a = idToIdx[idA], b = idToIdx[idB];
  if (a == UINT_MAX || b == UINT_MAX)
    return EventOrder::Unreachable;
  return matrix[a * n + b];
}

Operation *OrderMatrix::getOpForId(uint64_t id) const {
  if (id >= idToOp.size())
    return nullptr;
  return idToOp[id];
}

unsigned OrderMatrix::idxOf(uint64_t id) const {
  assert(id < idToIdx.size() && idToIdx[id] != UINT_MAX &&
         "event ID not in matrix");
  return idToIdx[id];
}

unsigned OrderMatrix::countCells(EventOrder order) const {
  return llvm::count(matrix, order);
}

void OrderMatrix::markOrdered(uint64_t idA, uint64_t idB) {
  if (idA >= idToIdx.size() || idB >= idToIdx.size())
    return;
  unsigned aIdx = idToIdx[idA], bIdx = idToIdx[idB];
  if (aIdx == UINT_MAX || bIdx == UINT_MAX)
    return;
  auto &cell = matrix[aIdx * n + bIdx];
  if (cell == EventOrder::Unordered) {
    cell = EventOrder::Ordered;
    pendingEdges.push_back({aIdx, bIdx});
    trackNewOrdered(aIdx, bIdx);
  }
}

void OrderMatrix::addFence(Operation *f, const OrbAtomicDialectInterface *iface,
                           AliasAnalysis &aa, DominanceInfo &dom,
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
  ids.push_back(fId);
  if (fId >= idToIdx.size())
    idToIdx.resize(fId + 1, UINT_MAX);
  idToIdx[fId] = fIdx;
  if (fId >= idToOp.size())
    idToOp.resize(fId + 1, nullptr);
  idToOp[fId] = f;

  // Grow backEdge for the new fence column/row.
  for (auto &bv : backEdge)
    bv.resize(nNew);
  backEdge.push_back(llvm::BitVector(nNew));
  Region *fRegion = f->getBlock()->getParent();
  for (unsigned evIdx = 0; evIdx < nOld; ++evIdx) {
    Operation *ev = idToOp[ids[evIdx]];
    if (ev->getBlock()->getParent() != fRegion)
      continue;
    if (dom.dominates(f, ev))
      backEdge[evIdx].set(fIdx);
    if (dom.dominates(ev, f))
      backEdge[fIdx].set(evIdx);
  }

  for (unsigned evIdx = 0; evIdx < nOld; ++evIdx) {
    Operation *ev = idToOp[ids[evIdx]];
    if (reach.canReach(ev, f))
      setOrderTracked(evIdx, fIdx, queryOrder(ev, f, iface, aa, dom));
    if (reach.canReach(f, ev))
      setOrderTracked(fIdx, evIdx, queryOrder(f, ev, iface, aa, dom));
  }
  applyFenceClosure(fIdx, iface);
}

void OrderMatrix::closeTransitively(unsigned maxRounds) {
  if (n == 0)
    return;
  // forwardOrdered[a]: bitset of b where matrix[a*n+b] == Ordered AND
  // (a,b) is NOT a back-edge pair.  Back-edge orderings represent
  // cross-iteration relationships and must not be used as stepping stones
  // in transitive closure (they would conflate iteration N with N+1).
  llvm::SmallVector<llvm::BitVector> forwardOrdered(n, llvm::BitVector(n));
  llvm::SmallVector<llvm::BitVector> unordered(n, llvm::BitVector(n));
  for (unsigned a = 0; a < n; ++a)
    for (unsigned b = 0; b < n; ++b) {
      if (matrix[a * n + b] == EventOrder::Ordered) {
        if (a < backEdge.size() && !backEdge[a].test(b))
          forwardOrdered[a].set(b);
      } else if (matrix[a * n + b] == EventOrder::Unordered) {
        unordered[a].set(b);
      }
    }

  unsigned added = 0;
  bool changed = true;
  unsigned rounds = 0;
  while (changed && (maxRounds == 0 || rounds < maxRounds)) {
    changed = false;
    ++rounds;
    for (unsigned a = 0; a < n; ++a) {
      for (int c = forwardOrdered[a].find_first(); c != -1;
           c = forwardOrdered[a].find_next(c)) {
        // newBits = forwardOrdered[c] ∩ unordered[a]
        llvm::BitVector newBits = forwardOrdered[c];
        newBits &= unordered[a];
        newBits.reset(a);
        if (newBits.none())
          continue;
        forwardOrdered[a] |= newBits;
        unordered[a].reset(newBits);
        for (int b = newBits.find_first(); b != -1; b = newBits.find_next(b)) {
          matrix[a * n + b] = EventOrder::Ordered;
          trackNewOrdered(a, b);
          ++added;
        }
        changed = true;
      }
    }
  }
  pendingEdges.clear();
  if (!closureReported) {
    llvm::errs() << "[FenceSynthesis] lob* closure: n=" << n
                 << " added=" << added << "\n";
    closureReported = true;
  }
}

void OrderMatrix::closeIncrementally() {
  // Propagate only newly added edges transitively, skipping back-edge pairs.
  unsigned idx = 0;
  while (idx < pendingEdges.size()) {
    auto [a, b] = pendingEdges[idx++];
    // Skip back-edge ordered entries as stepping stones.
    if (a < backEdge.size() && backEdge[a].test(b))
      continue;
    // Forward: a→b, b→c ⟹ a→c (only if b→c is not back-edge)
    for (unsigned c = 0; c < n; ++c) {
      if (c != a && matrix[b * n + c] == EventOrder::Ordered &&
          !(b < backEdge.size() && backEdge[b].test(c)) &&
          matrix[a * n + c] == EventOrder::Unordered) {
        matrix[a * n + c] = EventOrder::Ordered;
        pendingEdges.push_back({a, c});
        trackNewOrdered(a, c);
      }
    }
    // Backward: c→a, a→b ⟹ c→b (only if c→a is not back-edge)
    for (unsigned c = 0; c < n; ++c) {
      if (c != b && matrix[c * n + a] == EventOrder::Ordered &&
          !(c < backEdge.size() && backEdge[c].test(a)) &&
          matrix[c * n + b] == EventOrder::Unordered) {
        matrix[c * n + b] = EventOrder::Ordered;
        pendingEdges.push_back({c, b});
        trackNewOrdered(c, b);
      }
    }
  }
  pendingEdges.clear();
}

void OrderMatrix::applyFenceUpgrade(unsigned fIdx, const OrbAtomicDialectInterface *iface,
                                    AliasAnalysis &aa, DominanceInfo &dom,
                                    const CallReachability &reach) {
  Operation *f = idToOp[ids[fIdx]];
  for (unsigned evIdx = 0; evIdx < n; ++evIdx) {
    if (evIdx == fIdx)
      continue;
    Operation *ev = idToOp[ids[evIdx]];
    if (matrix[evIdx * n + fIdx] != EventOrder::Unreachable &&
        reach.canReach(ev, f))
      setOrderTracked(evIdx, fIdx, queryOrder(ev, f, iface, aa, dom));
    if (matrix[fIdx * n + evIdx] != EventOrder::Unreachable &&
        reach.canReach(f, ev))
      setOrderTracked(fIdx, evIdx, queryOrder(f, ev, iface, aa, dom));
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
    if ((iface && iface->isMemoryEvent(op)) ||
        isa<ptr::LoadOp, ptr::StoreOp>(op))
      op->setAttr(kEventIdAttr, b.getI64IntegerAttr(nextId++));
  });
}

//===----------------------------------------------------------------------===//
// OrderAnalysis
//===----------------------------------------------------------------------===//

mlir::orb::OrderAnalysis::OrderAnalysis(Operation *op, AnalysisManager &am) {
  auto module = dyn_cast<ModuleOp>(op);
  if (!module)
    return;
  llvm::errs() << "[OrderAnalysis] computing (recompute or first-time)\n";
  auto &aa  = am.getAnalysis<AliasAnalysis>();
  auto &dom = am.getAnalysis<DominanceInfo>();
  const OrbAtomicDialectInterface *iface = nullptr;
  module.walk([&](Operation *op) -> WalkResult {
    if (auto *i =
            op->getDialect()
                ->getRegisteredInterface<OrbAtomicDialectInterface>()) {
      iface = i;
      return WalkResult::interrupt();
    }
    return WalkResult::advance();
  });
  auto reach = computeCallReachability(module);
  OrderMatrix matrix = getOrderMatrix(module, aa, dom, iface, reach);
  for (uint64_t idA : matrix.eventIds())
    for (uint64_t idB : matrix.eventIds())
      if (idA != idB && matrix.getOrder(idA, idB) == EventOrder::Ordered)
        pairs.emplace_back(idA, idB);

  LLVM_DEBUG({
    auto funcName = [](Operation *op) -> StringRef {
      for (auto *parent = op->getParentOp(); parent;
           parent = parent->getParentOp())
        if (auto sym = parent->getAttrOfType<StringAttr>(
                mlir::SymbolTable::getSymbolAttrName()))
          return sym.getValue();
      return "<unknown>";
    };
    llvm::dbgs() << "[OrderAnalysis] events=" << matrix.eventIds().size()
                 << " required_pairs=" << pairs.size() << "\n";
    for (auto [idA, idB] : pairs) {
      Operation *a = matrix.getOpForId(idA);
      Operation *b = matrix.getOpForId(idB);
      llvm::dbgs() << "  (" << idA << ", " << idB << ") "
                   << a->getName() << " @ " << a->getLoc()
                   << " [" << funcName(a) << "]"
                   << " -> " << b->getName() << " @ " << b->getLoc()
                   << " [" << funcName(b) << "]\n";
    }
  });
}

//===----------------------------------------------------------------------===//
// computeCallReachability
//===----------------------------------------------------------------------===//

CallReachability mlir::orb::computeCallReachability(ModuleOp module) {
  // Build call edges by walking CallOpInterface ops.
  llvm::DenseMap<Region *, llvm::SmallVector<Region *>> callEdges;
  llvm::DenseMap<Region *, llvm::SmallVector<Region *>> callerEdges;
  CallReachability reach;

  // Cross-function block edges for interprocedural BFS.
  llvm::DenseMap<Block *, llvm::SmallVector<Block *>> crossEdges;

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

    // Region-level edges.
    callEdges[callerRegion].push_back(calleeRegion);
    callerEdges[calleeRegion].push_back(callerRegion);
    reach.directCalls[{callerRegion, calleeRegion}].push_back(op);

    // Block-level cross-function edges.
    if (calleeRegion->empty())
      return;
    Block *callerBlock = op->getBlock();
    Block &calleeEntry = calleeRegion->front();
    crossEdges[callerBlock].push_back(&calleeEntry);
    for (Block &b : *calleeRegion) {
      if (b.hasNoSuccessors() || b.getNumSuccessors() == 0) {
        crossEdges[&b].push_back(callerBlock);
        for (Block *succ : callerBlock->getSuccessors())
          crossEdges[&b].push_back(succ);
      }
    }
  });

  // Region-level transitive closure.
  llvm::DenseSet<Region *> allRegions;
  for (auto &[r, _] : callEdges) allRegions.insert(r);
  for (auto &[r, _] : callerEdges) allRegions.insert(r);
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

  // Collect all blocks into a dense index.
  module.walk([&](Operation *op) {
    auto callable = dyn_cast<CallableOpInterface>(op);
    if (!callable)
      return;
    Region *body = callable.getCallableRegion();
    if (!body)
      return;
    for (Block &b : *body) {
      reach.blockIndex[&b] = reach.allBlocks.size();
      reach.allBlocks.push_back(&b);
    }
  });

  unsigned numBlocks = reach.allBlocks.size();
  if (numBlocks == 0)
    return reach;

  // Identify event blocks (containing ops with orb.event_id).
  llvm::DenseSet<Block *> eventBlocks;
  module.walk([&](Operation *op) {
    if (op->hasAttr(kEventIdAttr))
      eventBlocks.insert(op->getBlock());
  });

  LLVM_DEBUG(llvm::dbgs() << "[Reachability] numBlocks=" << numBlocks
                          << " eventBlocks=" << eventBlocks.size()
                          << " crossEdges=" << crossEdges.size() << "\n");

  // Sparse matrix: only event blocks get a row.
  llvm::SmallVector<Block *> eventBlockList(eventBlocks.begin(),
                                            eventBlocks.end());
  for (unsigned i = 0; i < eventBlockList.size(); ++i)
    reach.eventRowIndex[eventBlockList[i]] = i;

  unsigned numRows = eventBlockList.size();
  reach.blockReachRows.assign(numRows, llvm::BitVector(numBlocks, false));

  // BFS from each event block: CFG + cross-function edges, no depth limit.
  for (unsigned row = 0; row < numRows; ++row) {
    auto &bv = reach.blockReachRows[row];
    unsigned startIdx = reach.blockIndex[eventBlockList[row]];
    bv.set(startIdx);
    llvm::SmallVector<unsigned> worklist = {startIdx};
    while (!worklist.empty()) {
      unsigned cur = worklist.pop_back_val();
      Block *curBlock = reach.allBlocks[cur];
      // CFG successors (intra-region).
      for (Block *succ : curBlock->getSuccessors()) {
        auto it = reach.blockIndex.find(succ);
        if (it == reach.blockIndex.end())
          continue;
        unsigned si = it->second;
        if (!bv.test(si)) {
          bv.set(si);
          worklist.push_back(si);
        }
      }
      // Cross-function edges (call/return).
      auto ceIt = crossEdges.find(curBlock);
      if (ceIt == crossEdges.end())
        continue;
      for (Block *target : ceIt->second) {
        auto it = reach.blockIndex.find(target);
        if (it == reach.blockIndex.end())
          continue;
        unsigned ti = it->second;
        if (!bv.test(ti)) {
          bv.set(ti);
          worklist.push_back(ti);
        }
      }
    }
  }

  return reach;
}

bool CallReachability::canReach(Operation *from, Operation *to) const {
  Block *srcBlock = from->getBlock();
  Block *dstBlock = to->getBlock();
  if (srcBlock == dstBlock)
    return from->isBeforeInBlock(to);
  auto rowIt = eventRowIndex.find(srcBlock);
  auto colIt = blockIndex.find(dstBlock);
  if (rowIt == eventRowIndex.end() || colIt == blockIndex.end())
    return false;
  return blockReachRows[rowIt->second].test(colIt->second);
}

//===----------------------------------------------------------------------===//
// OrderMatrix private helpers
//===----------------------------------------------------------------------===//

EventOrder OrderMatrix::queryOrder(Operation *a, Operation *b,
                                   const OrbAtomicDialectInterface *iface,
                                   AliasAnalysis &aa, DominanceInfo &dom) const {
  if (iface && iface->isMemoryEvent(a) && iface->isMemoryEvent(b))
    return iface->getOrder(a, b, aa, dom);
  return EventOrder::Unreachable;
}

void OrderMatrix::applyFenceClosure(unsigned fIdx,
                                    const OrbAtomicDialectInterface *iface) {
  Operation *f = idToOp[ids[fIdx]];
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    if (aIdx == fIdx || matrix[aIdx * n + fIdx] != EventOrder::Ordered)
      continue;
    // Skip if a→f is a back-edge pair.
    if (aIdx < backEdge.size() && backEdge[aIdx].test(fIdx))
      continue;
    Operation *a = idToOp[ids[aIdx]];
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (bIdx == fIdx || bIdx == aIdx)
        continue;
      if (matrix[aIdx * n + bIdx] != EventOrder::Unordered)
        continue;
      if (matrix[fIdx * n + bIdx] != EventOrder::Ordered)
        continue;
      // Skip if f→b is a back-edge pair.
      if (fIdx < backEdge.size() && backEdge[fIdx].test(bIdx))
        continue;
      Operation *b = idToOp[ids[bIdx]];
      if (iface->getOrderThroughFence(a, f, b) == EventOrder::Ordered)
        setOrderTracked(aIdx, bIdx, EventOrder::Ordered);
    }
  }
}

//===----------------------------------------------------------------------===//
// getOrderMatrix
//===----------------------------------------------------------------------===//

OrderMatrix mlir::orb::getOrderMatrix(ModuleOp module,
                                      AliasAnalysis &aliasAnalysis,
                                      DominanceInfo &dominance,
                                      const OrbAtomicDialectInterface *iface,
                                      const CallReachability &reach) {
  OrderMatrix result;

  module.walk([&](Operation *op) {
    auto idAttr = op->getAttrOfType<IntegerAttr>(kEventIdAttr);
    if (!idAttr)
      return;
    uint64_t id = idAttr.getInt();
    result.ids.push_back(id);
  });

  result.n = result.ids.size();
  unsigned n = result.n;
  llvm::errs() << "[getOrderMatrix] n=" << n << "\n";
  result.matrix.assign(n * n, EventOrder::Unreachable);

  // Size flat lookup vectors. IDs are sequential 0..maxId, but we
  // allocate for the max ID seen to handle any gaps.
  uint64_t maxId = 0;
  for (uint64_t id : result.ids)
    maxId = std::max(maxId, id);
  result.idToIdx.assign(maxId + 1, UINT_MAX);
  result.idToOp.assign(maxId + 1, nullptr);

  // Populate: walk again to get the Operation* for each ID.
  module.walk([&](Operation *op) {
    auto idAttr = op->getAttrOfType<IntegerAttr>(kEventIdAttr);
    if (!idAttr)
      return;
    uint64_t id = idAttr.getInt();
    result.idToOp[id] = op;
  });
  for (unsigned i = 0; i < n; ++i)
    result.idToIdx[result.ids[i]] = i;

  // Pairwise pass; cross-region pairs also check cross-function deps.
  // Also compute back-edge flags: (a,b) is back-edge if b dominates a
  // within the same region (path from a to b goes through a loop back edge).
  result.backEdge.resize(n, llvm::BitVector(n));
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    Operation *a = result.idToOp[result.ids[aIdx]];
    Region *aRegion = a->getBlock()->getParent();
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (aIdx == bIdx)
        continue;
      Operation *b = result.idToOp[result.ids[bIdx]];
      if (!reach.canReach(a, b)) {
        result.setOrder(aIdx, bIdx, EventOrder::Unreachable);
        continue;
      }
      // Mark back-edge: same region and b dominates a.
      if (b->getBlock()->getParent() == aRegion &&
          dominance.dominates(b, a))
        result.backEdge[aIdx].set(bIdx);

      EventOrder order = result.queryOrder(a, b, iface, aliasAnalysis, dominance);
      if (iface && order == EventOrder::Unordered &&
          b->getBlock()->getParent() != aRegion) {
        if (iface->getOrderCrossRegion(a, b, aliasAnalysis, dominance, reach) ==
            EventOrder::Ordered)
          order = EventOrder::Ordered;
      }
      result.setOrder(aIdx, bIdx, order);
    }
  }

  if (!iface)
    return result;

  llvm::SmallVector<unsigned> fenceIdxs;
  for (unsigned i = 0; i < n; ++i) {
    Operation *op = result.idToOp[result.ids[i]];
    if (iface->isFenceEvent(op))
      fenceIdxs.push_back(i);
  }
  if (fenceIdxs.empty())
    return result;

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
    Operation *a = result.idToOp[result.ids[aIdx]];
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (bIdx == aIdx || result.matrix[aIdx * n + bIdx] != EventOrder::Unordered)
        continue;
      if (fencesBefore[bIdx].none())
        continue;
      Operation *b = result.idToOp[result.ids[bIdx]];
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
          Operation *f = result.idToOp[result.ids[fenceIdxs[fi]]];
          if (iface->getOrderThroughFence(a, f, b) == EventOrder::Ordered) {
            result.matrix[aIdx * n + bIdx] = EventOrder::Ordered;
            return;
          }
        }
      }();
    }
  }

  return result;
}

OrderMatrix mlir::orb::getOrderMatrix(ModuleOp module,
                                      AliasAnalysis &aliasAnalysis,
                                      DominanceInfo &dominance) {
  // Auto-discover the single registered OrbAtomicDialectInterface.
  const OrbAtomicDialectInterface *iface = nullptr;
  module.walk([&](Operation *op) -> WalkResult {
    if (auto *i =
            op->getDialect()->getRegisteredInterface<OrbAtomicDialectInterface>()) {
      iface = i;
      return WalkResult::interrupt();
    }
    return WalkResult::advance();
  });
  return getOrderMatrix(module, aliasAnalysis, dominance, iface,
                        computeCallReachability(module));
}
