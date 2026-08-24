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

    if (reach.canReach(ev, f)) {
      EventOrder order = queryOrder(ev, f, iface, aa, dom);
      bool isBackEdge = sameRegion && dom.dominates(f, ev);
      if (isBackEdge) {
        setOrderTracked(ev0, f1, order); // cross-iteration
      } else {
        setOrderTracked(ev0, f0, order); // same-iteration
        setOrderTracked(ev1, f1, order); // shifted copy
      }
    }
    if (reach.canReach(f, ev)) {
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
  applyFenceClosure(fOrigIdx, iface, dom, postDom, reach);
}

void OrderMatrix::closeTransitively(const OrbAtomicDialectInterface *iface,
                                    unsigned maxRounds) {
  if (n == 0)
    return;
  // Build set of fence doubled-indices to skip as intermediaries.
  // Ordering through fences requires post-dom/dom checks (applyFenceClosure).
  llvm::BitVector fenceIndices(n);
  if (iface) {
    for (unsigned i = 0; i < nEvents; ++i)
      if (iface->isFenceEvent(idToOp[ids[i]])) {
        fenceIndices.set(2 * i);
        fenceIndices.set(2 * i + 1);
      }
  }

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
        // Skip fence intermediaries — transitivity through fences
        // requires post-dom/dom checks done by applyFenceClosure.
        if (fenceIndices.test(c))
          continue;
        llvm::BitVector newBits = ordered[c];
        newBits &= unordered[a];
        newBits.reset(a);
        if (newBits.none())
          continue;
        for (int b = newBits.find_first(); b != -1; b = newBits.find_next(b)) {
          matrix[a * n + b] = EventOrder::Ordered;
          trackNewOrdered(a, b);
          ++added;
        }
        ordered[a] |= newBits;
        unordered[a].reset(newBits);
        changed = true;
      }
    }
  }
  llvm::errs() << "[OrderMatrix] closeTransitively: rounds=" << rounds
               << " added=" << added << "\n";
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

    if (reach.canReach(ev, f)) {
      EventOrder order = queryOrder(ev, f, iface, aa, dom);
      bool isBackEdge = sameRegion && dom.dominates(f, ev);
      if (isBackEdge) {
        setOrderTracked(ev0, f1, order);
      } else {
        setOrderTracked(ev0, f0, order);
        setOrderTracked(ev1, f1, order);
      }
    }
    if (reach.canReach(f, ev)) {
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
  applyFenceClosure(fIdx, iface, dom, postDom, reach);
}

void OrderMatrix::precomputeIntermediateFences(
    const OrbAtomicDialectInterface *iface,
    DominanceInfo &dom, PostDominanceInfo &postDom,
    const CallReachability &reach) {
  fenceEventIndices.clear();
  for (unsigned i = 0; i < nEvents; ++i)
    if (iface->isFenceEvent(idToOp[ids[i]]))
      fenceEventIndices.push_back(i);
  nFencesCached = fenceEventIndices.size();

  // For each (event, fence) pair, check if the fence is a valid intermediary:
  //   validFencesAfter[ev]:  fence post-dominates ev (fence is on ALL paths from ev)
  //   validFencesBefore[ev]: fence dominates ev (fence is on ALL paths to ev)
  // Using post-dominance for "after" allows fences at merge points to cover
  // all branches, preventing duplicate fence insertions in sibling blocks.
  validFencesAfter.assign(nEvents, llvm::BitVector(nFencesCached));
  validFencesBefore.assign(nEvents, llvm::BitVector(nFencesCached));
  for (unsigned fi = 0; fi < nFencesCached; ++fi) {
    unsigned fIdx = fenceEventIndices[fi];
    Operation *fOp = idToOp[ids[fIdx]];
    Block *fBlock = fOp->getBlock();
    Region *fRegion = fBlock->getParent();
    for (unsigned ev = 0; ev < nEvents; ++ev) {
      if (ev == fIdx)
        continue;
      Operation *evOp = idToOp[ids[ev]];
      Block *evBlock = evOp->getBlock();
      Region *evRegion = evBlock->getParent();
      // validFencesAfter[ev]: fence is after ev on all paths.
      // Same region: fence's block post-dominates ev's block.
      if (evRegion == fRegion) {
        if (postDom.postDominates(fBlock, evBlock))
          validFencesAfter[ev].set(fi);
      } else if (reach.canReach(evOp, fOp)) {
        validFencesAfter[ev].set(fi);
      }
      // validFencesBefore[ev]: fence is before ev on all paths.
      // Same region: fence's block dominates ev's block.
      // Cross region: canReach only — this is a candidate filter;
      // actual ordering semantics are checked by getOrderThroughFence.
      if (evRegion == fRegion) {
        if (dom.dominates(fBlock, evBlock))
          validFencesBefore[ev].set(fi);
      } else if (reach.canReach(fOp, evOp)) {
        validFencesBefore[ev].set(fi);
      }
    }
  }
}

