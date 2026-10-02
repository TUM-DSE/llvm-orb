# Orb benchmark harness

Measures, for the userspace-rcu benchmarks compiled with each compiler
configuration:

- **relaxations** -- how much synchronization is emitted: acquire loads,
  store-releases and barriers in the object files, and the memory events of the
  target program by memory order as reported by the compiler;
- **runtime** -- read and write throughput of the benchmark programs;
- **compile time** -- per translation unit and per pipeline stage.

Run it on the ARM machine being measured; see [ELIZA.md](ELIZA.md) for the
step-by-step setup there.

```sh
./run_all.sh                          # toolchain, build, count, bench, summarize
./run_all.sh build count summarize    # everything except the runtime runs
```

Everything generated goes to `work/` (ignored by git); the results end up in
`work/results/`, with `summary.md` as the overview.

## Configurations

| Name | Flags |
|---|---|
| `clangir` | `-fclangir`: ClangIR's own lowering, the baseline everything is normalized to |
| `naive-orb` | `-fclangir -Xclang -naive-orb`: the Orb pipeline with the fixed mapping |
| `orb-c1` | `-fclangir -Xclang -orb -Xclang -orb-fence-cost-base=1`: barriers are cheap |
| `orb-c20` | `... -orb-fence-cost-base=20`: barriers are expensive, promotions preferred |
| `<name>-O2` | the same with `-O2` (`BENCH_OPTS`, default `-O0 -O2`) |
| `clang` | stock Clang, not built by default (add it to `BENCH_CONFIGS`) |

The baseline is `clangir` at -O0. Orb is ClangIR plus Orb's passes, so
`clangir` isolates what Orb changes. Stock Clang emits the same synchronization
as `clangir`, but its -O0 code runs much faster than ClangIR's (1.65x the read
throughput on eliza, 2026-10-01), which a `clang` baseline would charge to Orb.

Synchronization is compared at -O0 only. At -O2, LLVM inlines, deletes and
merges code after Orb has made its decisions, so the object files no longer
show those decisions; the -O2 builds are measured for compile time and runtime.
They are performance numbers only: LLVM's optimizations run after Orb and are
not guaranteed to preserve the ordering Orb established.

The Orb flags are `-cc1` flags; the driver does not forward them without
`-Xclang`. All configurations are built with `$BENCH_OPT` (`-O0`), which a
suffixed configuration overrides, and `$BENCH_CPU_FLAGS`, which has to select a core with RCpc
(`LDAPR`) -- otherwise acquire loads become `LDAR` everywhere and the naive
mapping's distinction disappears. The costs are set by `BENCH_COSTS` (default
`1 20`).

userspace-rcu is Sebastian Reimers' fork at the commit used for the Orb paper,
configured with `--enable-compiler-atomic-builtins`: only then are its atomics
and barriers `__atomic_*` loads, stores and fences that Orb can analyse.
`configure` runs without the configuration's flags, so every configuration is
configured identically and differs only in how the code is compiled.

## Files

| File | Role |
|---|---|
| `config.sh` | all settings; every one can be overridden from the environment |
| `make-toolchain.sh` | `work/toolchain/bin/{cc,c++}`: the Orb clang wrapped in a pinned Nix cc-wrapper, so that it finds the C library |
| `orb-timed-cc` | the `CC` of the builds: adds the configuration's flags, times every compilation, keeps its compiler output |
| `build.sh` | one out-of-tree userspace-rcu build per configuration |
| `count.py` | per-object CSVs: instruction counts, compiler statistics, compile and pass times |
| `run_bench.sh` | runs the benchmark programs, records their `SUMMARY` lines |
| `summarize.py` | the tables and `summary.md` |
| `run_all.sh` | runs the steps in order |

## What is measured, and where it comes from

**Synchronizing instructions** (`primitives.csv`, `relaxations.csv`):
`llvm-objdump` of every object file that was compiled, counting `LDAR*`,
`LDAPR*`/`LDAPUR*`, `STLR*`/`STLUR*`, `DMB` by kind, and read-modify-write
instructions (LL/SC and LSE) separately. Counted per object, never on the linked
programs, which contain the C library. The same counting applies to every
configuration, including stock Clang. `relaxed_accesses_vs_naive` is the number
of strong accesses the synthesis avoided compared with the naive mapping;
`barrier_change_vs_naive` the number of barriers it added (positive) or removed.
Read-modify-writes bypass the Orb dialects and are identical across the Orb
configurations.

**Memory events after the boundary** (`orbstats.csv`, `irstats.csv`): the
`[OrbStats]` line that `arm-atomic-to-llvm` prints for every module in the Orb
configurations -- loads, stores and fences by `arm_atomic` memory order, and
non-atomic accesses. Unlike the object files, this separates relaxed atomic
accesses from plain ones.

**Ordering** (`synthesis.csv`, `synthesis_summary.csv`): the synthesis summary
line (`done ordered=... overspecified=... promotions=... t=...ms`). The naive
pass prints the same line: after its conversion it builds the target ordering
matrix to report covered, over-specified and remaining pairs. That verification
is logging, not part of the mapping, but it dominates the naive pass's time.

**Compile time** (`compile_times.csv`, `pass_times.csv`, `compile.csv`): wall
time of each compilation, measured by `orb-timed-cc` with one compilation at a
time (`BENCH_JOBS=1`), and the per-pass times of `-mmlir --mlir-timing`, grouped
into pipeline stages. `outside-mlir` is the front end plus LLVM code generation.
For `naive-orb`, subtract `order-analysis` and the verification time to get the
cost of the mapping itself. Compile times are only meaningful with a Release
build of the compiler.

**Runtime** (`runtime_raw.tsv`, `runtime.csv`, `runtime_geomean.csv`): each
program runs with `BENCH_READERS` readers and `BENCH_WRITERS` writers (32 and
32, as in the Orb paper) for `BENCH_DURATION` seconds, `BENCH_REPS` times, with
threads pinned to CPUs 0..63. Throughput is `nr_reads`/`nr_writes` per second
(dequeues/enqueues for the queues and stacks); the table reports the median, its
relative standard deviation, and the median relative to `clangir`.

## Compiler instrumentation this relies on

- `[OrbStats]` line in `mlir/lib/Conversion/ArmAtomicToLLVM/ArmAtomicToLLVM.cpp`.
- `-mmlir --mlir-timing` support: `registerDefaultTimingManagerCLOptions()` in
  `clang/lib/FrontendTool/ExecuteCompilerInvocation.cpp` and
  `applyDefaultTimingPassManagerCLOptions()` for both CIR pass managers
  (`clang/lib/CIR/Lowering/CIRPasses.cpp`,
  `clang/lib/CIR/Lowering/DirectToLLVM/LowerToLLVM.cpp`).
- The synthesis and naive-pass summary lines, which already existed.

## Validating on an x86 machine

`BENCH_CROSS=aarch64` cross-compiles everything for AArch64 with a Nix cross
cc-wrapper, and `BENCH_RUNNER=qemu-aarch64` runs the programs under QEMU. This
only checks that the harness works; neither the runtimes under QEMU nor compile
times of a Debug compiler mean anything.
