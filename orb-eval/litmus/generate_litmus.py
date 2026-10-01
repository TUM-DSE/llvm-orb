#!/usr/bin/env python3
r"""
generate_litmus.py -- splice Orb-compiled AArch64 assembly into litmus tests.

Takes the .cpp/.json pair that litmus_to_cpp.py produced, compiles it for
AArch64, lifts each thread's body out of the assembly and writes an AArch64
.litmus file that herd7 can check against aarch64.cat.

The lifting is the interesting part. Compiled code materialises a global's
address itself, in either of two forms:

    adrp x8, .Llt_x$local                       <- then folded onto the access
    str  w9, [x8, :lo12:.Llt_x$local]

    adrp x8, .Llt_x$local                       <- or completed by an add
    add  x8, x8, :lo12:.Llt_x$local
    ldar w8, [x8]

A litmus thread has no such code: herd binds a register to a location up front
(`0:X1=x;`) and the body just uses `[X1]`. So the address-forming instructions
are deleted and each location gets one canonical register, declared in the
initial state.

That needs the register *tracked*, not merely pattern-matched, because the
compiler reuses address registers and clobbers them in between -- in the second
form above, `ldar w8,[x8]` overwrites the very register holding the address,
and the next `adrp x8, .Llt_y$local` rebinds it to a different location. A
linear scan carries reg -> location bindings and invalidates one whenever an
instruction writes that register. w8 and x8 are the same register, so bindings
are keyed by number.

Compiled at -O1 or higher, always: a litmus thread has no stack frame, and at
-O0 every local is an alloca, so bodies come out full of [sp,#N] references that
have no meaning in a litmus test.
"""

import argparse
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

# x8..x13 are what the compiler actually uses at -O1, so bind locations from x1.
CANON_REGS = ["x1", "x2", "x3", "x4", "x5", "x6", "x7"]

SYM_RE = re.compile(r"\.L(\w+)\$local")
ADRP_RE = re.compile(r"^\s*adrp\s+(\w+),\s*\.L(\w+)\$local")
ADD_LO12_RE = re.compile(r"^\s*add\s+(\w+),\s*(\w+),\s*:lo12:\.L(\w+)\$local")
MEM_LO12_RE = re.compile(r"\[\s*(\w+)\s*,\s*:lo12:\.L(\w+)\$local\s*\]")
MEM_PLAIN_RE = re.compile(r"\[\s*(\w+)\s*\]")

# Instructions whose first operand is read, not written; everything else is
# assumed to define its first operand (ldr/ldar/mov/add/... and stxr's status).
# Instructions dropped from the lifted body.
#
# clrex clears the local exclusive monitor on a compare-exchange failure path.
# herd7's AArch64 parser has no such instruction, because the model pairs an
# ldxr with its stxr through the rmw relation rather than tracking monitor
# state. clrex performs no memory access and orders nothing, so removing it
# changes no event and no edge *in this model*. The caveat is that a test whose
# outcome genuinely depends on monitor state cannot be expressed here -- none of
# the catalogue's do, and their CAS still lifts as a real ldxr/stxr pair.
DROP = {"clrex"}

NO_DEF = {"str", "stlr", "stur", "strb", "strh", "stlrb", "stlrh",
          "cmp", "cmn", "tst", "cbz", "cbnz", "tbz", "tbnz", "b",
          "dmb", "dsb", "isb", "clrex", "ret", "nop"}


class LiftError(Exception):
    pass


def regnum(r):
    """w8 and x8 name one register; bindings are keyed by the number."""
    m = re.match(r"^[wx](\d+)$", r)
    return m.group(1) if m else r


def strip_comment(line):
    return line.split("//")[0].rstrip()


def extract_thread(asm, idx):
    """Lines of P<idx>'s body: its label through to .Lfunc_end.

    Not "up to the first ret" -- a function with several exits puts blocks
    *after* one. c_p's P0 is a compare-exchange loop whose failure path
    (.LBB0_5, reached by a b.ne from the retry loop) sits below the success
    path's ret, so stopping there drops a live branch target.
    """
    lines = asm.split("\n")
    start = None
    for i, line in enumerate(lines):
        if re.match(r"^P%d:" % idx, line):
            start = i + 1
            break
    if start is None:
        raise LiftError("no P%d in the assembly" % idx)
    out = []
    for line in lines[start:]:
        if re.match(r"^\.Lfunc_end", line):
            return out
        if re.match(r"^[A-Za-z_]\w*:", line):   # next function began
            return out
        out.append(line)
    raise LiftError("P%d never ends" % idx)


