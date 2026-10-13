# Orb pipeline FileCheck suite

    python3 generate_pipeline_filecheck_tests.py   # regenerate test_orb_pipeline_*.cpp
    ./run_pipeline_filecheck_tests.sh

Uses `clang++`, `cir-opt` and `FileCheck` from `$ORB_BUILD/bin` (default:
`build/` at the repository root). The runner writes the intermediate IR to
`mlir/`, which git ignores.

(An older per-operation mapping suite, which also covered read-modify-write
operations, is abandoned: it predates the split of the boundary conversion into
a relaxing and a naive pass and no longer matches the pipeline.)

Checks that the **full** pipeline — including `--order-analysis` and
`--fence-synthesis` — emits a *legal* target program for sources containing
function calls, if/else and loops.

The expectations cannot be exact here. Once synthesis is in the loop, an
ordering requirement between two accesses can be satisfied by promoting the
first access, promoting the second, or inserting a barrier, and the choice
depends on the cost model and on loop depth. Pinning one sequence would test the
current cost model rather than the correctness of the lowering. So each test
carries:

| Prefix | Meaning |
|---|---|
| `CHECK` | invariants that hold under **every** legal solution — no `cpp_atomic` op survives, and the expected accesses exist with the right element type and alignment. Must always match. |
| `FENCE`, `PROMOTE`, … | one alternative ordering mechanism each. The runner accepts if **at least one** matches. The accepted set is listed in each file's `// ORB-SOLUTIONS:` header. |
| `NAIVE` | the `--cpp-atomic-to-arm-atomic-naive` output, which has no synthesis and so is deterministic. |

The runner sweeps `--fence-cost-base` (override with `ORB_TEST_COSTS="1 2 6 20"`),
so the suite also asserts that the cost model yields a legal program at every
setting — it may change its mind about the mechanism, but it may not drop the
ordering.

Inputs are C++ rather than hand-written CIR: the CIR for a loop is ~60 lines of
allocas and branches per function, impractical to maintain by hand and needing
regeneration on every ClangIR change. The runner compiles with
`clang++ -fclangir -emit-cir` and pipes into `cir-opt`, so the input stays
readable and always matches what the front end actually produces. The programs
use the `__atomic_*` builtins rather than `<atomic>` so the suite does not need a
C++ standard library for the target, and are `extern "C"` to keep the
`CHECK-LABEL` anchors unmangled.

### Two kinds of shape

Every test file carries an `// ORB-KIND:` header.

- **ordering**: nothing in the relaxed target program orders the pair the
  source requires; the synthesis must promote an access or insert a barrier.
  The runner accepts any listed solution (`FENCE`, `PROMOTE`, ...); if none
  matches, the run **fails**: the output may leave a requirement unordered.
- **dependency**: an ARMv8 address, data or control dependency from the load
  already orders the required pair. The only solution is `RELAXED`: every
  access relaxed and, via `RELAXED-NOT` lines, no barrier between the accesses
  or after the last one. If it does not match, the run is reported as a
  **missed dependency**: correct, but stronger than necessary.

Most dependency shapes have an ordering twin that differs only in the
dependency, so a difference in the results can be attributed to it.

### Shapes covered

| File | Kind | Source shape | Twin |
|---|---|---|---|
| `seq_store` | ordering | relaxed store, release store | |
| `seq_load` | ordering | acquire load, relaxed store of a constant | `seq_load_dep` |
| `load_store` | ordering | relaxed load, release store of a constant | `data_dep` |
| `if_else_indep` | ordering | relaxed load, branch on a parameter between two release stores | `if_else` |
| `loop` | ordering | load and release store of a constant inside a loop | `loop_dep` |
| `loop_back_edge` | ordering | relaxed store, then acquire load, inside a loop: the requirement exists only across iterations | |
| `call` | ordering | store, call with an atomic inside, release store | |
| `call_overwritten` | ordering | callee returns a relaxed load, caller overwrites it, branches between release stores | `call_dep` |
| `sc_pair` | ordering | seq_cst store, seq_cst load | |
| `data_dep` | dependency | relaxed load, release store of the loaded value | `load_store` |
| `addr_dep` | dependency | relaxed load selecting the address of a release store | |
| `seq_load_dep` | dependency | acquire load, relaxed store of the loaded value | `seq_load` |
| `if_else` | dependency | relaxed load selecting between two release stores | `if_else_indep` |
| `loop_dep` | dependency | load and release store of the loaded value inside a loop | `loop` |
| `nested` | dependency | conditional release store of the loaded value inside a loop | |
| `call_dep` | dependency | callee returns a relaxed load, caller branches on it | `call_overwritten` |

### Strict solutions

Every solution is exact (`strict()` in the generator): each access pattern
fixes its memory order, and `-NOT` lines forbid any barrier before, between or
after the listed operations, up to the next function label. An output with
redundant synchronization (a promoted load *and* a promoted store, an extra
barrier) or a barrier in a place that does not establish the ordering matches
no solution. `call` checks all three of its requirements (Z,X -> Y and the
may-alias pair X -> Z) as combinations of one mechanism each, in caller and
callee; a barrier before the call alone is not accepted.

### Results (2026-10-07, graham debug build)

48 passed, 8 failed, 24 missed dependencies (costs 1, 2, 6, 20 plus naive).

- `seq_store`, `seq_load`, `load_store`, `if_else_indep`, `loop`,
  `loop_back_edge` pass at every cost. For `loop_back_edge`, editing the output
  by hand confirmed that a barrier between store and load is rejected.
- `call_overwritten` fails at every cost: every access stays relaxed. The
  cross-function dependency search in `interprocedurallyReaches`
  (`ArmAtomicDialect.cpp`) follows a stored value to every reload of the same
  address the store dominates, without checking for an intervening store, so
  it sees a dependency the overwrite has destroyed. herd7: load buffering is
  never possible under RC11 but sometimes under ARMv8. Miscompilation.
- `sc_pair` fails at costs 1 and 2 (`STR; DMB ISH; LDR; STR`): nothing orders
  the load before the final store. The pair is marked ordered by an empty
  promotion (`FenceSynthesis.cpp`, "intermediate fence" check), because
  `fencePostDominatesSource`/`fenceDominatesTarget` compare basic blocks only,
  so the barrier before the load passes as lying after it. herd7 confirms the
  violation. Miscompilation.
- `call` fails at costs 1 and 2 for the first function in the file only
  (or a function compiled alone, whatever its type): the same
  mechanism lets the barrier after the call count as lying before the callee's
  store, so X -> Z is left unordered. That requirement only comes from the
  may-alias approximation (X and Z are distinct globals, but the pair is
  required in every function), so the output is correct in practice.
- Six of the seven dependency shapes are missed at every cost; only `call_dep`
  stays relaxed. At `-O0` every local lives in a stack slot, so the loaded value
  is stored and reloaded on its way to the dependent access. Within a
  function, `tryOrderDob` follows only SSA def-use chains
  (`transitivelyReaches`), which end at the first store; the stack-slot rule
  exists only on the cross-function path. Rewiring `data_dep` so the store uses
  the load's result directly makes both accesses stay relaxed.

### Keeping the pipeline in sync

`run_pipeline_filecheck_tests.sh` hard-codes the pass sequence so that it
mirrors `populateCIRPreLoweringPasses()` in `clang/lib/CIR/Lowering/CIRPasses.cpp`
followed by the front half of `populateOrbPasses()` in
`clang/lib/CIR/Lowering/DirectToLLVM/LowerToLLVM.cpp`. If either changes, update
the `PRE` / `ORB_TAIL` / `NAIVE_TAIL` variables in the runner.