void OrderMatrix::addIntermediateFence(
    unsigned fOrigIdx, const OrbAtomicDialectInterface *iface,
    DominanceInfo &dom, PostDominanceInfo &postDom,
    const CallReachability &reach) {
  unsigned fi = nFencesCached++;
  fenceEventIndices.push_back(fOrigIdx);
  Operation *fOp = idToOp[ids[fOrigIdx]];
  Block *fBlock = fOp->getBlock();
  Region *fRegion = fBlock->getParent();
  // Resize arrays to accommodate nEvents (which addFence already incremented).
  while (validFencesAfter.size() < nEvents)
    validFencesAfter.emplace_back(nFencesCached);
  while (validFencesBefore.size() < nEvents)
    validFencesBefore.emplace_back(nFencesCached);
  for (unsigned ev = 0; ev < nEvents; ++ev) {
    validFencesAfter[ev].resize(nFencesCached);
    validFencesBefore[ev].resize(nFencesCached);
    if (ev == fOrigIdx)
      continue;
    Operation *evOp = idToOp[ids[ev]];
    Block *evBlock = evOp->getBlock();
    Region *evRegion = evBlock->getParent();
    if (evRegion == fRegion) {
      if (postDom.postDominates(fBlock, evBlock))
        validFencesAfter[ev].set(fi);
      if (dom.dominates(fBlock, evBlock))
        validFencesBefore[ev].set(fi);
    } else {
      if (reach.canReach(evOp, fOp))
        validFencesAfter[ev].set(fi);
      if (reach.canReach(fOp, evOp))
        validFencesBefore[ev].set(fi);
    }
  }
}