def lift_thread(body_lines, loc_of_global, idx=0):
    """Rewrite one thread's assembly into litmus form.

    Returns (instructions, {location: canonical register}).
    """
    bind = {}          # regnum -> location, live address bindings
    canon = {}         # location -> canonical register
    out = []
    # herd7 reads a P<n> identifier as a thread name, so the synthetic label
    # has to start with L, like the compiler's own .LBB labels.
    end_label = "Lend%d" % idx
    used_end = [False]

    def canon_reg(loc):
        if loc not in canon:
            if len(canon) >= len(CANON_REGS):
                raise LiftError("more than %d locations" % len(CANON_REGS))
            canon[loc] = CANON_REGS[len(canon)]
        return canon[loc]

    for raw in body_lines:
        line = strip_comment(raw)
        if not line.strip():
            continue
        stripped = line.strip()

        if stripped.split(" ")[0].lower() in DROP:
            continue

        # A litmus thread ends by falling off the bottom, and has no `ret`.
        # With several exits the rets are not all last, so each becomes a
        # branch to one synthetic end label appended below.
        if re.match(r"^ret\b", stripped):
            out.append("b %s" % end_label)
            used_end[0] = True
            continue

        # Labels: keep as branch targets, but drop the function's own alias.
        if re.match(r"^\.?\w[\w.$]*:$", stripped):
            if "$local" in stripped:
                continue
            out.append(stripped.lstrip("."))
            continue
        if stripped.startswith("."):        # .type, .size, .p2align, ...
            continue

        # Address materialisation: record the binding, emit nothing.
        m = ADRP_RE.match(line)
        if m:
            bind[regnum(m.group(1))] = loc_of_global.get(m.group(2), m.group(2))
            continue
        m = ADD_LO12_RE.match(line)
        if m:
            bind[regnum(m.group(1))] = loc_of_global.get(m.group(3), m.group(3))
            continue

        # Folded access: [x8, :lo12:.Llt_x$local] -> [x1]
        def fold(mm):
            loc = loc_of_global.get(mm.group(2), mm.group(2))
            return "[%s]" % canon_reg(loc)
        line = MEM_LO12_RE.sub(fold, line)

        # Plain access through a register we know holds an address.
        def plain(mm):
            loc = bind.get(regnum(mm.group(1)))
            return "[%s]" % canon_reg(loc) if loc else mm.group(0)
        line = MEM_PLAIN_RE.sub(plain, line)

        if SYM_RE.search(line):
            raise LiftError("unlifted symbol reference: %s" % line.strip())

        # Branch targets lose the leading dot, matching the label definitions.
        line = re.sub(r"\.(LBB[\w.]+)", r"\1", line)

        # This instruction's destination, if any, invalidates its binding --
        # `ldar w8,[x8]` leaves w8 holding a value, not an address.
        parts = line.split()
        if parts:
            mnem = parts[0].lower()
            if mnem not in NO_DEF and len(parts) > 1:
                dst = parts[1].rstrip(",")
                bind.pop(regnum(dst), None)

        out.append(" ".join(line.split()))

    # A trailing `b P0_end` immediately before `P0_end:` is just noise.
    if used_end[0] and out and out[-1] == "b %s" % end_label:
        out.pop()
        used_end[0] = any(l == "b %s" % end_label for l in out)
    if used_end[0]:
        out.append("%s:" % end_label)

    return out, canon


def build_litmus(name, meta, threads, compiler_label):
    """Assemble the .litmus text from per-thread instructions and bindings."""
    ncols = len(threads)
    widths = []
    cols = []
    for tid, (instrs, _canon) in threads.items():
        cols.append(instrs)
    height = max(len(c) for c in cols) if cols else 0
    for c in cols:
        c += [""] * (height - len(c))

    headers = ["P%d" % tid for tid in sorted(threads)]
    widths = [max([len(h)] + [len(r) for r in c]) for h, c in zip(headers, cols)]

    lines = ["AArch64 %s" % name,
             '"generated from %s by generate_litmus.py (%s, -O1)"'
             % (Path(meta["path"]).name, compiler_label)]

    init = []
    for tid in sorted(threads):
        _instrs, canon = threads[tid]
        for loc, reg in sorted(canon.items(), key=lambda kv: kv[1]):
            init.append("%d:%s=%s;" % (tid, reg.upper(), loc))
    for loc, val in sorted(meta["locations"].items()):
        if str(val) != "0":
            init.append("%s=%s;" % (loc, val))
    lines.append("{")
    lines.append(" " + " ".join(init))
    lines.append("}")

    lines.append(" " + " | ".join(h.ljust(w) for h, w in zip(headers, widths)) + " ;")
    for r in range(height):
        row = [cols[i][r].ljust(widths[i]) for i in range(ncols)]
        lines.append(" " + " | ".join(row) + " ;")

    cond = translate_condition(meta)
    lines.append("exists")
    lines.append("(%s)" % cond)
    return "\n".join(lines) + "\n"


