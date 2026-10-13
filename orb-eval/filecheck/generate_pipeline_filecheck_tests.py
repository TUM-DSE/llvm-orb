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

Every shape is one of two kinds, recorded in the "// ORB-KIND:" header:

  ordering     The source requires an ordering that nothing in the relaxed
               target program provides. The synthesis has to establish it, by
               promoting an access or inserting a barrier.

  dependency   The required ordering is already provided by an ARMv8
               dependency (address, data or control) from the load to the later
               access. Under ARMv8 the program needs no synchronization at all,
               so the synthesis must leave every access relaxed and insert no
               barrier. Every dependency shape has an ordering twin that differs
               only in the dependency (data_dep / load_store, if_else /
               if_else_indep, ...), so that a failure can be traced to the
               dependency and nothing else.

So each generated test carries two kinds of expectation:

  CHECK        Invariants that hold under *every* legal solution: no cpp_atomic
               operation survives, and the expected accesses exist with the
               right element type and alignment. These must always match.

  SOL<X>       One alternative ordering mechanism each. The runner accepts the
               output if AT LEAST ONE of them matches. A dependency shape has a
               single alternative, RELAXED: all accesses relaxed and no barrier
               between them.

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
FENCE_FULL = "4"           # DMB SY: the only barrier ordering [W];po;[R]


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


# A "-NOT" line between two patterns: no barrier in between. The emitter turns
# a pattern starting with NOT: into a <PREFIX>-NOT line.
NO_FENCE = "NOT:arm_atomic.atomic_fence"


def strict(*pats):
    """An exact expectation: the given patterns in order, and no barrier other
    than the ones listed -- none before the first pattern, between two
    patterns, or after the last one (up to the next function label). Every
    access pattern pins its memory order, so a redundant promotion fails too."""
    out = [NO_FENCE]
    for p in pats:
        out += [p, NO_FENCE]
    return out


def relaxed(*pats):
    """RELAXED expectation of a dependency shape: every access relaxed (the
    patterns pin memory order 0) and no barrier anywhere in the function."""
    return strict(*pats)


# ---------------------------------------------------------------------------
# Shapes
#
# Each shape describes one source-level control-flow / call structure together
# with the ordering requirement it creates, the invariants that always hold,
# the alternative legal solutions, and the deterministic naive mapping.
#
#   kind             -> "ordering" or "dependency" (see the module docstring)
#   body(c, tag)     -> the C++ function body for C type `c` and type tag `tag`
#   globals_         -> globals the body needs (orb_<G>_<tag>); "A[2]" is an array
#   checks(ty, al)   -> list of always-true CHECK lines
#   solutions(ty,al) -> {name: [lines]}, at least one must match
#   naive(ty, al)    -> deterministic checks for --cpp-atomic-to-arm-atomic-naive
#   extra, callee_*  -> an optional callee orb_callee_<tag>, emitted first
# ---------------------------------------------------------------------------

SHAPES = {}


def shape(name):
    def register(fn):
        SHAPES[name] = fn()
        SHAPES[name]["name"] = name
        return fn
    return register


