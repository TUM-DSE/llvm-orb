#!/usr/bin/env python3
"""Generate FileCheck tests for the Orb *pipeline* (control flow and calls).

This is the second test suite for the Orb dialects. It is a companion to
generate_filecheck_tests.py, not a replacement:

  generate_filecheck_tests.py   checks the STATIC per-operation mappings
                                (CIR -> cpp_atomic -> arm_atomic -> LLVM) over
                                the cross product of value types, memory orders
                                and RMW operators. Every expected output is a
                                single, deterministic line.

  this script                   checks that the FULL Orb pipeline, including
                                --order-analysis and --fence-synthesis, emits a
                                *legal* target program for source programs that
                                contain function calls and control flow.

The difference matters. Once fence synthesis is in the loop there is no longer
one right answer: an ordering requirement between two accesses can be satisfied
by promoting the first access, by promoting the second, or by inserting a
barrier between them, and which one the synthesis picks depends on the cost
model (--fence-cost-base) and on loop depth. Pinning one exact instruction
sequence would test the current cost model rather than the correctness of the
lowering.

So each generated test carries two kinds of expectation:

  CHECK        Invariants that hold under *every* legal solution: no cpp_atomic
               operation survives, and the expected accesses exist with the
               right element type and alignment. These must always match.

  SOL<X>       One alternative ordering mechanism each. The runner accepts the
               output if AT LEAST ONE of them matches.

               Do NOT pin the *position* of a barrier relative to a call or a
               branch unless every listed alternative covers the other
               positions too. A barrier before or after a call, and a barrier
               before a branch or one inside each arm, are all legal answers to
               the same requirement, and the synthesis picks between them on
               cost. Anchoring on "cir.call" or "cf.cond_br" inside a solution
               is what made the call and if_else shapes fail after an unrelated
               change to the cost model.

The runner sweeps several --fence-cost-base values, so the suite also asserts
that the cost model produces a legal program at every setting, not just at the
default -- it is allowed to change its mind, but not to drop the ordering.

Test inputs are C++ rather than hand-written CIR: the CIR for a loop is ~60
lines of allocas and branches per function, which is impractical to maintain by
hand and would have to be regenerated on every ClangIR change. The RUN pipeline
compiles the C++ with -fclangir -emit-cir and pipes it into cir-opt, so the
input stays readable and always matches what the front end really produces.

The programs use the __atomic_* builtins instead of <atomic> so that the suite
does not depend on a C++ standard library being installed for the target; these
are exactly what std::atomic lowers to. Functions are extern "C" to keep the
CHECK-LABEL anchors unmangled.

Usage:
    python3 generate_pipeline_filecheck_tests.py
    ./run_pipeline_filecheck_tests.sh
"""

import os

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

# (tag, C type, MLIR element type, natural alignment)
TYPES = [
    ("i8",  "char",      "i8",  1),
    ("i16", "short",     "i16", 2),
    ("i32", "int",       "i32", 4),
    ("i64", "long long", "i64", 8),
]

# arm_atomic::MemoryOrder enum values, as printed by the generic attribute
# printer (the assembly format emits the raw integer, not the keyword).
ARM_RLX, ARM_ACQPC, ARM_ACQ, ARM_REL, ARM_ACQREL = 0, 1, 2, 3, 4

# Regex fragments for "any acquire-ish" / "any release-ish" / "any barrier that
# orders this pair". Written as FileCheck {{...}} regex alternations.
ANY_ACQ = "{{1|2|4}}"      # LDAPR, LDAR, or acq_rel
ANY_REL = "{{3|4}}"        # STLR or acq_rel
FENCE_LD = "{{2|4}}"       # DMB LD or DMB SY orders [R];po;[*]
FENCE_ST = "{{3|4}}"       # DMB ST or DMB SY orders [W];po;[W]
FENCE_ANY = "{{2|3|4}}"    # any non-relaxed barrier


def store_pat(ty, align, mo=None):
    """CHECK fragment for an arm_atomic.atomic_store of `ty` at `align`."""
    order = "" if mo is None else "memory_order(%s : i32) " % mo
    return "arm_atomic.atomic_store {{.*}}%salign(%d) {{.*}}: %s," % (order, align, ty)


