# Orb litmus suite

Differential robustness testing of the Orb pipeline against an independent
memory-model oracle.

The FileCheck suite in `../filecheck/` checks that the pipeline emits
legal-*looking* IR: the right ops, the right types, and some accepted ordering
mechanism. Its expectations are written by the same person who wrote the
mapping, so it cannot catch the synthesis dropping an ordering that was
genuinely needed. This suite can, because the oracle is a formal model checker
that was not told what Orb is supposed to do.

## The question it asks

For each test, is the compiled ARMv8 program **robust** — does ARMv8 permit any
behaviour that RC11 forbids?

```
  T.litmus  --herd7 (rc11.cat)-->  S   what RC11 allows
      |
      |  litmus_to_cpp.py + clang -O0/-O1/-O2 + generate_litmus.py
      v
  T'.litmus --herd7 (aarch64.cat)--> A  what ARMv8 allows

  robust  iff  A subset-of S
```

Both sides are asked the *same* question: the source test's `exists` clause is
carried through to the generated one, so the two verdicts are comparable.

`herd7` is a memory-model simulator. Given a litmus test and a `.cat` model it
exhaustively enumerates every execution that model permits. It runs nothing on
hardware; `litmus7`, which does, is not used here.

## Scope: loads, stores, fences and compare-exchange

Loads, stores and fences go through the Orb pipeline. Compare-exchange does
not: ClangIR lowers it straight to an LLVM `cmpxchg`, which becomes a `CAS`
instruction (`-mcpu=ampere1a` has LSE). The tests that use it are still in
scope, because whatever Orb emits around a compare-exchange must not let ARMv8
show behaviour RC11 forbids. `litmus_to_cpp.py` rejects a test that calls any
other atomic, and `litmus_prelude.h` defines no other macro, so a test that
slipped past the filter would fail to compile rather than be compiled with a
guess at its meaning.

## Running it

```sh
export PATH=/scratch/$USER/.local/bin:$PATH   # herd7, or set HERD7=/path/to/herd7
./generate_all.sh          # parse, compile at -O0, -O1 and -O2, lift the asm
./run_litmus_tests.sh      # the A subset-of S comparison
./negative_control.sh      # check the suite is able to fail
```

Both runners start every herd7 run at once (`ORB_LITMUS_JOBS`, default
`nproc`) and give each one `ORB_LITMUS_HERD_TIMEOUT` seconds (default 900).
`ORB_LITMUS_COMPILERS` and `ORB_LITMUS_OPTS` select the configurations.

## Files

| | |
|---|---|
| `tests/*.litmus` | classic ordering shapes (MP, SB, WRC, ISA2, 2+2W, LB, CoRR), see `tests/README.md` |
| `catalogue-duplicates.txt` | catalogue tests skipped as duplicates of another test |
| `litmus_prelude.h` | load/store/fence/compare-exchange atomics, as `__atomic_*` builtins |
| `litmus_to_cpp.py` | `.litmus` -> compilable `.cpp` + `.json` metadata |
| `generate_litmus.py` | compile for AArch64, lift each thread into a litmus test |
| `run_litmus_tests.sh` | the comparison; one table per configuration (compiler x `-O` level) |
| `negative_control.sh` | weakens the emitted ordering, checks verdicts move |
| `generate_all.sh` | regenerates `src/` and `out/` from `tests/` and the catalogue |
| `slow-tests.txt` | tests herd7 does not finish in time, skipped unless `ORB_LITMUS_SLOW=1` |

`src/` and `out/` are generated; delete them freely.

## Why the `.litmus` files have to be parsed

A litmus test is deliberately not C:

```
C a1                                    <- not a declaration
{ [x] = 0; [y] = 0; }                   <- initial state, not a statement
P0 (atomic_int* x, atomic_int* y) {     <- no return type
  int r0 = atomic_load_explicit(y, memory_order_relaxed);
}
exists(x=1 /\ y=1)                      <- /\ is not a C operator
```

so `litmus_to_cpp.py` parses it and synthesises a translation unit. Thread
bodies are copied *verbatim*; only the wrapper is generated. Each location
becomes a global `lt_x`, and inside each thread the parameter name is a macro
for that global's address, cast to the parameter's type
(`#define x ((atomic_int*)&lt_x)`), so no statement has to be rewritten. A
macro rather than a pointer variable: a local pointer would sit in a stack slot
at `-O0` and be reloaded before every access, a global pointer would add a load
of a shared location to every access at every level, and neither is in the
litmus test.
Deriving the C++ from the same file that produced the RC11 answer keeps the
compiled program and its reference answer from drifting apart.

## From assembly to a litmus test

herd7 knows no symbols and no stack: its memory is a set of named locations,
and a register is given the *address* of one in the initial state
(`0:X1=x;`). `generate_litmus.py` bridges the difference without analysing
the code:

