# Running the benchmarks on eliza

The harness was developed and validated on graham (x86) by cross-compiling for
AArch64 and running the programs under QEMU. The real measurements run on
eliza. This file lists what to bring over, what is different there, and a task
list that can be given to a Claude Code session on eliza as it is.

## What has to get to eliza

1. **The Orb repository with the changes of this work.** They are uncommitted
   on graham:
   - `orb-eval/` (new: the FileCheck suite, the litmus suite, this harness)
   - `clang/lib/FrontendTool/ExecuteCompilerInvocation.cpp`,
     `clang/lib/CIR/Lowering/CIRPasses.cpp`,
     `clang/lib/CIR/Lowering/DirectToLLVM/LowerToLLVM.cpp` (MLIR pass timing)
   - `mlir/lib/Conversion/ArmAtomicToLLVM/ArmAtomicToLLVM.cpp` (`[OrbStats]`)
   - `mlir/lib/Conversion/ArmAtomicToLLVM/FenceSynthesis.cpp` (`remaining=`)

   Either commit them on a branch and push it (then `git fetch` it on eliza),
   or carry them over as a patch -- `/home` is shared between graham and eliza,
   so no copying between the machines is needed:

   ```sh
   # on graham, in /scratch/alex/llvm-orb
   git add -N orb-eval && git diff > ~/orb-eval.patch && git reset -q orb-eval
   # on eliza, in the clone
   git apply ~/orb-eval.patch
   ```

2. **Nothing else.** The benchmark source, the C library toolchain and autotools
   are fetched by the scripts (from GitHub and the Nix binary cache).

## What is different on eliza

| | graham (validation) | eliza (measurement) |
|---|---|---|
| Compiler build | Debug, assertions on | **Release**, assertions off -- compile times of a Debug build are meaningless |
| Target | cross (`BENCH_CROSS=aarch64`) | native, leave `BENCH_CROSS` unset |
| Running | `BENCH_RUNNER=qemu-aarch64` | directly, leave `BENCH_RUNNER` unset |
| CPU flags | `-mcpu=ampere1a` (assumed) | set `BENCH_CPU_FLAGS` to the actual core, after checking it |
| Compile jobs | many (timing irrelevant) | `BENCH_JOBS=1` (the default) |
| Where | `/scratch` (local disk) | `/scratch` on eliza (local disk); only the results go to `~` |

Two things went wrong on eliza before and may again: `git clone` of llvm-orb
failed with `BUG: refs/files-backend.c:3188` (a shallow clone of a single
branch, or `git init` + `git fetch`, may avoid it), and SSH from eliza to graham
is not set up -- which does not matter, because `/home` is shared.

## Task list for a Claude Code session on eliza

