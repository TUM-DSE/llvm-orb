#!/usr/bin/env python3
r"""
litmus_to_cpp.py -- turn a herdtools7 C litmus test into a compilable C++ file.

A .litmus file is deliberately not C. Taking catalogue/c11popl15's a1.litmus:

    C a1                                        <- not a declaration
    { [x] = 0; [y] = 0; }                       <- initial state, not a statement
    P0 (atomic_int* x, atomic_int* y) {         <- no return type
      int r0 = atomic_load_explicit(y, memory_order_relaxed);
      ...
    }
    exists(x=1 /\ y=1)                          <- /\ is not a C operator

so it has to be parsed and a translation unit synthesised from it. Doing that
-- rather than hand-writing the thread bodies -- keeps the compiled program and
the RC11 reference answer derived from the same file, so the two cannot drift.

The translation is deliberately minimal. Thread *bodies are copied verbatim*:
the parameters are re-declared as local pointers to the globals, so `x` is still
a pointer and `*y` is still a dereference, and no statement has to be rewritten.

    P0 (atomic_int* x, volatile int* y) {       extern "C" void P0(void) {
      int r0 = atomic_load_explicit(...);         atomic_int * x = (atomic_int *)&lt_x;
      *y = 1;                              -->    volatile int * y = (volatile int *)&lt_y;
    }                                             int r0 = atomic_load_explicit(...);
                                                  *y = 1;
                                                }

Three details that the catalogue forces:

  - Globals are prefixed `lt_`. A parameter and its location share a name, so
    `atomic_int *x = &x;` would make the local shadow the global and initialise
    itself from its own indeterminate value.

  - A location can be declared with different types by different threads -- a1
    has `atomic_int* y` in P0 and `volatile int* y` in P1, which is the litmus
    idiom for mixing atomic and non-atomic access to one location. The global
    takes the atomic type and each thread casts, reproducing exactly that.

  - When the `exists` clause names a register (`exists (0:r1=1)`), that thread
    returns it. Every conditioned test in the catalogue names at most one
    register per thread, so a plain `int` return suffices, and the AArch64 ABI
    puts it in W0 -- a known register the generated litmus test can refer to,
    at the cost of no extra memory events.

Emits <name>.cpp next to a <name>.json recording locations, the global-name
mapping, per-thread return registers and the parsed condition, for the
AArch64-side generator to consume.
"""

import argparse
import json
import re
import sys
import textwrap
from pathlib import Path

GLOBAL_PREFIX = "lt_"


class LitmusError(Exception):
    pass


def strip_comments(text):
    """Remove (* ocaml-style *) and // comments, keeping line structure."""
    text = re.sub(r"\(\*.*?\*\)", "", text, flags=re.S)
    text = re.sub(r"//[^\n]*", "", text)
    return text