- **Global addresses.** The compiler forms `lt_x`'s address with `adrp` and an
  `add ...:lo12:` (or folds the `:lo12:` into the access). Each location gets a
  register bound to it, and these instructions become copies of that register
  (`mov x9,x1`; `[x9, :lo12:...lt_x]` becomes `[x1]`). Everything else stays as
  compiled; where the address goes from there, herd7 follows itself in every
  execution, so the lifter never has to work out which register holds which
  address.
- **Stack slots.** At `-O0` every local lives in a stack slot, and the register
  allocator spills to the stack as well. Each slot becomes a location of its
  own that only its thread uses (`str w8, [sp, #12]` in P1 becomes
  `str w8, [x2]` with `1:X2=P1_sp12;`), so herd7 sees the memory accesses the
  hardware performs, including dependencies carried through a slot. The frame
  set-up (`sub sp`/`add sp`) is dropped. A slot accessed with 8 bytes is
  declared `int64_t`, since herd7 rejects mixed access sizes otherwise.
- **herd7's syntax.** Immediates become decimal (`#0x1` to `#1`), `ret` becomes
  a branch to a label at the end of the thread, and labels lose their dot.

Bound registers are taken from those the thread never mentions, so compiled
code cannot overwrite them. Anything unrecognised -- another use of `sp`, an
address register nothing has written, a leftover symbol -- stops the lifting
with an error: herd7 reads an unbound register as address 0 and would
silently answer `Never`.

**herd7 runs the ARMv8 side with `-optace true`.** It then discards, while
generating candidate executions, those that break coherence on one location,
for example a read of a stack slot that takes its value from a later store of
the same thread. `aarch64.cat` forbids those executions anyway, so verdicts are
unchanged (identical to default herd7 on all 508 generated tests, 2026-10-12),
and the heaviest `-O0` tests run in 39 s instead of 67 s.

**Slow tests are skipped by default.** `slow-tests.txt` lists the tests herd7
does not finish within 15 minutes: `c_pq` and `c_pq_reorder` at `-O0`, whose
lifted threads have 45 memory accesses (12 at `-O1`). They show up as SKIPPED;
`ORB_LITMUS_SLOW=1` runs them.

**`clrex` is dropped** when lifting. It clears the local exclusive monitor on a
compare-exchange failure path. herd7's AArch64 parser has no such instruction,
because the model pairs `ldxr` with `stxr` through the `rmw` relation rather
than tracking monitor state. `clrex` performs no memory access and orders
nothing, so dropping it changes no event and no edge in this model — but a test
whose outcome depended on monitor state could not be expressed here.

## Corpus

The c11popl15 catalogue of herdtools7 (Vafeiadis et al., POPL 2015): 47 files,
of which 3 are the same program as another test up to the names of registers
and locations (`catalogue-duplicates.txt`: `a6` = `a5`, `b` = `lb`,
`strengthen2` = `roachmotel2`). As in the Orb paper, the duplicates are
skipped, leaving 44. Of those, 2 (`fig6`, `fig6_translated`) have a condition
over six registers of one thread, which the translation does not support, and
11 have no `exists` clause and nothing to compare (`a2`, `a5`, `a7`, `a8`, `a9`
and the `_reorder` variants of these and of `a6`). That leaves **31 catalogue
tests**, 7 of which use compare-exchange (`a3v2`, `c_p`, `c_q`, `c_pq` and the
`_reorder` variants of the last three).

`tests/` adds 12 ordering shapes (message passing, store buffering, load
buffering, WRC, ISA2, 2+2W, CoRR), for **43 tests** in all. Unlike most
catalogue tests, they all exercise the synthesized synchronization.

## Configurations

`orb-c1` and `orb-c20` are the synthesis pipeline with fence cost 1 and 20.
Cost 1 makes the synthesis prefer barriers, cost 20 promoted accesses, so both
kinds of mechanism are checked. `naive-orb` is the naive pipeline, `clangir`
ClangIR's own lowering without Orb. Any other set can be selected with
`ORB_LITMUS_COMPILERS`, e.g. `orb-c2` for the default cost.

Each compiler runs at `-O0`, `-O1` and `-O2` (`ORB_LITMUS_OPTS`), so a
configuration is named like `orb-c1-O0`. At `-O0` the generated test is exactly
what the Orb pipeline emitted; at `-O1` and `-O2` LLVM optimises after Orb has
made its decisions.

All configurations compile with `-mcpu=ampere1a` (override with
`ORB_LITMUS_CPU_FLAGS`), the same CPU as the benchmarks. Without the RCpc
extension it enables, acquirePC loads would be compiled to `LDAR` and `LDAPR`
-- which, unlike `LDAR`, is not ordered after a preceding `STLR` -- would never
be tested.

## Results

43 tests x 4 compilers x 3 levels (2026-10-12), no failures and no errors;
the full run takes about a minute on graham. At `-O0` the two slow tests are
skipped, so 41 are checked there.