def translate_condition(meta):
    """Rewrite the source condition over AArch64 state.

    A memory term carries over unchanged. A register term becomes X0: the
    thread returns that value, and the AArch64 ABI puts a returned int in W0.
    """
    cond = meta.get("condition")
    if not cond or not cond["terms"]:
        raise LiftError("test has no exists clause, nothing to compare")
    parts = []
    for t in cond["terms"]:
        if t["kind"] == "mem":
            parts.append("%s=%s" % (t["name"], t["value"]))
        else:
            parts.append("%d:X0=%s" % (t["thread"], t["value"]))
    return " /\\ ".join(parts)


def compile_asm(cpp, outdir, build, flags, include):
    """Compile one translation unit to AArch64 assembly.

    Calls the Orb clang in <build>/bin directly. The translation units include
    nothing but litmus_prelude.h, which uses compiler built-ins only, and are
    only compiled to assembly, never linked -- so no C library headers, crt
    files or Nix cc-wrapper are needed. (The suite used to go through
    build/clang-wrapper, a copy of Nix's cc-wrapper: it resolves ./bin/clang++
    relative to the working directory, injects clang 21's resource directory,
    and sources a Nix store path that breaks whenever that path is
    garbage-collected.)
    """
    asm = outdir / (cpp.stem + ".s")
    cmd = [str(build / "bin" / "clang++"), "--target=aarch64-linux-gnu",
           "-fclangir", "-O1", "-S", "-I", str(include), "-o", str(asm), str(cpp)]
    for f in flags:
        cmd[4:4] = ["-Xclang", f]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        raise LiftError("compile failed:\n%s" % r.stderr[-600:])
    return asm


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", type=Path, required=True,
                    help="directory of .cpp/.json from litmus_to_cpp.py")
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--build", type=Path, required=True)
    ap.add_argument("--compiler", default="orb",
                    help="orb, orb-c<N> (fence cost N), naive-orb or clangir")
    args = ap.parse_args()
    # Resolve once so that messages and the generated tests name absolute paths.
    args.src = args.src.resolve()
    args.out = args.out.resolve()
    args.build = args.build.resolve()

    if args.compiler.startswith("orb-c") and args.compiler[5:].isdigit():
        flags = ["-orb", "-orb-fence-cost-base=" + args.compiler[5:]]
    elif args.compiler in ("orb", "naive-orb", "clangir"):
        flags = {"orb": ["-orb"], "naive-orb": ["-naive-orb"], "clangir": []}[args.compiler]
    else:
        ap.error("unknown compiler configuration %s" % args.compiler)
    outdir = args.out / args.compiler
    outdir.mkdir(parents=True, exist_ok=True)

    ok = skipped = 0
    for meta_path in sorted(args.src.glob("*.json")):
        meta = json.loads(meta_path.read_text())
        name = meta["name"]
        cpp = args.src / (name + ".cpp")
        try:
            asm_path = compile_asm(cpp, outdir, args.build, flags, args.src.parent)
            asm = asm_path.read_text()
            loc_of_global = {g: l for l, g in meta["globals"].items()}
            threads = {}
            for t in meta["threads"]:
                body = extract_thread(asm, t["idx"])
                threads[t["idx"]] = lift_thread(body, loc_of_global, t["idx"])
            text = build_litmus(name, meta, threads, args.compiler)
        except LiftError as e:
            print("SKIP  %-16s %s" % (name, e), file=sys.stderr)
            skipped += 1
            continue
        (outdir / (name + ".litmus")).write_text(text)
        ok += 1
    print("%s: generated %d, skipped %d" % (args.compiler, ok, skipped),
          file=sys.stderr)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
