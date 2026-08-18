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

unsigned OrderMatrix::countCells(EventOrder order) const {
  return llvm::count(matrix, order);
}

void OrderMatrix::markOrdered(uint64_t idA, uint64_t idB) {
  auto itA = idToIdx.find(idA), itB = idToIdx.find(idB);
  if (itA == idToIdx.end() || itB == idToIdx.end())
    return;
  unsigned aIdx = itA->second, bIdx = itB->second;
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
  idToIdx[fId] = fIdx;
  idToOp[fId] = f;

  Region *rF = f->getBlock()->getParent();
  for (unsigned evIdx = 0; evIdx < nOld; ++evIdx) {
    Operation *ev = idToOp.lookup(ids[evIdx]);
    Region *rEv = ev->getBlock()->getParent();
    if (rEv == rF || reach.reaches(rEv, rF))
      setOrderTracked(evIdx, fIdx, queryOrder(ev, f, iface, aa, dom));
    if (reach.opCanReach(f, ev, dom))
      setOrderTracked(fIdx, evIdx, queryOrder(f, ev, iface, aa, dom));
  }
  applyFenceClosure(fIdx, iface);
}

void OrderMatrix::closeTransitively(unsigned maxRounds) {
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
  unsigned rounds = 0;
  while (changed && (maxRounds == 0 || rounds < maxRounds)) {
    changed = false;
    ++rounds;
    for (int c = (int)n - 1; c >= 0; --c) {
      for (unsigned a = 0; a < n; ++a) {
        if ((unsigned)c == a || !orderedAfter[a].test(c))
          continue;
        for (int b = orderedAfter[c].find_first(); b != -1;
             b = orderedAfter[c].find_next(b)) {
          if ((unsigned)b == a || orderedAfter[a].test(b))
            continue;
          if (matrix[a * n + b] == EventOrder::Unordered) {
            matrix[a * n + b] = EventOrder::Ordered;
            orderedAfter[a].set(b);
            trackNewOrdered(a, b);
            ++added;
            changed = true;
          }
        }
      }
    }
  }
  pendingEdges.clear(); // Full closure consumed all edges.
  if (!closureReported) {
    llvm::errs() << "[FenceSynthesis] lob* closure: n=" << n
                 << " added=" << added << "\n";
    closureReported = true;
  }
}

void OrderMatrix::closeIncrementally() {
  // Propagate only newly added edges (from markOrdered) transitively.
  // Each edge is processed at most once; processing is O(n) per edge.
  unsigned idx = 0;
  while (idx < pendingEdges.size()) {
    auto [a, b] = pendingEdges[idx++];
    // Forward: a→b, b→c ⟹ a→c
    for (unsigned c = 0; c < n; ++c) {
      if (c != a && matrix[b * n + c] == EventOrder::Ordered &&
          matrix[a * n + c] == EventOrder::Unordered) {
        matrix[a * n + c] = EventOrder::Ordered;
        pendingEdges.push_back({a, c});
      }
    }
    // Backward: c→a, a→b ⟹ c→b
    for (unsigned c = 0; c < n; ++c) {
      if (c != b && matrix[c * n + a] == EventOrder::Ordered &&
          matrix[c * n + b] == EventOrder::Unordered) {
        matrix[c * n + b] = EventOrder::Ordered;
        pendingEdges.push_back({c, b});
      }
    }
  }
  pendingEdges.clear();
}