> You are on eliza, the ARM server. The goal is to measure the Orb compiler
> with the harness in `orb-eval/bench` (read its `README.md` first). Do not
> commit anything and do not change compiler sources. Stop and report if a step
> fails in a way these notes do not cover.
>
> 1. **Machine.** Record `uname -a`, `lscpu`, `nproc`, `free -g`, and
>    `grep -m1 Features /proc/cpuinfo`. Check that the features include `lrcpc`
>    (`LDAPR`) and `atomics` (LSE). Check `uptime` and `who`: the runtime
>    measurement needs an otherwise idle machine; report other load.
>
> 2. **Nix.** `nix --version`. If `nix build github:...` complains about
>    experimental features, add `--extra-experimental-features 'nix-command flakes'`
>    (or export `NIX_CONFIG='experimental-features = nix-command flakes'`).
>
> 3. **Repository.** Clone `git@github.com:TUM-DSE/llvm-orb.git` (or the HTTPS
>    URL) into `/scratch/$USER/llvm-orb` -- local disk, not `/home`. Check out
>    the branch with the harness, or `main` and `git apply ~/orb-eval.patch`.
>    Confirm `orb-eval/bench/run_all.sh` exists and `git status` shows the five
>    modified compiler files (or none, if they are committed on the branch).
>
> 4. **Compiler, Release build.** In `/scratch/$USER/llvm-orb`:
>
>    ```sh
>    R=github:nixos/nixpkgs/$(python3 -c 'import json;print(json.load(open("flake.lock"))["nodes"]["nixpkgs"]["locked"]["rev"])')
>    mkdir -p build/.nix-gcroots
>    nix build "$R#llvmPackages.stdenv.cc" --out-link build/.nix-gcroots/clang-wrapper
>    nix shell "$R#cmake" "$R#ninja" "$R#python3" "$R#llvmPackages.stdenv.cc" -c bash -c '
>      cmake -S llvm -B build -G Ninja \
>        -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=OFF \
>        -DLLVM_ENABLE_PROJECTS="mlir;clang" -DLLVM_TARGETS_TO_BUILD=AArch64 \
>        -DCLANG_ENABLE_CIR=ON -DLLVM_ENABLE_ZLIB=OFF -DLLVM_ENABLE_LIBXML2=OFF \
>        -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF \
>        -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ &&
>      ninja -C build clang cir-opt FileCheck llvm-objdump'
>    ```
>
>    The GC root keeps the compiler that built LLVM alive; without it a later
>    `nix-collect-garbage` breaks every incremental rebuild. Check:
>    `build/bin/clang --version` names the llvm-orb commit, and
>    `build/bin/llvm-objdump --version` lists `aarch64`.
>
> 5. **Correctness first.** Run `orb-eval/filecheck/run_pipeline_filecheck_tests.sh`.
>    It must end with `All 40 checks passed.` (The litmus suite needs herd7 and
>    is run on graham; it is not needed here.)
>
> 6. **CPU flags.** Choose `BENCH_CPU_FLAGS`: for an Ampere 1A,
>    `-mcpu=ampere1a` (check `build/bin/clang --print-supported-cpus`). Verify
>    that it enables RCpc: compile
>    `int x; int f(void){return __atomic_load_n(&x,__ATOMIC_ACQUIRE);}` with
>    `build/bin/clang $BENCH_CPU_FLAGS -O1 -S -o - -x c -` and check the output
>    contains `ldapr`. Export the value for the following steps.
>
> 7. **Toolchain.** `cd orb-eval/bench && ./make-toolchain.sh`. It must print
>    the Orb clang version, the Orb resource directory (`.../build/lib/clang/23`)
>    and `ok 1`.
>
> 8. **Builds, counts, compile times.**
>    `./run_all.sh build count summarize`. This builds userspace-rcu five times
>    (clang, clangir, naive-orb, orb-c1, orb-c20) with one compilation at a time;
>    the Orb configurations are slow on the largest files (`urcu.c` has over
>    100,000 required pairs). Record the wall time of each configuration. Then
>    check in `work/results/summary.md`:
>    - `clang`, `clangir` and `naive-orb` have (nearly) the same numbers of
>      LDAR, LDAPR, STLR and DMB -- the naive pipeline reproduces the fixed
>      mapping. Report any difference.
>    - LDAPR is not zero (otherwise step 6 did not take effect).
>    - In the ordering table, `remaining` is 0 for every configuration. Report
>      the modules where it is not (`work/results/synthesis.csv`): a remaining
>      required pair means the synthesis left an ordering unestablished.
>    - Every translation unit compiled (`status` 0 in `compile_times.csv`).
>
>    Reference from the validation on graham (cross-compiled, `-O0
>    -mcpu=ampere1a`, same commit): `clang`, `clangir` and `naive-orb` each had
>    531 LDAR, 531 LDAPR, 696 STLR, 303 DMB and 1390 LSE read-modify-writes;
>    `orb-c1` 0 / 81 / 8 LDAR/LDAPR/STLR and 472 DMB; `orb-c20` 187 / 569 / 338
>    and 352 DMB. Instruction counts do not depend on the host, so the same
>    flags should reproduce them exactly; a difference means different flags or
>    a different compiler. `orb-c1` left one required pair unordered
>    (`remaining=1`) in each of `tests/regression/rcutorture_urcu_bp-urcutorture.o`,
>    `rcutorture_urcu_qsbr-urcutorture.o` and `rcutorture_urcu_qsbr_cxx-urcutorture_cxx.o`
>    -- a known open issue; report whether it recurs and whether any other
>    module shows it.
>
> 9. **Runtime, smoke test.**
>    `BENCH_REPS=1 BENCH_DURATION=1 BENCH_PROGRAMS=test_urcu ./run_bench.sh`
>    must produce five SUMMARY lines with non-zero reads and writes in
>    `work/results/runtime_raw.tsv`.
>
> 10. **Runtime, measurement.** On an idle machine: `./run_all.sh bench summarize`
>     (defaults: 22 programs x 5 configurations x 5 repetitions x 5 s, about
>     an hour). Report the geometric-mean table and any program whose relative
>     standard deviation exceeds 5%.
>
> 11. **Hand-over.** Copy the results to the shared home directory:
>     `cp -r work/results ~/orb-bench-results-$(date +%F)` and add
>     `machine.txt` (step 1), the llvm-orb commit and `git diff --stat`, and the
>     exact environment variables used. Summarize the findings.

## Settings worth knowing

All in `config.sh`, all overridable from the environment:
`BENCH_COSTS` (default `1 20`), `BENCH_OPT` (`-O0`), `BENCH_CPU_FLAGS`,
`BENCH_JOBS` (`1`), `BENCH_READERS`/`BENCH_WRITERS` (`32`/`32`),
`BENCH_DURATION` (`5` s), `BENCH_REPS` (`5`), `BENCH_AFFINITY` (`1`: pin to
CPUs 0..63), `BENCH_PROGRAMS`, `URCU_REPO`/`URCU_COMMIT`, `BENCH_WORK`.
