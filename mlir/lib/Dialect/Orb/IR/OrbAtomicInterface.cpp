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
  // Same-iteration view: even indices (2a, 2b).
  return matrix[2 * a * n + 2 * b];
}

EventOrder OrderMatrix::getCrossIterOrder(uint64_t idA, uint64_t idB) const {
  if (idA >= idToIdx.size() || idB >= idToIdx.size())
    return EventOrder::Unreachable;
  unsigned a = idToIdx[idA], b = idToIdx[idB];
  if (a == UINT_MAX || b == UINT_MAX)
    return EventOrder::Unreachable;
  // Cross-iteration view: (2a, 2b+1).
  return matrix[2 * a * n + 2 * b + 1];
}

bool OrderMatrix::isOrdered(uint64_t idA, uint64_t idB) const {
  return getOrder(idA, idB) == EventOrder::Ordered ||
         getCrossIterOrder(idA, idB) == EventOrder::Ordered;
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
  unsigned a = idToIdx[idA], b = idToIdx[idB];
  if (a == UINT_MAX || b == UINT_MAX)
    return;
  // Mark up to 3 doubled cells (skip Unreachable, skip (odd,even)):
  //   (2a, 2b)     — same iteration
  //   (2a+1, 2b+1) — shifted iteration copy
  //   (2a, 2b+1)   — cross iteration
  auto mark = [&](unsigned r, unsigned c) {
    auto &cell = matrix[r * n + c];
    if (cell == EventOrder::Unordered) {
      cell = EventOrder::Ordered;
      pendingEdges.push_back({r, c});
      trackNewOrdered(r, c);
    }
  };
  mark(2 * a, 2 * b);
  mark(2 * a + 1, 2 * b + 1);
  mark(2 * a, 2 * b + 1);
}

void OrderMatrix::addFence(Operation *f, const OrbAtomicDialectInterface *iface,
                           AliasAnalysis &aa, DominanceInfo &dom,
                           PostDominanceInfo &postDom,
                           const CallReachability &reach) {
  auto idAttr = f->getAttrOfType<IntegerAttr>(kEventIdAttr);
  assert(idAttr && "fence must have orb.event_id before addFence");
  uint64_t fId = idAttr.getInt();

  unsigned fOrigIdx = nEvents; // original index for the new fence
  unsigned dimOld = n;         // old matrix dimension (2 * nEvents)
  unsigned dimNew = n + 2;     // new dimension (2 * (nEvents + 1))

  // Expand matrix from dimOld×dimOld to dimNew×dimNew in-place.
  matrix.resize(dimNew * dimNew, EventOrder::Unreachable);
  for (int i = (int)dimOld - 1; i >= 0; --i) {
    auto *row = &matrix[i * dimNew];
    std::copy_backward(&matrix[i * dimOld], &matrix[i * dimOld] + dimOld,
                        row + dimOld);
    row[dimOld] = EventOrder::Unreachable;
    row[dimOld + 1] = EventOrder::Unreachable;
  }

  n = dimNew;
  ++nEvents;
  ids.push_back(fId);
  if (fId >= idToIdx.size())
    idToIdx.resize(fId + 1, UINT_MAX);
  idToIdx[fId] = fOrigIdx;
  if (fId >= idToOp.size())
    idToOp.resize(fId + 1, nullptr);
  idToOp[fId] = f;

  Region *fRegion = f->getBlock()->getParent();
  unsigned f0 = 2 * fOrigIdx;     // same-iteration doubled index
  unsigned f1 = 2 * fOrigIdx + 1; // cross-iteration doubled index

  for (unsigned evIdx = 0; evIdx < nEvents - 1; ++evIdx) {
    Operation *ev = idToOp[ids[evIdx]];
    unsigned ev0 = 2 * evIdx, ev1 = 2 * evIdx + 1;
    bool sameRegion = ev->getBlock()->getParent() == fRegion;

    // Target-side: fence must be on ALL paths from ev to f (post-dominance)
    // and from f to ev (dominance). Reachability is too weak — a fence on
    // one branch of a conditional would falsely claim to order all events.
    if (postDom.postDominates(f, ev)) {
      EventOrder order = queryOrder(ev, f, iface, aa, dom);
      bool isBackEdge = sameRegion && dom.dominates(f, ev);
      if (isBackEdge) {
        setOrderTracked(ev0, f1, order); // cross-iteration
      } else {
        setOrderTracked(ev0, f0, order); // same-iteration
        setOrderTracked(ev1, f1, order); // shifted copy
      }
    }
    if (dom.dominates(f, ev)) {
      EventOrder order = queryOrder(f, ev, iface, aa, dom);
      bool isBackEdge = sameRegion && dom.dominates(ev, f);
      if (isBackEdge) {
        setOrderTracked(f0, ev1, order); // cross-iteration
      } else {
        setOrderTracked(f0, ev0, order); // same-iteration
        setOrderTracked(f1, ev1, order); // shifted copy
      }
    }
  }
  // applyFenceClosure uses doubled indices internally.
  applyFenceClosure(fOrigIdx, iface);
}