void OrderMatrix::applyFenceUpgrade(unsigned fIdx, const OrbAtomicDialectInterface *iface,
                                    AliasAnalysis &aa, DominanceInfo &dom,
                                    const CallReachability &reach) {
  Operation *f = idToOp.lookup(ids[fIdx]);
  Region *rF = f->getBlock()->getParent();
  for (unsigned evIdx = 0; evIdx < n; ++evIdx) {
    if (evIdx == fIdx)
      continue;
    Operation *ev = idToOp.lookup(ids[evIdx]);
    Region *rEv = ev->getBlock()->getParent();
    // Only re-evaluate reachable pairs. The coarse reaches() check can
    // consider pairs reachable that opCanReach() (used by getOrderMatrix)
    // marked as Unreachable. Overwriting those inflates overspecification.
    if (matrix[evIdx * n + fIdx] != EventOrder::Unreachable &&
        (rEv == rF || reach.reaches(rEv, rF)))
      setOrderTracked(evIdx, fIdx, queryOrder(ev, f, iface, aa, dom));
    if (matrix[fIdx * n + evIdx] != EventOrder::Unreachable &&
        reach.opCanReach(f, ev, dom))
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
  auto &blockReachAnalysis = am.getAnalysis<BlockReachabilityAnalysis>();
  // Use explicit overload so we can wire up block reachability.
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
  reach.blockReach = &blockReachAnalysis;
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

  // Precompute return+call pairs: for each callee rA, find all rB reachable
  // via return to a common parent rMid then call to rB.
  // For each rMid that calls rA: for each rB that rMid also calls (rB != rA):
  //   if any callToA dominates callToB in rMid, record the pair.
  for (auto &[keyA, callsToA] : reach.directCalls) {
    Region *rMid = keyA.first;
    Region *rA = keyA.second;
    for (auto &[keyB, callsToB] : reach.directCalls) {
      if (keyB.first != rMid || keyB.second == rA)
        continue;
      Region *rB = keyB.second;
      // Note: we only need to know IF a path exists; dominance of specific
      // ops is checked later. Store one representative pair.
      reach.returnCallPairs[{rA, rB}]; // insert empty entry = path exists
    }
  }

  return reach;
}

//===----------------------------------------------------------------------===//
// BlockReachabilityAnalysis
//===----------------------------------------------------------------------===//

BlockReachabilityAnalysis::BlockReachabilityAnalysis(Operation *op,
                                                     AnalysisManager &am) {
  auto module = cast<ModuleOp>(op);

  // Cross-function edges (call/return) — these increment the depth counter.
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
    if (!calleeRegion || calleeRegion->empty())
      return;

    Block *callerBlock = op->getBlock();
    Block &calleeEntry = calleeRegion->front();

    // Call edge: callerBlock → callee entry block.
    crossEdges[callerBlock].push_back(&calleeEntry);

    // Return edges: callee exit blocks → callerBlock and its CFG successors.
    for (Block &b : *calleeRegion) {
      if (b.hasNoSuccessors() || b.getNumSuccessors() == 0) {
        crossEdges[&b].push_back(callerBlock);
        for (Block *succ : callerBlock->getSuccessors())
          crossEdges[&b].push_back(succ);
      }
    }
  });

  // Collect all blocks into a dense index (needed for BFS traversal).
  llvm::SmallVector<Block *> allBlocks;
  module.walk([&](Operation *op) {
    auto callable = dyn_cast<CallableOpInterface>(op);
    if (!callable)
      return;
    Region *body = callable.getCallableRegion();
    if (!body)
      return;
    for (Block &b : *body) {
      blockIndex[&b] = allBlocks.size();
      allBlocks.push_back(&b);
    }
  });

  unsigned numBlocks = allBlocks.size();
  if (numBlocks == 0)
    return;

  // Only blocks containing annotated memory events need BFS as starting points.
  llvm::DenseSet<Block *> eventBlocks;
  module.walk([&](Operation *op) {
    if (op->hasAttr(kEventIdAttr))
      eventBlocks.insert(op->getBlock());
  });

  LLVM_DEBUG(llvm::dbgs() << "[BlockReachability] numBlocks=" << numBlocks
                          << " eventBlocks=" << eventBlocks.size()
                          << " crossEdges=" << crossEdges.size() << "\n");

  // Sparse matrix: only event blocks get a reachability row.
  // eventRowIndex maps block* → row in reachMatrix.
  llvm::SmallVector<Block *> eventBlockList(eventBlocks.begin(),
                                            eventBlocks.end());
  for (unsigned i = 0; i < eventBlockList.size(); ++i)
    eventRowIndex[eventBlockList[i]] = i;

  unsigned numRows = eventBlockList.size();
  reachMatrix.assign(numRows, llvm::BitVector(numBlocks, false));

  // Bounded BFS from each event block: CFG edges don't count toward depth,
  // call/return edges increment depth.  Stop at maxFunctionDepth.
  constexpr unsigned maxFunctionDepth = 2;
  for (unsigned row = 0; row < numRows; ++row) {
    auto &reach = reachMatrix[row];
    unsigned startIdx = blockIndex[eventBlockList[row]];
    reach.set(startIdx);
    // Worklist: (blockIndex, functionBoundaryDepth).
    llvm::SmallVector<std::pair<unsigned, unsigned>> worklist;
    llvm::DenseMap<unsigned, unsigned> bestDepth;
    worklist.push_back({startIdx, 0});
    bestDepth[startIdx] = 0;
    while (!worklist.empty()) {
      auto [cur, depth] = worklist.pop_back_val();
      Block *curBlock = allBlocks[cur];
      // CFG successors — same depth (intra-region).
      for (Block *succ : curBlock->getSuccessors()) {
        auto it = blockIndex.find(succ);
        if (it == blockIndex.end())
          continue;
        unsigned si = it->second;
        auto [dit, inserted] = bestDepth.try_emplace(si, depth);
        if (!inserted && dit->second <= depth)
          continue;
        dit->second = depth;
        reach.set(si);
        worklist.push_back({si, depth});
      }
      // Call/return edges — depth + 1.
      if (depth < maxFunctionDepth) {
        auto ceIt = crossEdges.find(curBlock);
        if (ceIt == crossEdges.end())
          continue;
        for (Block *target : ceIt->second) {
          auto it = blockIndex.find(target);
          if (it == blockIndex.end())
            continue;
          unsigned ti = it->second;
          unsigned newDepth = depth + 1;
          auto [dit, inserted] = bestDepth.try_emplace(ti, newDepth);
          if (!inserted && dit->second <= newDepth)
            continue;
          dit->second = newDepth;
          reach.set(ti);
          worklist.push_back({ti, newDepth});
        }
      }
    }
  }
}