llvm::SmallVector<unsigned>
OrderMatrix::fencesBetween(unsigned aIdx, unsigned bIdx) const {
  llvm::SmallVector<unsigned> result;
  if (aIdx >= validFencesAfter.size() || bIdx >= validFencesBefore.size())
    return result;
  llvm::BitVector inter = validFencesAfter[aIdx];
  inter &= validFencesBefore[bIdx];
  for (int fi = inter.find_first(); fi != -1; fi = inter.find_next(fi))
    result.push_back(fenceEventIndices[fi]);
  return result;
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
        (isa<ptr::LoadOp, ptr::StoreOp>(op) && !isStackSlotAccess(op)))
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

  // Build callersOf/calleesOf indices from directCalls.
  for (auto &[key, _] : reach.directCalls) {
    reach.callersOf[key.second].push_back(key.first);
    reach.calleesOf[key.first].push_back(key.second);
  }

  // Forward-call-only transitive closure (call edges only).
  for (Region *startRegion : allRegions) {
    auto &fwd = reach.forwardCallReach[startRegion];
    llvm::SmallVector<Region *> wl;
    for (Region *callee : callEdges[startRegion])
      wl.push_back(callee);
    while (!wl.empty()) {
      Region *r = wl.pop_back_val();
      if (!fwd.insert(r).second)
        continue;
      for (Region *callee : callEdges[r])
        wl.push_back(callee);
    }
  }

  // Return-only transitive closure (return/caller edges only).
  for (Region *startRegion : allRegions) {
    auto &ret = reach.returnReach[startRegion];
    llvm::SmallVector<Region *> wl;
    for (Region *caller : callerEdges[startRegion])
      wl.push_back(caller);
    while (!wl.empty()) {
      Region *r = wl.pop_back_val();
      if (!ret.insert(r).second)
        continue;
      for (Region *caller : callerEdges[r])
        wl.push_back(caller);
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

/// Check whether the fence f is on ALL paths to b.
/// Same-region: f's block must dominate b's block.
/// Cross-region: every call site from b's region (or an ancestor) to f's
/// region must dominate b's block (or the call to b's region).
bool orb::fenceDominatesTarget(Operation *f, Operation *b,
                               DominanceInfo &dom,
                               const CallReachability &reach) {
  Block *fBlock = f->getBlock();
  Block *bBlock = b->getBlock();
  Region *fRegion = fBlock->getParent();
  Region *bRegion = bBlock->getParent();

  if (fRegion == bRegion)
    return dom.dominates(fBlock, bBlock);

  // Cross-region: find a region that calls fRegion and either IS bRegion
  // or calls bRegion.

  // Case 1: bRegion calls fRegion (f is inside a callee of b's function).
  // The call returns, then b executes.  All call sites must dominate b.
  auto it1 = reach.directCalls.find({bRegion, fRegion});
  if (it1 != reach.directCalls.end()) {
    for (Operation *callOp : it1->second) {
      if (!dom.dominates(callOp->getBlock(), bBlock))
        return false;
    }
    return true;
  }

  // Case 2: common caller — fRegion and bRegion are siblings called from the
  // same parent.  Sound when ALL callers of bRegion also call fRegion (or a
  // region that forward-reaches fRegion) with those calls dominating the calls
  // to bRegion.
  {
    auto bCallersIt = reach.callersOf.find(bRegion);
    if (bCallersIt != reach.callersOf.end()) {
      bool allCallersValid = true;
      for (Region *callerR : bCallersIt->second) {
        auto bCallOpsIt = reach.directCalls.find({callerR, bRegion});
        if (bCallOpsIt == reach.directCalls.end()) {
          allCallersValid = false;
          break;
        }
        // Find calls from callerR to fRegion (or to a region that forward-reaches fRegion).
        bool callerCallsF = false;
        auto fCallOpsIt = reach.directCalls.find({callerR, fRegion});
        if (fCallOpsIt != reach.directCalls.end()) {
          // Direct call from caller to fRegion — check dominance.
          bool allDom = true;
          for (Operation *bCallOp : bCallOpsIt->second) {
            bool dominated = false;
            for (Operation *fCallOp : fCallOpsIt->second)
              if (dom.dominates(fCallOp->getBlock(), bCallOp->getBlock())) {
                dominated = true;
                break;
              }
            if (!dominated) { allDom = false; break; }
          }
          callerCallsF = allDom;
        }
        // Indirect: callerR calls some midRegion that forward-reaches fRegion.
        if (!callerCallsF) {
          auto calleesIt = reach.calleesOf.find(callerR);
          if (calleesIt != reach.calleesOf.end()) {
            for (Region *mid : calleesIt->second) {
              if (mid == bRegion || mid == fRegion)
                continue;
              if (!reach.forwardReaches(mid, fRegion))
                continue;
              auto midCallOpsIt = reach.directCalls.find({callerR, mid});
              if (midCallOpsIt == reach.directCalls.end())
                continue;
              bool allDom = true;
              for (Operation *bCallOp : bCallOpsIt->second) {
                bool dominated = false;
                for (Operation *midCallOp : midCallOpsIt->second)
                  if (dom.dominates(midCallOp->getBlock(), bCallOp->getBlock())) {
                    dominated = true;
                    break;
                  }
                if (!dominated) { allDom = false; break; }
              }
              if (allDom) { callerCallsF = true; break; }
            }
          }
        }
        if (!callerCallsF) {
          allCallersValid = false;
          break;
        }
      }
      if (allCallersValid)
        return true;
    }
  }

  // Case 3: fRegion calls bRegion (b is inside a callee of f's function).
  // f must dominate the call to bRegion within fRegion.
  auto it3 = reach.directCalls.find({fRegion, bRegion});
  if (it3 != reach.directCalls.end()) {
    for (Operation *callOp : it3->second) {
      if (!dom.dominates(fBlock, callOp->getBlock()))
        return false;
    }
    return true;
  }

  // Transitive forward: fRegion →+ bRegion through call chain.
  // If f dominates calls from fRegion to a direct callee mid, and mid
  // forward-reaches bRegion, then f executes before b.
  for (auto &[key, callOps] : reach.directCalls) {
    if (key.first != fRegion)
      continue;
    if (key.second != bRegion && !reach.forwardReaches(key.second, bRegion))
      continue;
    bool allDom = true;
    for (Operation *callOp : callOps)
      if (!dom.dominates(fBlock, callOp->getBlock())) {
        allDom = false;
        break;
      }
    if (allDom)
      return true;
  }

  // Transitive backward: bRegion →+ fRegion through call chain.
  // If calls from bRegion to a direct callee mid dominate bBlock, and mid
  // forward-reaches fRegion, then f (inside callee) executes before b.
  for (auto &[key, callOps] : reach.directCalls) {
    if (key.first != bRegion)
      continue;
    if (key.second != fRegion && !reach.forwardReaches(key.second, fRegion))
      continue;
    bool allDom = true;
    for (Operation *callOp : callOps)
      if (!dom.dominates(callOp->getBlock(), bBlock)) {
        allDom = false;
        break;
      }
    if (allDom)
      return true;
  }

  return false;
}

/// Check whether fence f is on ALL paths FROM a (f post-dominates a).
bool orb::fencePostDominatesSource(Operation *f, Operation *a,
                                   PostDominanceInfo &postDom,
                                   const CallReachability &reach) {
  Block *fBlock = f->getBlock();
  Block *aBlock = a->getBlock();
  Region *fRegion = fBlock->getParent();
  Region *aRegion = aBlock->getParent();

  if (fRegion == aRegion)
    return postDom.postDominates(fBlock, aBlock);

  // aRegion calls fRegion: call sites must post-dominate a.
  auto it1 = reach.directCalls.find({aRegion, fRegion});
  if (it1 != reach.directCalls.end()) {
    for (Operation *callOp : it1->second)
      if (!postDom.postDominates(callOp->getBlock(), aBlock))
        return false;
    return true;
  }
  // fRegion calls aRegion: f must post-dominate the call.
  auto it2 = reach.directCalls.find({fRegion, aRegion});
  if (it2 != reach.directCalls.end()) {
    for (Operation *callOp : it2->second)
      if (!postDom.postDominates(fBlock, callOp->getBlock()))
        return false;
    return true;
  }
  return false;
}

void OrderMatrix::applyFenceClosure(unsigned fOrigIdx,
                                    const OrbAtomicDialectInterface *iface,
                                    DominanceInfo &dom,
                                    PostDominanceInfo &postDom,
                                    const CallReachability &reach) {
  Operation *f = idToOp[ids[fOrigIdx]];
  unsigned f0 = 2 * fOrigIdx, f1 = 2 * fOrigIdx + 1;

  // Precompute dominance/post-dominance for all events.
  // fDomTarget[ev]: fence dominates ev (fence on ALL paths TO ev).
  // fPostDomSource[ev]: fence post-dominates ev (fence on ALL paths FROM ev).
  // Both must hold for A→F→B ordering: F post-dom A AND F dom B.
  llvm::BitVector fDomTarget(nEvents);
  llvm::BitVector fPostDomSource(nEvents);
  for (unsigned ev = 0; ev < nEvents; ++ev) {
    if (ev == fOrigIdx)
      continue;
    if (fenceDominatesTarget(f, idToOp[ids[ev]], dom, reach))
      fDomTarget.set(ev);
    if (fencePostDominatesSource(f, idToOp[ids[ev]], postDom, reach))
      fPostDomSource.set(ev);
  }

  for (unsigned fD : {f0, f1}) {
    for (unsigned aD = 0; aD < n; ++aD) {
      if (aD == fD || matrix[aD * n + fD] != EventOrder::Ordered)
        continue;
      if (!fPostDomSource.test(aD / 2))
        continue;
      for (unsigned bD = 0; bD < n; ++bD) {
        if (bD == fD || bD == aD)
          continue;
        if (matrix[aD * n + bD] != EventOrder::Unordered)
          continue;
        if (matrix[fD * n + bD] != EventOrder::Ordered)
          continue;
        if (!fDomTarget.test(bD / 2))
          continue;
        Operation *a = idToOp[ids[aD / 2]];
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

  // No fence closure: fence-endpoint pairs (event→fence, fence→event)
  // are already in the matrix from the pairwise pass. Access-to-access
  // pairs derived through fences would be redundant — ARM synthesis
  // re-derives them via applyFenceClosure after upgrading the fence.
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
          // Fence-derived ordering only valid when fence is on ALL paths to b.
          if (!fenceDominatesTarget(f, b, dominance, reach))
            continue;
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