void OrderMatrix::closeTransitively(unsigned maxRounds) {
  if (n == 0)
    return;
  // With doubled matrix, the Unreachable (odd,even) quadrant structurally
  // prevents cross-iteration orderings from conflating with same-iteration.
  // No back-edge exclusion needed.
  llvm::SmallVector<llvm::BitVector> ordered(n, llvm::BitVector(n));
  llvm::SmallVector<llvm::BitVector> unordered(n, llvm::BitVector(n));
  for (unsigned a = 0; a < n; ++a)
    for (unsigned b = 0; b < n; ++b) {
      if (matrix[a * n + b] == EventOrder::Ordered)
        ordered[a].set(b);
      else if (matrix[a * n + b] == EventOrder::Unordered)
        unordered[a].set(b);
    }

  unsigned added = 0;
  bool changed = true;
  unsigned rounds = 0;
  while (changed && (maxRounds == 0 || rounds < maxRounds)) {
    changed = false;
    ++rounds;
    for (unsigned a = 0; a < n; ++a) {
      for (int c = ordered[a].find_first(); c != -1;
           c = ordered[a].find_next(c)) {
        llvm::BitVector newBits = ordered[c];
        newBits &= unordered[a];
        newBits.reset(a);
        if (newBits.none())
          continue;
        ordered[a] |= newBits;
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
    llvm::errs() << "[FenceSynthesis] lob* closure: nEvents=" << nEvents
                 << " dim=" << n << " added=" << added << "\n";
    closureReported = true;
  }
}

void OrderMatrix::closeIncrementally() {
  // Propagate only newly added edges transitively.
  // Doubled matrix structurally prevents cross-iteration conflation.
  unsigned idx = 0;
  while (idx < pendingEdges.size()) {
    auto [a, b] = pendingEdges[idx++];
    // Forward: a→b, b→c ⟹ a→c
    for (unsigned c = 0; c < n; ++c) {
      if (c != a && matrix[b * n + c] == EventOrder::Ordered &&
          matrix[a * n + c] == EventOrder::Unordered) {
        matrix[a * n + c] = EventOrder::Ordered;
        pendingEdges.push_back({a, c});
        trackNewOrdered(a, c);
      }
    }
    // Backward: c→a, a→b ⟹ c→b
    for (unsigned c = 0; c < n; ++c) {
      if (c != b && matrix[c * n + a] == EventOrder::Ordered &&
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
                                    PostDominanceInfo &postDom,
                                    const CallReachability &reach) {
  // fIdx is original event index; use doubled indices internally.
  Operation *f = idToOp[ids[fIdx]];
  unsigned f0 = 2 * fIdx, f1 = 2 * fIdx + 1;
  Region *fRegion = f->getBlock()->getParent();
  for (unsigned evIdx = 0; evIdx < nEvents; ++evIdx) {
    if (evIdx == fIdx)
      continue;
    Operation *ev = idToOp[ids[evIdx]];
    unsigned ev0 = 2 * evIdx, ev1 = 2 * evIdx + 1;
    bool sameRegion = ev->getBlock()->getParent() == fRegion;

    // Target-side: use dominance/post-dominance (see addFence comment).
    if (postDom.postDominates(f, ev)) {
      EventOrder order = queryOrder(ev, f, iface, aa, dom);
      bool isBackEdge = sameRegion && dom.dominates(f, ev);
      if (isBackEdge) {
        setOrderTracked(ev0, f1, order);
      } else {
        setOrderTracked(ev0, f0, order);
        setOrderTracked(ev1, f1, order);
      }
    }
    if (dom.dominates(f, ev)) {
      EventOrder order = queryOrder(f, ev, iface, aa, dom);
      bool isBackEdge = sameRegion && dom.dominates(ev, f);
      if (isBackEdge) {
        setOrderTracked(f0, ev1, order);
      } else {
        setOrderTracked(f0, ev0, order);
        setOrderTracked(f1, ev1, order);
      }
    }
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
  unsigned crossIterOnly = 0;
  for (uint64_t idA : matrix.eventIds())
    for (uint64_t idB : matrix.eventIds()) {
      if (idA == idB)
        continue;
      if (matrix.getOrder(idA, idB) == EventOrder::Ordered)
        pairs.emplace_back(idA, idB);
      else if (matrix.getCrossIterOrder(idA, idB) == EventOrder::Ordered) {
        pairs.emplace_back(idA, idB);
        ++crossIterOnly;
      }
    }
  llvm::errs() << "[OrderAnalysis] required=" << pairs.size()
               << " crossIterOnly=" << crossIterOnly << "\n";

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

void OrderMatrix::applyFenceClosure(unsigned fOrigIdx,
                                    const OrbAtomicDialectInterface *iface) {
  // fOrigIdx is the original event index. Iterate over all doubled indices.
  Operation *f = idToOp[ids[fOrigIdx]];
  unsigned f0 = 2 * fOrigIdx, f1 = 2 * fOrigIdx + 1;
  // Check both doubled fence indices as stepping stones.
  for (unsigned fD : {f0, f1}) {
    for (unsigned aD = 0; aD < n; ++aD) {
      if (aD == fD || matrix[aD * n + fD] != EventOrder::Ordered)
        continue;
      Operation *a = idToOp[ids[aD / 2]];
      for (unsigned bD = 0; bD < n; ++bD) {
        if (bD == fD || bD == aD)
          continue;
        if (matrix[aD * n + bD] != EventOrder::Unordered)
          continue;
        if (matrix[fD * n + bD] != EventOrder::Ordered)
          continue;
        Operation *b = idToOp[ids[bD / 2]];
        if (iface->getOrderThroughFence(a, f, b) == EventOrder::Ordered)
          setOrderTracked(aD, bD, EventOrder::Ordered);
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

  result.nEvents = result.ids.size();
  unsigned nEv = result.nEvents;
  result.n = 2 * nEv; // doubled matrix dimension
  unsigned dim = result.n;
  llvm::errs() << "[getOrderMatrix] n=" << nEv << "\n";
  result.matrix.assign(dim * dim, EventOrder::Unreachable);

  // Size flat lookup vectors.
  uint64_t maxId = 0;
  for (uint64_t id : result.ids)
    maxId = std::max(maxId, id);
  result.idToIdx.assign(maxId + 1, UINT_MAX);
  result.idToOp.assign(maxId + 1, nullptr);

  module.walk([&](Operation *op) {
    auto idAttr = op->getAttrOfType<IntegerAttr>(kEventIdAttr);
    if (!idAttr)
      return;
    uint64_t id = idAttr.getInt();
    result.idToOp[id] = op;
  });
  for (unsigned i = 0; i < nEv; ++i)
    result.idToIdx[result.ids[i]] = i;

  // Pairwise pass with doubled indices.
  // (2a, 2b) + (2a+1, 2b+1) = same-iteration (forward reachable)
  // (2a, 2b+1) = cross-iteration (back-edge reachable: same region, b dom a)
  // (2a+1, 2b) = always Unreachable
  unsigned backEdgeOrdered = 0, forwardOrdered = 0;
  for (unsigned aIdx = 0; aIdx < nEv; ++aIdx) {
    Operation *a = result.idToOp[result.ids[aIdx]];
    Region *aRegion = a->getBlock()->getParent();
    for (unsigned bIdx = 0; bIdx < nEv; ++bIdx) {
      if (aIdx == bIdx)
        continue;
      Operation *b = result.idToOp[result.ids[bIdx]];
      if (!reach.canReach(a, b))
        continue; // all 4 cells stay Unreachable

      EventOrder order = result.queryOrder(a, b, iface, aliasAnalysis, dominance);
      bool sameRegion = b->getBlock()->getParent() == aRegion;
      if (iface && order == EventOrder::Unordered && !sameRegion) {
        if (iface->getOrderCrossRegion(a, b, aliasAnalysis, dominance, reach) ==
            EventOrder::Ordered)
          order = EventOrder::Ordered;
      }

      bool isBackEdge = sameRegion && dominance.dominates(b, a);
      if (isBackEdge) {
        // Cross-iteration only.
        result.setOrder(2 * aIdx, 2 * bIdx + 1, order);
        if (order == EventOrder::Ordered)
          ++backEdgeOrdered;
      } else {
        // Same-iteration + shifted copy.
        result.setOrder(2 * aIdx, 2 * bIdx, order);
        result.setOrder(2 * aIdx + 1, 2 * bIdx + 1, order);
        if (order == EventOrder::Ordered)
          ++forwardOrdered;
      }
    }
  }
  llvm::errs() << "[getOrderMatrix] forwardOrdered=" << forwardOrdered
               << " backEdgeOrdered=" << backEdgeOrdered << "\n";

  if (!iface)
    return result;

  // Fence closure: find fences, then check a→f→b orderings.
  llvm::SmallVector<unsigned> fenceIdxs; // original indices of fence events
  for (unsigned i = 0; i < nEv; ++i) {
    Operation *op = result.idToOp[result.ids[i]];
    if (iface->isFenceEvent(op))
      fenceIdxs.push_back(i);
  }
  if (fenceIdxs.empty())
    return result;

  // Build fence reachability over doubled indices (same-iteration view).
  unsigned nF = fenceIdxs.size();
  llvm::SmallVector<llvm::BitVector> fencesAfter(nEv, llvm::BitVector(nF));
  llvm::SmallVector<llvm::BitVector> fencesBefore(nEv, llvm::BitVector(nF));
  for (unsigned fi = 0; fi < nF; ++fi) {
    unsigned fOrig = fenceIdxs[fi];
    for (unsigned ei = 0; ei < nEv; ++ei) {
      // Same-iteration: (2*ei, 2*f) ordered means ei→f in same iter.
      if (result.matrix[2 * ei * dim + 2 * fOrig] == EventOrder::Ordered)
        fencesAfter[ei].set(fi);
      if (result.matrix[2 * fOrig * dim + 2 * ei] == EventOrder::Ordered)
        fencesBefore[ei].set(fi);
    }
  }

  llvm::BitVector candidates(nF);
  for (unsigned aIdx = 0; aIdx < nEv; ++aIdx) {
    if (fencesAfter[aIdx].none())
      continue;
    Operation *a = result.idToOp[result.ids[aIdx]];
    for (unsigned bIdx = 0; bIdx < nEv; ++bIdx) {
      if (bIdx == aIdx)
        continue;
      // Check same-iteration cell.
      if (result.matrix[2 * aIdx * dim + 2 * bIdx] != EventOrder::Unordered)
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
            // Mark same-iteration + shifted.
            result.matrix[2 * aIdx * dim + 2 * bIdx] = EventOrder::Ordered;
            result.matrix[(2 * aIdx + 1) * dim + 2 * bIdx + 1] =
                EventOrder::Ordered;
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