bool BlockReachabilityAnalysis::canReach(Block *from, Block *to) const {
  auto rowIt = eventRowIndex.find(from);
  auto colIt = blockIndex.find(to);
  if (rowIt == eventRowIndex.end() || colIt == blockIndex.end())
    return false;
  return reachMatrix[rowIt->second].test(colIt->second);
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
  Operation *f = idToOp.lookup(ids[fIdx]);
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    if (aIdx == fIdx || matrix[aIdx * n + fIdx] != EventOrder::Ordered)
      continue;
    Operation *a = idToOp.lookup(ids[aIdx]);
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (bIdx == fIdx || bIdx == aIdx)
        continue;
      if (matrix[aIdx * n + bIdx] != EventOrder::Unordered)
        continue;
      if (matrix[fIdx * n + bIdx] != EventOrder::Ordered)
        continue;
      Operation *b = idToOp.lookup(ids[bIdx]);
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
    result.idToOp[id] = op;
  });

  result.n = result.ids.size();
  unsigned n = result.n;
  llvm::errs() << "[getOrderMatrix] n=" << n << "\n";
  result.matrix.assign(n * n, EventOrder::Unreachable);
  for (unsigned i = 0; i < n; ++i)
    result.idToIdx[result.ids[i]] = i;

  // Pairwise pass; cross-region pairs also check cross-function deps.
  for (unsigned aIdx = 0; aIdx < n; ++aIdx) {
    Operation *a = result.idToOp.lookup(result.ids[aIdx]);
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (aIdx == bIdx)
        continue;
      Operation *b = result.idToOp.lookup(result.ids[bIdx]);
      if (!reach.opCanReach(a, b, dominance)) {
        result.setOrder(aIdx, bIdx, EventOrder::Unreachable);
        continue;
      }
      EventOrder order = result.queryOrder(a, b, iface, aliasAnalysis, dominance);
      if (iface && order == EventOrder::Unordered &&
          a->getBlock()->getParent() != b->getBlock()->getParent()) {
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
    Operation *op = result.idToOp.lookup(result.ids[i]);
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
    Operation *a = result.idToOp.lookup(result.ids[aIdx]);
    for (unsigned bIdx = 0; bIdx < n; ++bIdx) {
      if (bIdx == aIdx || result.matrix[aIdx * n + bIdx] != EventOrder::Unordered)
        continue;
      if (fencesBefore[bIdx].none())
        continue;
      Operation *b = result.idToOp.lookup(result.ids[bIdx]);
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
          Operation *f = result.idToOp.lookup(result.ids[fenceIdxs[fi]]);
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
