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
      |  litmus_to_cpp.py + clang -O1 + generate_litmus.py
      v
  T'.litmus --herd7 (aarch64.cat)--> A  what ARMv8 allows

  robust  iff  A subset-of S
```

Both sides are asked the *same* question: the source test's `exists` clause is
carried through to the generated one, so the two verdicts are comparable.

`herd7` is a memory-model simulator. Given a litmus test and a `.cat` model it
exhaustively enumerates every execution that model permits. It runs nothing on
hardware; `litmus7`, which does, is not used here.

## Scope: loads, stores and fences

The suite tests the mapping of atomic loads, atomic stores and fences. Nothing
else. Read-modify-write operations belong to the RMWOps branch and are excluded
at two levels: `litmus_to_cpp.py` drops any test that calls something outside
`atomic_load{,_explicit}`, `atomic_store{,_explicit}` and
`atomic_thread_fence`, and `litmus_prelude.h` defines no other macro, so a test
that slipped past the filter would fail to compile rather than be measured as
though it said something about load/store/fence ordering.

That drops 9 catalogue tests, all using `compare_exchange_strong` (`a2`,
`a3v2`, `c_p`, `c_q`, `c_pq` and `_reorder` variants). It costs no coverage of
what the suite tests: all 12 ordering-dependent results in
`negative_control.sh` are unchanged by their removal, because every one of the
dropped tests was in the inert group -- forbidden for control-dependency
reasons rather than by any barrier.

## Running it

```sh
export PATH=/scratch/$USER/.local/bin:$PATH   # herd7, or set HERD7=/path/to/herd7
./generate_all.sh          # parse, compile at -O1, lift the asm
./run_litmus_tests.sh      # the A subset-of S comparison
./negative_control.sh      # check the suite is able to fail
```

## Files

| | |
|---|---|
| `tests/*.litmus` | hand-written ordering shapes (MP, SB, WRC, ISA2, 2+2W, LB, CoRR) |
| `catalogue-duplicates.txt` | catalogue tests skipped as duplicates of another test |
| `litmus_prelude.h` | load/store/fence atomics, as `__atomic_*` builtins |
| `litmus_to_cpp.py` | `.litmus` -> compilable `.cpp` + `.json` metadata |
| `generate_litmus.py` | compile for AArch64, lift each thread into a litmus test |
| `run_litmus_tests.sh` | the comparison; one table per compiler |
| `negative_control.sh` | weakens the emitted ordering, checks verdicts move |
| `generate_all.sh` | regenerates `src/` and `out/` from both corpora |

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
bodies are copied *verbatim*; only the wrapper is generated, with each parameter
re-declared as a local pointer to a global, so no statement has to be rewritten.
Deriving the C++ from the same file that produced the RC11 answer keeps the
compiled program and its reference answer from drifting apart.

## Two constraints worth knowing

**Everything is compiled at `-O1`.** A litmus thread has no stack frame. At
`-O0` every local is an alloca, so a thread body comes out full of `[sp,#N]`
references that mean nothing in a litmus test — 8 of them in a two-line thread.
At `-O1` the bodies are completely stack-free. This is independent of the
parsing above: parsing gets a compilable file, `-O1` decides what comes out.

**`clrex` is dropped** when lifting. It clears the local exclusive monitor on a
compare-exchange failure path. herd7's AArch64 parser has no such instruction,
because the model pairs `ldxr` with `stxr` through the `rmw` relation rather
than tracking monitor state. `clrex` performs no memory access and orders
nothing, so dropping it changes no event and no edge in this model — but a test
whose outcome depended on monitor state could not be expressed here.

## Corpus

- `tests/`: 12 hand-written ordering shapes.
- the c11popl15 catalogue: 47 files, of which 3 are the same program as another
  test up to the names of registers and locations (`catalogue-duplicates.txt`:
  `a6` = `a5`, `b` = `lb`, `strengthen2` = `roachmotel2`). As in the Orb paper,
  the duplicates are skipped, leaving 44. Of those, 9 use compare-exchange
  (out of scope) and 2 (`fig6`, `fig6_translated`) have a condition over six
  registers of one thread, which the translation does not support, so 33 are
  translated; 9 of them have no `exists` clause and nothing to compare.

That leaves 36 tests: 24 from the catalogue and the 12 hand-written ones.

## Configurations

`orb-c1` and `orb-c20` are the synthesis pipeline with fence cost 1 and 20.
Cost 1 makes the synthesis prefer barriers, cost 20 promoted accesses, so both
kinds of mechanism are checked. `naive-orb` is the naive pipeline, `clangir`
ClangIR's own lowering without Orb. Any other set can be selected with
`ORB_LITMUS_COMPILERS`, e.g. `orb-c2` for the default cost.

## Results

36 tests x 4 configurations, no failures and no errors.

| Configuration | Pass | Over | XFAIL (`lb`) | Fail |
|---|---|---|---|---|
| `orb-c1`    | 33 | 2 | 1 | 0 |
| `orb-c20`   | 33 | 2 | 1 | 0 |
| `naive-orb` | 34 | 1 | 1 | 0 |
| `clangir`   | 34 | 1 | 1 | 0 |

**LB with all-relaxed accesses diverges, as expected.** `lb` is `Never` under
RC11 and `Sometimes` on ARMv8. RC11 forbids load buffering by requiring
`po | rf` to be acyclic -- a global argument about the whole execution -- and no
per-access mapping can enforce that locally. Listed as XFAIL with that reason
rather than silently excluded.

**Orb over-synchronises `2+2W_relaxed`.** Both stores are
`memory_order_relaxed`, so RC11 requires no ordering between them and permits
the outcome. `naive-orb` emits two plain `str`s and the outcome stays
observable; both synthesis configurations order the two stores (cost 1 with a
`dmb ish`, cost 20 with an `stlr`) and the outcome becomes unobservable. The
cause is the may-alias approximation: the source side orders two writes that may
access the same location, and the alias analysis cannot prove that two distinct
globals do not. Sound, but stronger than needed; reported as `OVER`, which does
not fail the run. (`2+2W_rel` is `OVER` in every configuration: release stores
are simply stronger than this shape needs.)

## What the corpus does and does not cover

`negative_control.sh` takes every generated test of the synthesis
configurations whose condition ARMv8 never allows, and removes one kind of
ordering mechanism at a time -- barriers, `LDAR`, `LDAPR` or `STLR` -- before
asking herd7 again. A verdict that moves shows that the green result is held by
the ordering the synthesis emitted.

The same 9 tests move in both configurations: `a4` from the catalogue, the
release-acquire and SC message passing, store buffering with SC accesses,
release-acquire load buffering, WRC and ISA2, and the two over-synchronised 2+2W
tests. With cost 1 they move only when the barriers are removed, with cost 20
only when `LDAR` or `STLR` is downgraded -- the two costs establish the same
orderings with different mechanisms, and both are correct.

The remaining weakenings, all in catalogue tests, change nothing, and this is
the main reason `tests/` exists. The c11popl15 tests illustrate which
*source-level* transformations are valid; their outcomes are mostly ruled out by
control dependencies or by the absence of out-of-thin-air values, which hold on
ARMv8 whatever the mapping emits. `c` is the clearest case -- each thread
reaches its store only if the other thread already stored, so neither ever
does, barrier or no barrier. Those tests still check that the compiler
introduces no new behaviour; they just do not exercise fence synthesis, and
counting them as evidence that it works would be wrong.

## Limitations

- herd7 checks the final `-O1` assembly, so a failure implicates the whole
  pipeline, LLVM's own optimisations included. Orb interprets LLVM IR under the
  *target* model rather than RC11, so those passes are not guaranteed sound
  here; on a failure, establish which stage caused it before blaming Orb.
- 9 catalogue tests are out of scope for using `compare_exchange_strong`, as
  above.
- `fig6` and `fig6_translated` are skipped: their condition names six registers
  in one thread, and a thread returns a single `int`. Every other conditioned
  test names at most one register per thread.
- 10 catalogue tests carry no `exists` clause (the `a5`..`a9` families).
  They illustrate a reordering rather than assert an outcome, so there is no
  condition to compare and they are skipped.
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