def load_pat(ty, align, mo=None):
    """CHECK fragment for an arm_atomic.atomic_load of `ty` at `align`."""
    order = "" if mo is None else "memory_order(%s : i32) " % mo
    return "arm_atomic.atomic_load {{.*}}%salign(%d) {{.*}}-> %s" % (order, align, ty)


def fence_pat(mo):
    return "arm_atomic.atomic_fence memory_order(%s : i32)" % mo


# ---------------------------------------------------------------------------
# Shapes
#
# Each shape describes one source-level control-flow / call structure together
# with the ordering requirement it creates, the invariants that always hold,
# the alternative legal solutions, and the deterministic naive mapping.
#
#   body(t)          -> the C++ function body for type tag `t`
#   globals(t)       -> the globals that body() needs
#   checks(t)        -> list of always-true CHECK lines
#   solutions(t)     -> {name: [lines]}, at least one must match
#   naive(t)         -> deterministic checks for --cpp-atomic-to-arm-atomic-naive
# ---------------------------------------------------------------------------

SHAPES = {}


def shape(name):
    def register(fn):
        SHAPES[name] = fn()
        SHAPES[name]["name"] = name
        return fn
    return register


@shape("seq_store")
def _seq_store():
    """Two stores in sequence; the second is a release.

    Source requirement: ppo_fence, po;[W & REL] -- the relaxed store must be
    ordered before the release store.
    """
    def body(c, tag):
        return ("  __atomic_store_n(&orb_X_%s, (%s)1, __ATOMIC_RELAXED);\n"
                "  __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELEASE);\n"
                % (tag, c, tag, c))

    def checks(ty, al):
        return [store_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {
            # Leave both stores relaxed and separate them with a barrier.
            "FENCE": [store_pat(ty, al, ARM_RLX),
                      fence_pat(FENCE_ST),
                      store_pat(ty, al, ARM_RLX)],
            # Or promote the second store to STLR; then no barrier is needed.
            "PROMOTE": [store_pat(ty, al, ARM_RLX),
                        store_pat(ty, al, ANY_REL)],
        }

    def naive(ty, al):
        return [store_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed store followed by a release store")


@shape("seq_load")
def _seq_load():
    """An acquire load followed by a relaxed store.

    Source requirement: ppo_fence, [R & ACQ];po.
    """
    def body(c, tag):
        return ("  %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_ACQUIRE);\n"
                "  __atomic_store_n(&orb_Y_%s, r, __ATOMIC_RELAXED);\n"
                % (c, tag, tag))

    def checks(ty, al):
        return [load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {
            "FENCE": [load_pat(ty, al, ARM_RLX),
                      fence_pat(FENCE_LD),
                      store_pat(ty, al, ARM_RLX)],
            # LDAPR or LDAR orders itself before every po-later access.
            "PROMOTE": [load_pat(ty, al, ANY_ACQ),
                        store_pat(ty, al)],
        }

    def naive(ty, al):
        # Table 1: acquire load -> R_acq-pc (LDAPR).
        return [load_pat(ty, al, ARM_ACQPC), store_pat(ty, al, ARM_RLX)]

    return dict(globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="acquire load followed by a relaxed store")


@shape("call")
def _call():
    """A call between two ordered accesses, with an atomic inside the callee.

    The release store must be ordered after the caller's own relaxed store AND
    after the store performed inside the callee, so this exercises the
    interprocedural reachability in the ordering analysis. A single barrier
    placed before the call covers both requirements.
    """
    def body(c, tag):
        return ("  __atomic_store_n(&orb_X_%s, (%s)1, __ATOMIC_RELAXED);\n"
                "  orb_callee_%s();\n"
                "  __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELEASE);\n"
                % (tag, c, tag, tag, c))

    def extra(c, tag):
        return ('extern "C" void orb_callee_%s(void) {\n'
                "  __atomic_store_n(&orb_Z_%s, (%s)7, __ATOMIC_RELAXED);\n"
                "}\n" % (tag, tag, c))

    # The callee is not a passive bystander: the requirement "callee's store
    # ordered before the caller's release store" can be discharged inside the
    # callee, and the synthesis does exactly that -- at a low fence cost it puts
    # a DMB ST in front of the callee's store, at a high one it promotes that
    # store to STLR. So the callee needs its own expectations, otherwise
    # everything the synthesis does in there goes unchecked.
    #
    # The mechanism varies with cost, so only the invariant is asserted here:
    # the store survived with the right element type and alignment. Under the
    # naive pipeline there is no synthesis, so it is pinned to relaxed.
    def callee_checks(ty, al):
        return [store_pat(ty, al)]

    def callee_naive(ty, al):
        return [store_pat(ty, al, ARM_RLX)]

    def checks(ty, al):
        return [store_pat(ty, al), "cir.call @orb_callee_", store_pat(ty, al)]

    def solutions(ty, al):
        return {
            # A barrier before the call orders the caller's store and
            # everything the callee will do against the later release store.
            "FENCE_BEFORE_CALL": [store_pat(ty, al, ARM_RLX),
                                  fence_pat(FENCE_ST),
                                  "cir.call @orb_callee_",
                                  store_pat(ty, al, ARM_RLX)],
            # A barrier after the call is equally legal: by then the callee's
            # store has already happened, so one DMB ST covers both
            # requirements. Which side the synthesis picks is a cost-model
            # decision, so both have to be accepted.
            "FENCE_AFTER_CALL": [store_pat(ty, al, ARM_RLX),
                                 "cir.call @orb_callee_",
                                 fence_pat(FENCE_ST),
                                 store_pat(ty, al, ARM_RLX)],
            "PROMOTE": [store_pat(ty, al, ARM_RLX),
                        "cir.call @orb_callee_",
                        store_pat(ty, al, ANY_REL)],
        }

    def naive(ty, al):
        return [store_pat(ty, al, ARM_RLX),
                "cir.call @orb_callee_",
                store_pat(ty, al, ARM_REL)]

    return dict(globals_=["X", "Y", "Z"], params="void", body=body, extra=extra,
                checks=checks, solutions=solutions, naive=naive,
                callee_checks=callee_checks, callee_naive=callee_naive,
                doc="relaxed store, call with an atomic inside, release store")


@shape("if_else")
def _if_else():
    """A load whose value selects between two release stores.

    Both branches carry the same requirement, so one barrier placed after the
    load (before the branch) can cover both -- the interesting case, because a
    naive per-pair placement would emit two.
    """
    def body(c, tag):
        return ("  %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "  if (r > (%s)42) {\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELEASE);\n"
                "  } else {\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)2, __ATOMIC_RELEASE);\n"
                "  }\n" % (c, tag, c, tag, c, tag, c))

    def checks(ty, al):
        return [load_pat(ty, al), "cf.cond_br",
                store_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {
            # One barrier before the branch covers both arms.
            "FENCE_BEFORE_BRANCH": [load_pat(ty, al, ARM_RLX),
                                    fence_pat(FENCE_ANY),
                                    "cf.cond_br",
                                    store_pat(ty, al, ARM_RLX),
                                    store_pat(ty, al, ARM_RLX)],
            # Or one barrier inside each arm. Less efficient but just as legal,
            # and both arms must have one -- a single barrier covering only one
            # arm would leave the other path unordered, so this alternative
            # deliberately requires two.
            "FENCE_PER_ARM": [load_pat(ty, al, ARM_RLX),
                              "cf.cond_br",
                              fence_pat(FENCE_ANY),
                              store_pat(ty, al, ARM_RLX),
                              fence_pat(FENCE_ANY),
                              store_pat(ty, al, ARM_RLX)],
            # Or promote the load, which orders it before both arms.
            "PROMOTE_LOAD": [load_pat(ty, al, ANY_ACQ),
                             "cf.cond_br",
                             store_pat(ty, al),
                             store_pat(ty, al)],
            # Or promote both stores.
            "PROMOTE_STORES": [load_pat(ty, al, ARM_RLX),
                               "cf.cond_br",
                               store_pat(ty, al, ANY_REL),
                               store_pat(ty, al, ANY_REL)],
        }

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), "cf.cond_br",
                store_pat(ty, al, ARM_REL), store_pat(ty, al, ARM_REL)]

    return dict(globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load selecting between two release stores")


@shape("while_loop")
def _while_loop():
    """A load/store pair inside a loop body.

    The cost model scales barrier cost with loop depth, so the synthesis is
    expected to prefer promoting an access over inserting a barrier here. The
    test does not require that -- it only requires that some legal mechanism is
    used -- but the FENCE alternative is listed last on purpose.
    """
    def body(c, tag):
        return ("  for (int i = 0; i < n; ++i) {\n"
                "    %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "    __atomic_store_n(&orb_Y_%s, r, __ATOMIC_RELEASE);\n"
                "  }\n" % (c, tag, tag))

    def checks(ty, al):
        return ["cf.cond_br", load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {
            "PROMOTE_LOAD": [load_pat(ty, al, ANY_ACQ), store_pat(ty, al)],
            "PROMOTE_STORE": [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ANY_REL)],
            "FENCE": [load_pat(ty, al, ARM_RLX),
                      fence_pat(FENCE_ANY),
                      store_pat(ty, al, ARM_RLX)],
        }

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(globals_=["X", "Y"], params="int n", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load and release store inside a loop")

@shape("data_dep")
def _data_dep():
    """A load/store at different memory locations, but on the same program variable.

    It won't be ordered merely through a data dependency as according to §6.2 of the paper, 
    lmrs is excluded because an intervening write can't be ruled out in the presence of optimisations.
    """
    def body(c, tag):
        return ("    %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "    __atomic_store_n(&orb_Y_%s, r, __ATOMIC_RELEASE);\n" % (c, tag, tag))

    def checks(ty, al):
            return [load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {
            "PROMOTE_LOAD": [load_pat(ty, al, ANY_ACQ), store_pat(ty, al)],
            "PROMOTE_STORE": [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ANY_REL)],
            "FENCE": [load_pat(ty, al, ARM_RLX),
                      fence_pat(FENCE_ANY),
                      store_pat(ty, al, ARM_RLX)],
        }

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load and release store on a data dependency")

@shape("nested")
def _nested():
    """A conditional store nested inside a loop -- loop depth plus a branch."""
    def body(c, tag):
        return ("  for (int i = 0; i < n; ++i) {\n"
                "    %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "    if (r > (%s)0) {\n"
                "      __atomic_store_n(&orb_Y_%s, r, __ATOMIC_RELEASE);\n"
                "    }\n"
                "  }\n" % (c, tag, c, tag))

    def checks(ty, al):
        return ["cf.cond_br", load_pat(ty, al), "cf.cond_br", store_pat(ty, al)]

    def solutions(ty, al):
        return {
            "PROMOTE_LOAD": [load_pat(ty, al, ANY_ACQ), store_pat(ty, al)],
            "PROMOTE_STORE": [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ANY_REL)],
            "FENCE": [load_pat(ty, al, ARM_RLX),
                      fence_pat(FENCE_ANY),
                      store_pat(ty, al, ARM_RLX)],
        }

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(globals_=["X", "Y"], params="int n", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="conditional release store inside a loop")


@shape("sc_pair")
def _sc_pair():
    """A sequentially consistent store followed by a sequentially consistent load.

    Source requirement: ppo_SC, [W & SC];po;[R & SC]. On ARMv8 the natural
    solution is the STLR -> LDAR pairing (bob: [L];po;[A]), which is the one
    case where the load must become a full LDAR rather than the cheaper LDAPR:
    LDAPR is RCpc and does not pair with a preceding STLR.
    """
    def body(c, tag):
        return ("  __atomic_store_n(&orb_X_%s, (%s)1, __ATOMIC_SEQ_CST);\n"
                "  %s r = __atomic_load_n(&orb_Y_%s, __ATOMIC_SEQ_CST);\n"
                "  __atomic_store_n(&orb_Z_%s, r, __ATOMIC_RELAXED);\n"
                % (tag, c, c, tag, tag))

    def checks(ty, al):
        return [store_pat(ty, al), load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {
            # STLR followed by LDAR. Note ARM_ACQ, not ANY_ACQ: LDAPR would be
            # too weak to pair with the release store.
            "PAIR": [store_pat(ty, al, ANY_REL),
                     load_pat(ty, al, "{{2|4}}"),
                     store_pat(ty, al)],
            "FENCE": [store_pat(ty, al),
                      fence_pat(FENCE_ANY),
                      load_pat(ty, al),
                      store_pat(ty, al)],
        }

    def naive(ty, al):
        # Table 1: sc store -> W_rel (STLR), sc load -> R_acq (LDAR).
        return [store_pat(ty, al, ARM_REL),
                load_pat(ty, al, ARM_ACQ),
                store_pat(ty, al, ARM_RLX)]

    return dict(globals_=["X", "Y", "Z"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="seq_cst store followed by a seq_cst load")


# ---------------------------------------------------------------------------
# Emission
# ---------------------------------------------------------------------------

HEADER = """\
// Generated by generate_pipeline_filecheck_tests.py -- DO NOT EDIT BY HAND.
// Regenerate with:  python3 generate_pipeline_filecheck_tests.py
//
// Shape: {doc}
//
// Run with ./run_pipeline_filecheck_tests.sh, which sweeps --fence-cost-base
// and accepts the output if the CHECK invariants hold and at least one of the
// ORB-SOLUTIONS prefixes matches.
//
// ORB-SOLUTIONS: {solutions}
//
// No <atomic> here on purpose: the __atomic_* builtins are what std::atomic
// lowers to and need no standard library for the target. extern "C" keeps the
// CHECK-LABEL anchors unmangled.

"""


def emit_shape(sh, outdir):
    tag_name = sh["name"]
    lines = [HEADER.format(doc=sh["doc"],
                           solutions=" ".join(sorted(sh["solutions"]("i32", 4))))]

    # Globals, one set per type.
    for tag, c, ty, al in TYPES:
        for g in sh["globals_"]:
            lines.append("%s orb_%s_%s;\n" % (c, g, tag))
    lines.append("\n")

    for tag, c, ty, al in TYPES:
        fname = "orb_%s_%s" % (tag_name, tag)

        if "extra" in sh:
            lines.append(sh["extra"](c, tag))

        lines.append('extern "C" void %s(%s) {\n' % (fname, sh["params"]))
        lines.append(sh["body"](c, tag))
        lines.append("}\n")

        # The callee, if any, comes first in the output, so its label blocks
        # must come first here too. Giving every prefix a callee label also
        # tightens the caller's block: without it, the block anchored at
        # orb_call_i8 would run all the way to orb_call_i16 and so span the
        # *next* type's callee.
        if "extra" in sh:
            cname = "orb_callee_%s" % tag
            lines.append("// CHECK-LABEL: cir.func{{.*}}@%s\n" % cname)
            for pat in sh["callee_checks"](ty, al):
                lines.append("// CHECK:       %s\n" % pat)
            for sol in sorted(sh["solutions"](ty, al)):
                lines.append("// %s-LABEL: cir.func{{.*}}@%s\n" % (sol, cname))
                for pat in sh["callee_checks"](ty, al):
                    lines.append("// %s:       %s\n" % (sol, pat))
            lines.append("// NAIVE-LABEL: cir.func{{.*}}@%s\n" % cname)
            for pat in sh["callee_naive"](ty, al):
                lines.append("// NAIVE:       %s\n" % pat)

        # Invariants: must hold for every legal solution.
        lines.append("// CHECK-LABEL: cir.func{{.*}}@%s\n" % fname)
        for pat in sh["checks"](ty, al):
            lines.append("// CHECK:       %s\n" % pat)

        # Alternatives: the runner requires at least one to match.
        for sol, pats in sorted(sh["solutions"](ty, al).items()):
            lines.append("// %s-LABEL: cir.func{{.*}}@%s\n" % (sol, fname))
            for pat in pats:
                lines.append("// %s:       %s\n" % (sol, pat))

        # The naive pipeline has no synthesis, so its mapping is deterministic.
        lines.append("// NAIVE-LABEL: cir.func{{.*}}@%s\n" % fname)
        for pat in sh["naive"](ty, al):
            lines.append("// NAIVE:       %s\n" % pat)

        lines.append("\n")

    path = os.path.join(outdir, "test_orb_pipeline_%s.cpp" % tag_name)
    with open(path, "w") as f:
        f.write("".join(lines))
    return path


def main():
    outdir = os.path.dirname(os.path.abspath(__file__))
    written = [emit_shape(SHAPES[n], outdir) for n in sorted(SHAPES)]
    print("Generated %d pipeline test file(s) in %s:" % (len(written), outdir))
    for p in written:
        n_funcs = len(TYPES)
        print("  %-45s (%d functions)" % (os.path.basename(p), n_funcs))


if __name__ == "__main__":
    main()
