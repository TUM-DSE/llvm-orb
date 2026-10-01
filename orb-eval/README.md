# Orb evaluation

Tests and measurements for the Orb pipeline. None of this is part of the LLVM
build or of `lit`: the suites need external tools (herd7, autotools, a Nix
toolchain) and their own runners. They live here rather than under
`clang/test` or `mlir/test` for that reason -- `lit` would, for instance, treat
every `.cpp` file in `clang/test` as a test and fail on the FileCheck inputs,
which have no `RUN:` line.

| Directory | What it checks | Needs |
|---|---|---|
| [`filecheck/`](filecheck/README.md) | the pipeline emits a legal target program for code with control flow and calls, accepting every legal synthesis result | the Orb build |
| [`litmus/`](litmus/README.md) | compiled programs are robust: ARMv8 allows no outcome that RC11 forbids, checked with herd7 | the Orb build, herd7 |
| [`bench/`](bench/README.md) | synchronization emitted, runtime and compile time on userspace-rcu | the Orb build, Nix, an ARM machine for runtime |

All three use the Orb build in `$ORB_BUILD` (default: `build/` at the
repository root). Generated files stay inside the respective directories and
are ignored by git (see `.gitignore`).

```sh
filecheck/run_pipeline_filecheck_tests.sh
litmus/generate_all.sh && litmus/run_litmus_tests.sh && litmus/negative_control.sh
bench/run_all.sh                      # see bench/ELIZA.md for the ARM server
```
