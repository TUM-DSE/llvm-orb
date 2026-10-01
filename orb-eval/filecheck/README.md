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

### Shapes covered

| File | Source shape | Requirement exercised |
|---|---|---|
| `seq_store` | relaxed store, release store | `po;[W & REL]` |
| `seq_load` | acquire load, relaxed store | `[R & ACQ];po` |
| `call` | store, call with an atomic inside, release store | interprocedural reachability |
| `if_else` | relaxed load selecting between two release stores | one barrier covering both arms |
| `while_loop` | load and release store inside a loop | loop-depth cost scaling |
| `nested` | conditional release store inside a loop | loop depth plus a branch |
| `sc_pair` | seq_cst store, seq_cst load | `[W & SC];po;[R & SC]`, the STLR→LDAR pairing |

### Keeping the pipeline in sync

`run_pipeline_filecheck_tests.sh` hard-codes the pass sequence so that it
mirrors `populateCIRPreLoweringPasses()` in `clang/lib/CIR/Lowering/CIRPasses.cpp`
followed by the front half of `populateOrbPasses()` in
`clang/lib/CIR/Lowering/DirectToLLVM/LowerToLLVM.cpp`. If either changes, update
the `PRE` / `ORB_TAIL` / `NAIVE_TAIL` variables in the runner.