# ===========================================================================
# Ordering shapes: no dependency orders the required pair, so the synthesis
# has to promote an access or insert a barrier.
# ===========================================================================

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
            # Both stores relaxed, a store (or full) barrier between them.
            "FENCE": strict(store_pat(ty, al, ARM_RLX),
                            fence_pat(FENCE_ST),
                            store_pat(ty, al, ARM_RLX)),
            # Or the second store promoted to STLR, and no barrier.
            "PROMOTE": strict(store_pat(ty, al, ARM_RLX),
                              store_pat(ty, al, ANY_REL)),
        }

    def naive(ty, al):
        return [store_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(kind="ordering", globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed store followed by a release store")


@shape("seq_load")
def _seq_load():
    """An acquire load followed by a relaxed store of an unrelated value.

    Source requirement: ppo_fence, [R & ACQ];po. The stored value does not
    depend on the load, so nothing in the relaxed program orders the pair.
    Ordering twin of seq_load_dep.
    """
    def body(c, tag):
        return ("  %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_ACQUIRE);\n"
                "  (void)r;\n"
                "  __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELAXED);\n"
                % (c, tag, tag, c))

    def checks(ty, al):
        return [load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {
            "FENCE": strict(load_pat(ty, al, ARM_RLX),
                            fence_pat(FENCE_LD),
                            store_pat(ty, al, ARM_RLX)),
            # LDAPR or LDAR orders itself before every po-later access.
            "PROMOTE_LOAD": strict(load_pat(ty, al, ANY_ACQ),
                                   store_pat(ty, al, ARM_RLX)),
            # An STLR orders every po-earlier access before itself.
            "PROMOTE_STORE": strict(load_pat(ty, al, ARM_RLX),
                                    store_pat(ty, al, ANY_REL)),
        }

    def naive(ty, al):
        # Table 1: acquire load -> R_acq-pc (LDAPR).
        return [load_pat(ty, al, ARM_ACQPC), store_pat(ty, al, ARM_RLX)]

    return dict(kind="ordering", globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="acquire load followed by a relaxed store of a constant")


@shape("load_store")
def _load_store():
    """A relaxed load followed by a release store of an unrelated value.

    Source requirement: po;[W & REL]. Ordering twin of data_dep: the same two
    accesses, but the stored value is a constant.
    """
    def body(c, tag):
        return ("  %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "  (void)r;\n"
                "  __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELEASE);\n"
                % (c, tag, tag, c))

    def checks(ty, al):
        return [load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {
            "PROMOTE_LOAD": strict(load_pat(ty, al, ANY_ACQ),
                                   store_pat(ty, al, ARM_RLX)),
            "PROMOTE_STORE": strict(load_pat(ty, al, ARM_RLX),
                                    store_pat(ty, al, ANY_REL)),
            "FENCE": strict(load_pat(ty, al, ARM_RLX),
                            fence_pat(FENCE_LD),
                            store_pat(ty, al, ARM_RLX)),
        }

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(kind="ordering", globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load and release store of a constant")


@shape("if_else_indep")
def _if_else_indep():
    """A load, then a branch on a parameter selecting between two release stores.

    Ordering twin of if_else: the branch does not depend on the load, so there
    is no control dependency. Both branches carry the same requirement, so one
    barrier after the load (before the branch) can cover both.
    """
    def body(c, tag):
        return ("  %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "  (void)r;\n"
                "  if (n > 42) {\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELEASE);\n"
                "  } else {\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)2, __ATOMIC_RELEASE);\n"
                "  }\n" % (c, tag, tag, c, tag, c))

    def checks(ty, al):
        return [load_pat(ty, al), "cf.cond_br",
                store_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {
            # One barrier before the branch covers both arms.
            "FENCE_BEFORE_BRANCH": strict(load_pat(ty, al, ARM_RLX),
                                          fence_pat(FENCE_LD),
                                          "cf.cond_br",
                                          store_pat(ty, al, ARM_RLX),
                                          store_pat(ty, al, ARM_RLX)),
            # Or one barrier inside each arm; both arms need one.
            "FENCE_PER_ARM": strict(load_pat(ty, al, ARM_RLX),
                                    "cf.cond_br",
                                    fence_pat(FENCE_LD),
                                    store_pat(ty, al, ARM_RLX),
                                    fence_pat(FENCE_LD),
                                    store_pat(ty, al, ARM_RLX)),
            # Or promote the load, which orders it before both arms.
            "PROMOTE_LOAD": strict(load_pat(ty, al, ANY_ACQ),
                                   "cf.cond_br",
                                   store_pat(ty, al, ARM_RLX),
                                   store_pat(ty, al, ARM_RLX)),
            # Or promote both stores.
            "PROMOTE_STORES": strict(load_pat(ty, al, ARM_RLX),
                                     "cf.cond_br",
                                     store_pat(ty, al, ANY_REL),
                                     store_pat(ty, al, ANY_REL)),
        }

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), "cf.cond_br",
                store_pat(ty, al, ARM_REL), store_pat(ty, al, ARM_REL)]

    return dict(kind="ordering", globals_=["X", "Y"], params="int n", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load, then a branch on a parameter between two release stores")


@shape("loop")
def _while_loop():
    """A load and a release store of a constant inside a loop body.

    The cost model scales barrier cost with loop depth, so the synthesis is
    expected to prefer promoting an access over inserting a barrier here. The
    test only requires that some legal mechanism is used. Ordering twin of
    while_loop_dep.
    """
    def body(c, tag):
        return ("  for (int i = 0; i < n; ++i) {\n"
                "    %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "    (void)r;\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELEASE);\n"
                "  }\n" % (c, tag, tag, c))

    def checks(ty, al):
        return ["cf.cond_br", load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        # Each mechanism also covers the load of one iteration against the
        # store of the next: an acquire load or a barrier after it orders it
        # before everything later, an STLR orders everything earlier.
        return {
            "PROMOTE_LOAD": strict("cf.cond_br", load_pat(ty, al, ANY_ACQ),
                                   store_pat(ty, al, ARM_RLX)),
            "PROMOTE_STORE": strict("cf.cond_br", load_pat(ty, al, ARM_RLX),
                                    store_pat(ty, al, ANY_REL)),
            "FENCE": strict("cf.cond_br", load_pat(ty, al, ARM_RLX),
                            fence_pat(FENCE_LD),
                            store_pat(ty, al, ARM_RLX)),
        }

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(kind="ordering", globals_=["X", "Y"], params="int n", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load and release store of a constant inside a loop")


@shape("loop_back_edge")
def _loop_back_edge():
    """A relaxed store followed by an acquire load inside a loop.

    Within one iteration nothing is required: the store precedes the load. But
    [R & ACQ];po orders the load of iteration k before every later access --
    the store and the load of iteration k+1 -- a pair that exists only through
    the loop's back edge. Accepted: the load promoted, or a barrier after the
    load or at the start of the next iteration, before the store. Not accepted:
    a barrier between store and load, which does not separate the load from the
    next iteration, or the store promoted alone, which orders the load before
    the next store but not before the next load.
    """
    def body(c, tag):
        return ("  for (int i = 0; i < n; ++i) {\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELAXED);\n"
                "    %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_ACQUIRE);\n"
                "    (void)r;\n"
                "  }\n" % (tag, c, c, tag))

    def checks(ty, al):
        return ["cf.cond_br", store_pat(ty, al), load_pat(ty, al)]

    def solutions(ty, al):
        return {
            "PROMOTE_LOAD": strict("cf.cond_br", store_pat(ty, al, ARM_RLX),
                                   load_pat(ty, al, ANY_ACQ)),
            "FENCE_AFTER_LOAD": strict("cf.cond_br", store_pat(ty, al, ARM_RLX),
                                       load_pat(ty, al, ARM_RLX),
                                       fence_pat(FENCE_LD)),
            "FENCE_BEFORE_STORE": strict("cf.cond_br", fence_pat(FENCE_LD),
                                         store_pat(ty, al, ARM_RLX),
                                         load_pat(ty, al, ARM_RLX)),
        }

    def naive(ty, al):
        return [store_pat(ty, al, ARM_RLX), load_pat(ty, al, ARM_ACQPC)]

    return dict(kind="ordering", globals_=["X", "Y"], params="int n", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed store followed by an acquire load inside a loop (ordering only across iterations)")


@shape("call")
def _call():
    """A call between two ordered accesses, with an atomic inside the callee.

    The release store must be ordered after the caller's own relaxed store AND
    after the store performed inside the callee, so this exercises the
    interprocedural reachability in the ordering analysis. A barrier before
    the call alone does not cover the callee's store (see below). Ordering
    counterpart of call_dep.
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

    # Three requirements: the callee's store Z and the caller's store X before
    # the release store Y (po;[W & REL]), and X before Z (two writes that may
    # alias). Every accepted solution combines one mechanism for the first two
    # with one for the third, and is checked exactly in caller and callee.
    # A barrier before the call alone is NOT a solution: it orders X before Z
    # and Y, but not Z before Y.
    #
    #   for Z,X -> Y:  YREL         Y promoted to STLR
    #                  FAFTERCALL   barrier after the call, before Y
    #                  FAFTERZ      barrier in the callee after Z
    #   for X -> Z:    ZREL         Z promoted to STLR
    #                  FBEFORECALL  barrier before the call
    #                  FBEFOREZ     barrier in the callee before Z
    def _parts(ty, al):
        to_y = {
            "YREL": dict(y=ANY_REL, after_call=False, after_z=False),
            "FAFTERCALL": dict(y=ARM_RLX, after_call=True, after_z=False),
            "FAFTERZ": dict(y=ARM_RLX, after_call=False, after_z=True),
        }
        to_z = {
            "ZREL": dict(z=ANY_REL, before_call=False, before_z=False),
            "FBEFORECALL": dict(z=ARM_RLX, before_call=True, before_z=False),
            "FBEFOREZ": dict(z=ARM_RLX, before_call=False, before_z=True),
        }
        caller, callee = {}, {}
        for an, a in to_y.items():
            for bn, b in to_z.items():
                name = "%s_%s" % (an, bn)
                seq = [store_pat(ty, al, ARM_RLX)]
                if b["before_call"]:
                    seq.append(fence_pat(FENCE_ST))
                seq.append("cir.call @orb_callee_")
                if a["after_call"]:
                    seq.append(fence_pat(FENCE_ST))
                seq.append(store_pat(ty, al, a["y"]))
                caller[name] = strict(*seq)
                cseq = []
                if b["before_z"]:
                    cseq.append(fence_pat(FENCE_ST))
                cseq.append(store_pat(ty, al, b["z"]))
                if a["after_z"]:
                    cseq.append(fence_pat(FENCE_ST))
                callee[name] = strict(*cseq)
        return caller, callee

    def callee_checks(ty, al):
        return [store_pat(ty, al)]

    def callee_solutions(ty, al):
        return _parts(ty, al)[1]

    def callee_naive(ty, al):
        return [store_pat(ty, al, ARM_RLX)]

    def checks(ty, al):
        return [store_pat(ty, al), "cir.call @orb_callee_", store_pat(ty, al)]

    def solutions(ty, al):
        return _parts(ty, al)[0]

    def naive(ty, al):
        return [store_pat(ty, al, ARM_RLX),
                "cir.call @orb_callee_",
                store_pat(ty, al, ARM_REL)]

    return dict(kind="ordering", globals_=["X", "Y", "Z"], params="void",
                body=body, extra=extra, checks=checks, solutions=solutions,
                naive=naive, callee_checks=callee_checks,
                callee_solutions=callee_solutions, callee_naive=callee_naive,
                doc="relaxed store, call with an atomic inside, release store")


@shape("call_overwritten")
def _call_overwritten():
    """call_dep with the returned value overwritten before the branch.

    The variable that held the loaded value is assigned a parameter before the
    branch, so the branch no longer depends on the load and nothing orders the
    load before the release stores. Ordering twin of call_dep: the synthesis
    has to establish the ordering, in the callee or in the caller.
    """
    def body(c, tag):
        return ("  %s r = orb_callee_%s();\n"
                "  r = (%s)k;\n"
                "  if (r > (%s)42) {\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELEASE);\n"
                "  } else {\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)2, __ATOMIC_RELEASE);\n"
                "  }\n" % (c, tag, c, c, tag, c, tag, c))

    def extra(c, tag):
        return ('extern "C" %s orb_callee_%s(void) {\n'
                "  return __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "}\n" % (c, tag, tag))

    def callee_checks(ty, al):
        return [load_pat(ty, al)]

    def callee_solutions(ty, al):
        load_rlx = strict(load_pat(ty, al, ARM_RLX))
        return {"PROMOTE_LOAD": strict(load_pat(ty, al, ANY_ACQ)),
                "FENCE_IN_CALLEE": strict(load_pat(ty, al, ARM_RLX),
                                          fence_pat(FENCE_LD)),
                "FENCE_BEFORE_BRANCH": load_rlx,
                "FENCE_PER_ARM": load_rlx,
                "PROMOTE_STORES": load_rlx}

    def callee_naive(ty, al):
        return [load_pat(ty, al, ARM_RLX)]

    def checks(ty, al):
        return ["cir.call @orb_callee_", "cf.cond_br",
                store_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        rlx = store_pat(ty, al, ARM_RLX)
        return {
            "PROMOTE_LOAD": strict("cir.call @orb_callee_", "cf.cond_br", rlx, rlx),
            "FENCE_IN_CALLEE": strict("cir.call @orb_callee_", "cf.cond_br", rlx, rlx),
            "FENCE_BEFORE_BRANCH": strict("cir.call @orb_callee_", fence_pat(FENCE_LD),
                                          "cf.cond_br", rlx, rlx),
            "FENCE_PER_ARM": strict("cir.call @orb_callee_", "cf.cond_br",
                                    fence_pat(FENCE_LD), rlx,
                                    fence_pat(FENCE_LD), rlx),
            "PROMOTE_STORES": strict("cir.call @orb_callee_", "cf.cond_br",
                                     store_pat(ty, al, ANY_REL),
                                     store_pat(ty, al, ANY_REL)),
        }

    def naive(ty, al):
        return ["cir.call @orb_callee_", "cf.cond_br",
                store_pat(ty, al, ARM_REL), store_pat(ty, al, ARM_REL)]

    return dict(kind="ordering", globals_=["X", "Y"], params="int k",
                body=body, extra=extra, checks=checks, solutions=solutions,
                naive=naive, callee_checks=callee_checks,
                callee_solutions=callee_solutions, callee_naive=callee_naive,
                doc="callee returns a relaxed load, caller overwrites the value before branching to two release stores (no dependency)")


@shape("sc_pair")
def _sc_pair():
    """A sequentially consistent store followed by a sequentially consistent load.

    Source requirement: ppo_SC, [W & SC];po;[R & SC]. No dependency can order a
    store before a later load. The final relaxed store writes a constant, so the
    acquire half of the load ([R & ACQ];po) has to be established as well. On ARMv8 the natural solution is the STLR ->
    LDAR pairing (bob: [L];po;[A]), which is the one case where the load must
    become a full LDAR rather than the cheaper LDAPR: LDAPR is RCpc and does not
    pair with a preceding STLR.
    """
    def body(c, tag):
        return ("  __atomic_store_n(&orb_X_%s, (%s)1, __ATOMIC_SEQ_CST);\n"
                "  %s r = __atomic_load_n(&orb_Y_%s, __ATOMIC_SEQ_CST);\n"
                "  (void)r;\n"
                "  __atomic_store_n(&orb_Z_%s, (%s)1, __ATOMIC_RELAXED);\n"
                % (tag, c, c, tag, tag, c))

    def checks(ty, al):
        return [store_pat(ty, al), load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        # Three requirements: store -> load ([W & SC];po;[R & SC]), load ->
        # final store ([R & ACQ];po), and store -> final store (the two writes
        # may alias). The final store is a constant, so no dependency helps.
        return {
            # STLR -> LDAR ([L];po;[A]); the LDAR also orders the final store,
            # and store -> final store follows transitively. Note LDAR, not
            # LDAPR: LDAPR does not pair with a preceding STLR.
            "PAIR": strict(store_pat(ty, al, ANY_REL),
                           load_pat(ty, al, "{{2|4}}"),
                           store_pat(ty, al, ARM_RLX)),
            # Only a full barrier orders a store before a later load; then the
            # load still has to be ordered before the final store.
            "FENCE_ACQ": strict(store_pat(ty, al, ARM_RLX),
                                fence_pat(FENCE_FULL),
                                load_pat(ty, al, ANY_ACQ),
                                store_pat(ty, al, ARM_RLX)),
            "FENCE_FENCE": strict(store_pat(ty, al, ARM_RLX),
                                  fence_pat(FENCE_FULL),
                                  load_pat(ty, al, ARM_RLX),
                                  fence_pat(FENCE_LD),
                                  store_pat(ty, al, ARM_RLX)),
            "FENCE_REL": strict(store_pat(ty, al, ARM_RLX),
                                fence_pat(FENCE_FULL),
                                load_pat(ty, al, ARM_RLX),
                                store_pat(ty, al, ANY_REL)),
        }

    def naive(ty, al):
        # Table 1: sc store -> W_rel (STLR), sc load -> R_acq (LDAR).
        return [store_pat(ty, al, ARM_REL),
                load_pat(ty, al, ARM_ACQ),
                store_pat(ty, al, ARM_RLX)]

    return dict(kind="ordering", globals_=["X", "Y", "Z"], params="void",
                body=body, checks=checks, solutions=solutions, naive=naive,
                doc="seq_cst store, seq_cst load, relaxed store of a constant")


# ===========================================================================
# Dependency shapes: an ARMv8 dependency from the load already orders every
# required pair, so the synthesis must leave all accesses relaxed and insert
# no barrier (the single expectation RELAXED). A failure is a missed
# dependency: legal, but stronger than necessary.
# ===========================================================================

@shape("data_dep")
def _data_dep():
    """A relaxed load whose value is stored by a release store.

    Source requirement: po;[W & REL]. ARMv8 orders the pair through the data
    dependency (dob: data). Dependency twin of load_store.
    """
    def body(c, tag):
        return ("  %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "  __atomic_store_n(&orb_Y_%s, r, __ATOMIC_RELEASE);\n" % (c, tag, tag))

    def checks(ty, al):
        return [load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {"RELAXED": relaxed(load_pat(ty, al, ARM_RLX),
                                   store_pat(ty, al, ARM_RLX))}

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(kind="dependency", globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load and release store of the loaded value (data dependency)")


@shape("addr_dep")
def _addr_dep():
    """A relaxed load whose value selects the address of a release store.

    Source requirement: po;[W & REL]. ARMv8 orders the pair through the address
    dependency (dob: addr).
    """
    def body(c, tag):
        return ("  %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "  __atomic_store_n(&orb_A_%s[r & 1], (%s)1, __ATOMIC_RELEASE);\n"
                % (c, tag, tag, c))

    def checks(ty, al):
        return [load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {"RELAXED": relaxed(load_pat(ty, al, ARM_RLX),
                                   store_pat(ty, al, ARM_RLX))}

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(kind="dependency", globals_=["X", "A[2]"], params="void",
                body=body, checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load selecting the address of a release store (address dependency)")


@shape("if_else")
def _if_else():
    """A load whose value selects between two release stores.

    Source requirement: po;[W & REL] for both stores. ARMv8 orders the load
    before both through the control dependency (dob: ctrl;[W]), exactly the
    LB-if example of the Orb paper. Dependency twin of if_else_indep.
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
        return {"RELAXED": relaxed(load_pat(ty, al, ARM_RLX),
                                   "cf.cond_br",
                                   store_pat(ty, al, ARM_RLX),
                                   store_pat(ty, al, ARM_RLX))}

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), "cf.cond_br",
                store_pat(ty, al, ARM_REL), store_pat(ty, al, ARM_REL)]

    return dict(kind="dependency", globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load selecting between two release stores (control dependency)")


@shape("seq_load_dep")
def _seq_load_dep():
    """An acquire load whose value is stored by a relaxed store.

    Source requirement: [R & ACQ];po. The only later access is the store, and
    it depends on the load (dob: data), so the acquire needs no LDAPR.
    Dependency twin of seq_load.
    """
    def body(c, tag):
        return ("  %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_ACQUIRE);\n"
                "  __atomic_store_n(&orb_Y_%s, r, __ATOMIC_RELAXED);\n"
                % (c, tag, tag))

    def checks(ty, al):
        return [load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {"RELAXED": relaxed(load_pat(ty, al, ARM_RLX),
                                   store_pat(ty, al, ARM_RLX))}

    def naive(ty, al):
        return [load_pat(ty, al, ARM_ACQPC), store_pat(ty, al, ARM_RLX)]

    return dict(kind="dependency", globals_=["X", "Y"], params="void", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="acquire load followed by a relaxed store of the loaded value (data dependency)")


@shape("loop_dep")
def _while_loop_dep():
    """A load and a release store of the loaded value inside a loop body.

    Within an iteration, the data dependency orders the load before the store.
    Across iterations, the load of one iteration precedes the store of the
    next through its own store (data dependency) and the coherence order of the
    two stores to the same location (po-loc;[W]), so no barrier is needed
    either. Dependency twin of loop.
    """
    def body(c, tag):
        return ("  for (int i = 0; i < n; ++i) {\n"
                "    %s r = __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "    __atomic_store_n(&orb_Y_%s, r, __ATOMIC_RELEASE);\n"
                "  }\n" % (c, tag, tag))

    def checks(ty, al):
        return ["cf.cond_br", load_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {"RELAXED": relaxed(load_pat(ty, al, ARM_RLX),
                                   store_pat(ty, al, ARM_RLX))}

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(kind="dependency", globals_=["X", "Y"], params="int n", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="relaxed load and release store of the loaded value inside a loop (data dependency)")


@shape("nested")
def _nested():
    """A conditional release store of the loaded value inside a loop.

    The store is both data- and control-dependent on the load of its
    iteration; across iterations, the branch of an earlier iteration precedes
    every later store (ctrl;[W] covers all po-later writes).
    """
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
        return {"RELAXED": relaxed(load_pat(ty, al, ARM_RLX),
                                   "cf.cond_br",
                                   store_pat(ty, al, ARM_RLX))}

    def naive(ty, al):
        return [load_pat(ty, al, ARM_RLX), store_pat(ty, al, ARM_REL)]

    return dict(kind="dependency", globals_=["X", "Y"], params="int n", body=body,
                checks=checks, solutions=solutions, naive=naive,
                doc="conditional release store of the loaded value inside a loop (control and data dependency)")


@shape("call_dep")
def _call_dep():
    """A callee returns a relaxed load; the caller branches on the result.

    The control dependency runs through the return value of the call, so the
    analysis has to follow it across the function boundary. Dependency
    counterpart of call.
    """
    def body(c, tag):
        return ("  %s r = orb_callee_%s();\n"
                "  if (r > (%s)42) {\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)1, __ATOMIC_RELEASE);\n"
                "  } else {\n"
                "    __atomic_store_n(&orb_Y_%s, (%s)2, __ATOMIC_RELEASE);\n"
                "  }\n" % (c, tag, c, tag, c, tag, c))

    def extra(c, tag):
        return ('extern "C" %s orb_callee_%s(void) {\n'
                "  return __atomic_load_n(&orb_X_%s, __ATOMIC_RELAXED);\n"
                "}\n" % (c, tag, tag))

    def callee_checks(ty, al):
        return [load_pat(ty, al)]

    def callee_solutions(ty, al):
        return {"RELAXED": relaxed(load_pat(ty, al, ARM_RLX))}

    def callee_naive(ty, al):
        return [load_pat(ty, al, ARM_RLX)]

    def checks(ty, al):
        return ["cir.call @orb_callee_", "cf.cond_br",
                store_pat(ty, al), store_pat(ty, al)]

    def solutions(ty, al):
        return {"RELAXED": relaxed("cir.call @orb_callee_",
                                   "cf.cond_br",
                                   store_pat(ty, al, ARM_RLX),
                                   store_pat(ty, al, ARM_RLX))}

    def naive(ty, al):
        return ["cir.call @orb_callee_", "cf.cond_br",
                store_pat(ty, al, ARM_REL), store_pat(ty, al, ARM_REL)]

    return dict(kind="dependency", globals_=["X", "Y"], params="void",
                body=body, extra=extra, checks=checks, solutions=solutions,
                naive=naive, callee_checks=callee_checks,
                callee_solutions=callee_solutions, callee_naive=callee_naive,
                doc="callee returns a relaxed load, caller branches on it to two release stores (control dependency across a call)")


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
// ORB-SOLUTIONS prefixes matches. A dependency shape has a single solution,
// in which every access stays relaxed and no barrier is inserted, because the
// dependency already orders the accesses on ARMv8.
//
// (No prose line in this file may contain a check prefix followed by a colon:
// FileCheck would read it as a directive.)
//
// ORB-KIND: {kind}
// ORB-SOLUTIONS: {solutions}
//
// No <atomic> here on purpose: the __atomic_* builtins are what std::atomic
// lowers to and need no standard library for the target. extern "C" keeps the
// CHECK-LABEL anchors unmangled.

"""


def check_line(prefix, pat):
    """One FileCheck line; a pattern "NOT:<p>" becomes a <prefix>-NOT line."""
    if pat.startswith("NOT:"):
        return "// %s-NOT:   %s\n" % (prefix, pat[4:])
    return "// %s:       %s\n" % (prefix, pat)


def emit_shape(sh, outdir):
    tag_name = sh["name"]
    lines = [HEADER.format(doc=sh["doc"], kind=sh["kind"],
                           solutions=" ".join(sorted(sh["solutions"]("i32", 4))))]

    # Globals, one set per type. "A[2]" declares an array.
    for tag, c, ty, al in TYPES:
        for g in sh["globals_"]:
            name, bracket, dim = g.partition("[")
            lines.append("%s orb_%s_%s%s;\n" % (c, name, tag, bracket + dim))
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
            callee_sols = (sh["callee_solutions"](ty, al)
                           if "callee_solutions" in sh else {})
            for sol in sorted(sh["solutions"](ty, al)):
                lines.append("// %s-LABEL: cir.func{{.*}}@%s\n" % (sol, cname))
                for pat in callee_sols.get(sol, sh["callee_checks"](ty, al)):
                    lines.append(check_line(sol, pat))
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
                lines.append(check_line(sol, pat))

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
    # Shapes that no longer exist must not leave stale test files behind.
    for f in os.listdir(outdir):
        if (f.startswith("test_orb_pipeline_") and f.endswith(".cpp")
                and f[len("test_orb_pipeline_"):-4] not in SHAPES):
            os.remove(os.path.join(outdir, f))
    written = [emit_shape(SHAPES[n], outdir) for n in sorted(SHAPES)]
    print("Generated %d pipeline test file(s) in %s:" % (len(written), outdir))
    for n, p in zip(sorted(SHAPES), written):
        print("  %-45s %-10s (%d functions)" % (os.path.basename(p), SHAPES[n]["kind"], len(TYPES)))


if __name__ == "__main__":
    main()