def match_brace(text, open_idx):
    """Index just past the '}' matching the '{' at open_idx."""
    if text[open_idx] != "{":
        raise LitmusError("expected '{' at offset %d" % open_idx)
    depth = 0
    for i in range(open_idx, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return i + 1
    raise LitmusError("unbalanced braces from offset %d" % open_idx)


# The suite tests the mapping of loads, stores and fences. Read-modify-write
# ops are out of scope (that work lives on the RMWOps branch), so a test using
# one is dropped rather than half-covered: its CAS would lift into a real
# ldxr/stxr pair and its verdict would then be reported as though it said
# something about load/store/fence ordering, which it would not.
ALLOWED_ATOMICS = {
    "atomic_load", "atomic_load_explicit",
    "atomic_store", "atomic_store_explicit",
    "atomic_thread_fence",
}

ATOMIC_CALL_RE = re.compile(r"\b(atomic_\w+)\s*\(")


def check_in_scope(threads):
    """Reject a test that uses anything beyond loads, stores and fences."""
    for t in threads:
        for m in ATOMIC_CALL_RE.finditer(t["body"]):
            op = m.group(1)
            if op not in ALLOWED_ATOMICS:
                raise LitmusError(
                    "uses %s in P%d; this suite covers loads, stores and "
                    "fences only" % (op, t["idx"]))


def parse_litmus(text, path):
    text = strip_comments(text)

    m = re.search(r"^\s*C\s+(\S+)\s*$", text, re.M)
    if not m:
        raise LitmusError("no `C <name>` header -- is this a C litmus test?")
    name = m.group(1)

    # The initial-state block is the first brace group after the header; thread
    # bodies all come later, so a plain search is unambiguous.
    init_open = text.index("{", m.end())
    init_end = match_brace(text, init_open)
    init_src = text[init_open + 1 : init_end - 1]

    # `[x] = 0` and `x = 0` both occur; the brackets mean "contents of".
    locations = {}
    for lm in re.finditer(r"\[?\s*(\w+)\s*\]?\s*=\s*(-?\w+)", init_src):
        locations[lm.group(1)] = lm.group(2)

    threads = []
    for tm in re.finditer(r"\bP(\d+)\s*\(([^)]*)\)\s*\{", text[init_end:]):
        idx = int(tm.group(1))
        params = []
        for raw in tm.group(2).split(","):
            raw = raw.strip()
            if not raw:
                continue
            pm = re.match(r"^(.*?[\s*])\s*(\w+)$", raw)
            if not pm:
                raise LitmusError("cannot parse parameter %r in P%d" % (raw, idx))
            ptype = " ".join(pm.group(1).split())
            if not ptype.endswith("*"):
                ptype += " *"
            params.append((ptype, pm.group(2)))

        body_open = init_end + tm.end() - 1
        body_end = match_brace(text, body_open)
        body = text[body_open + 1 : body_end - 1]
        threads.append({"idx": idx, "params": params, "body": body})

    if not threads:
        raise LitmusError("no P<n> thread definitions found")
    threads.sort(key=lambda t: t["idx"])

    # A location may be used without appearing in the initial state -- a9 takes
    # `volatile int* z` but declares only x and y. herd7 treats such a location
    # as 0, so match that rather than rejecting the test.
    for t in threads:
        for _, pname in t["params"]:
            locations.setdefault(pname, "0")

    check_in_scope(threads)

    cond = parse_condition(text)
    return {"name": name, "path": str(path), "locations": locations,
            "threads": threads, "condition": cond}


def parse_condition(text):
    """Parse the trailing exists/forall clause, or None when absent.

    Nine of the catalogue's tests (a2, a5..a9 and their _reorder variants) carry
    no clause at all -- they illustrate a reordering rather than assert an
    outcome -- so this is a normal case, not an error.
    """
    m = re.search(r"^\s*(~?\s*exists|forall)\s*(.*)$", text, re.M | re.S)
    if not m:
        return None
    kind = re.sub(r"\s+", "", m.group(1))
    expr = m.group(2).strip()
    terms = []
    for cm in re.finditer(r"(?:(\d+)\s*:\s*)?\[?\s*(\w+)\s*\]?\s*=\s*(-?\w+)", expr):
        tid, sym, val = cm.group(1), cm.group(2), cm.group(3)
        terms.append({"kind": "reg" if tid is not None else "mem",
                      "thread": int(tid) if tid is not None else None,
                      "name": sym, "value": val})
    return {"kind": kind, "expr": " ".join(expr.split()), "terms": terms}


def rewrite_implicit_atomics(body, atomic_params):
    """Make C11's implicit seq_cst accesses through an atomic_int* explicit.

    The prelude types atomic_int as plain int so that the __atomic_* builtins
    accept it, which loses the implicit atomicity C11 gives a bare access
    through an _Atomic pointer. Only a3_reorder relies on it (`*y = 1` in P0,
    a seq_cst store), but leaving it to degrade into a relaxed store silently
    would change what the test means. Returns (body, [notes]).
    """
    notes = []
    if not atomic_params:
        return body, notes
    names = "|".join(re.escape(n) for n in atomic_params)

    def store(m):
        notes.append("%s: *%s = %s -> seq_cst store" % (m.group(1), m.group(1),
                                                        m.group(2).strip()))
        return "atomic_store_explicit(%s, %s, memory_order_seq_cst);" % (
            m.group(1), m.group(2).strip())

    body = re.sub(r"\*\s*(" + names + r")\s*=\s*([^;=][^;]*);", store, body)

    def load(m):
        notes.append("%s: *%s -> seq_cst load" % (m.group(1), m.group(1)))
        return "atomic_load_explicit(%s, memory_order_seq_cst)" % m.group(1)

    body = re.sub(r"\*\s*(" + names + r")\b", load, body)
    return body, notes


def global_type(loc, threads):
    """Widest type any thread gives this location; atomic wins over volatile."""
    seen = []
    for t in threads:
        for ptype, pname in t["params"]:
            if pname == loc:
                seen.append(ptype)
    for ty in seen:
        if "atomic" in ty:
            return "atomic_int"
    if seen:
        return re.sub(r"\s*\*+$", "", seen[0]).strip()
    return "volatile int"


def return_registers(test):
    """thread index -> the single register its condition names, if any."""
    out = {}
    cond = test["condition"]
    if not cond:
        return out
    for term in cond["terms"]:
        if term["kind"] != "reg":
            continue
        tid = term["thread"]
        if tid in out and out[tid] != term["name"]:
            raise LitmusError(
                "P%d has two condition registers (%s, %s); a single int return "
                "cannot carry both" % (tid, out[tid], term["name"]))
        out[tid] = term["name"]
    return out


def generate_cpp(test):
    rets = return_registers(test)
    L = []
    A = L.append
    A("// Generated from %s by litmus_to_cpp.py -- do not edit." % test["path"])
    A("// Test: %s" % test["name"])
    if test["condition"]:
        A("// Condition: %s (%s)" % (test["condition"]["expr"],
                                     test["condition"]["kind"]))
    else:
        A("// Condition: none in the source test")
    A('#include "litmus_prelude.h"')
    A("")
    A("// Initial state: %s" % ("; ".join("%s=%s" % kv for kv in
                                          sorted(test["locations"].items()))
                                or "(empty)"))
    for loc in sorted(test["locations"]):
        A("%s %s%s = %s;" % (global_type(loc, test["threads"]),
                             GLOBAL_PREFIX, loc, test["locations"][loc]))
    A("")

    for t in test["threads"]:
        reg = rets.get(t["idx"])
        rty = "int" if reg else "void"
        A('extern "C" %s P%d(void) {' % (rty, t["idx"]))
        for ptype, pname in t["params"]:
            A("  %s %s = (%s)&%s%s;" % (ptype, pname, ptype,
                                        GLOBAL_PREFIX, pname))
        atomic_params = [n for ty, n in t["params"] if "atomic" in ty]
        body, notes = rewrite_implicit_atomics(t["body"], atomic_params)
        for note in notes:
            A("  // made explicit (C11 implicit atomic access): %s" % note)
        body = textwrap.dedent(body.strip("\n")).rstrip()
        for line in body.split("\n"):
            A(("  " + line) if line.strip() else "")
        if reg:
            A("  return %s;   // observed as W0 by the generated litmus test" % reg)
        A("}")
        A("")
    return "\n".join(L) + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("litmus", type=Path, nargs="+")
    ap.add_argument("-o", "--outdir", type=Path, required=True)
    args = ap.parse_args()
    args.outdir.mkdir(parents=True, exist_ok=True)

    ok = failed = 0
    for src in args.litmus:
        try:
            test = parse_litmus(src.read_text(), src)
            cpp = generate_cpp(test)
        except LitmusError as e:
            print("SKIP  %-18s %s" % (src.stem, e), file=sys.stderr)
            failed += 1
            continue
        (args.outdir / (test["name"] + ".cpp")).write_text(cpp)
        meta = dict(test)
        meta["globals"] = {loc: GLOBAL_PREFIX + loc for loc in test["locations"]}
        meta["return_registers"] = {str(k): v
                                    for k, v in return_registers(test).items()}
        (args.outdir / (test["name"] + ".json")).write_text(
            json.dumps(meta, indent=2) + "\n")
        ok += 1
    print("generated %d, skipped %d" % (ok, failed), file=sys.stderr)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