| Compiler | `-O0` pass / over / xfail | `-O1` | `-O2` | Fail |
|---|---|---|---|---|
| `orb-c1`    | 38 / 2 / 1 | 40 / 2 / 1 | 40 / 2 / 1 | 0 |
| `orb-c20`   | 38 / 2 / 1 | 40 / 2 / 1 | 40 / 2 / 1 | 0 |
| `naive-orb` | 39 / 1 / 1 | 41 / 1 / 1 | 41 / 1 / 1 | 0 |
| `clangir`   | 39 / 1 / 1 | 41 / 1 / 1 | 41 / 1 / 1 | 0 |

Every configuration is stronger than RC11 requires on `2+2W_rel`: RC11 allows
two release stores per thread to end in the "both first writes last" state,
ARMv8 does not once the stores are `STLR`. The synthesis configurations are
also stronger on `2+2W_relaxed` (see the may-alias note below).

**LB with all-relaxed accesses diverges, as expected.** `lb` is `Never` under
RC11 and `Sometimes` on ARMv8. RC11 forbids load buffering by requiring
`po | rf` to be acyclic -- a global argument about the whole execution -- and no
per-access mapping can enforce that locally. Listed as XFAIL with that reason
rather than silently excluded.

## What the corpus does and does not cover

`negative_control.sh` takes every generated test of the synthesis
configurations whose condition ARMv8 never allows, and removes one kind of
ordering mechanism at a time -- barriers, `LDAR`, `LDAPR` or `STLR` -- before
asking herd7 again. A verdict that moves shows that the green result is held by
the ordering the synthesis emitted.

69 of 173 weakenings move a verdict (2026-10-12, all three levels): every
shape from `tests/` whose outcome RC11 forbids, and in the catalogue only `a4`
(store buffering with SC accesses). The same tests move at every level (9
weakenings per level with cost 1, 14 with cost 20); the other 104 change
nothing. The c11popl15 tests illustrate which *source-level* transformations
are valid; their outcomes are mostly ruled out by control dependencies or by the
absence of out-of-thin-air values, which hold on ARMv8 whatever the mapping
emits. `c` is the clearest case -- each thread reaches its store only if the
other thread already stored, so neither ever does, barrier or no barrier. Those
tests still check that the compiler introduces no new behaviour; they just do
not exercise fence synthesis, so the reported corpus tests the synthesis in one
test only, which is why `tests/` exists. `CoRR` never moves: read-read
coherence holds on ARMv8 without any ordering instruction, so its compiled code
contains none to weaken. The compare-exchange tests are inert as well.

The may-alias over-synchronisation that the shape `2+2W_relaxed` shows
(both synthesis configurations order two relaxed stores to distinct globals)
does not depend on the litmus translation: a plain C function with two relaxed
stores to two globals gets a `dmb ish` (cost 1) or an `stlr` (cost 20) at `-O0`
and `-O1`, while `naive-orb` emits two plain stores.

## Limitations

- At `-O1` and `-O2` herd7 checks the assembly after LLVM's optimisations, so
  a failure there implicates the whole pipeline. Orb interprets LLVM IR under the
  *target* model rather than RC11, so those passes are not guaranteed sound
  here; on a failure, establish which stage caused it before blaming Orb.
- `fig6` and `fig6_translated` are skipped: their condition names six registers
  in one thread, and a thread returns a single `int`. Every other conditioned
  test names at most one register per thread.
- 11 catalogue tests carry no `exists` clause (`a2`, `a5`, `a7`, `a8`, `a9` and
  the `_reorder` variants of these and of `a6`). They illustrate a reordering
  rather than assert an outcome, so there is no condition to compare and they
  are skipped.
- The tests contain neither loops nor function calls, so the suite cannot find
  errors that need them, such as the lost release ordering that
  `test_urcu_assign` exposed in the benchmarks (see `../bench`).
- herd7 proves things about the model, not about silicon. Running these on the
  ARM server with `litmus7` is the natural next step.

## Environment

herd7 is not in nixpkgs; build it from source. The scripts look for the
sources in `$HERDTOOLS_DIR` (default `/scratch/$USER/herdtools7`, for the
litmus catalogue) and for the binary in `$HERD7`, on `PATH`, or in
`/scratch/$USER/.local/bin`:

```sh
git clone https://github.com/herd/herdtools7.git /scratch/$USER/herdtools7
cd /scratch/$USER/herdtools7
nix-shell -p ocaml dune_3 ocamlPackages.menhir ocamlPackages.menhirLib \
             ocamlPackages.menhirSdk ocamlPackages.zarith ocamlPackages.logs \
             ocamlPackages.findlib gnumake \
  --run "make all PREFIX=/scratch/$USER/.local && make install PREFIX=/scratch/$USER/.local"
```

The compiler is `$ORB_BUILD/bin/clang++` (default: `build/` at the repository
root). The translation units need no C library, so no Nix cc-wrapper is
involved.

`nix-shell -p`, not `nix shell`: the former runs the setup hooks that put the
OCaml libraries on `OCAMLPATH`, without which dune cannot find `zarith`,
`logs` or `menhirLib`. The models used are herd7's own `rc11.cat` (Lahav et
al., PLDI 2017 — the model Orb targets) and `aarch64.cat`.
