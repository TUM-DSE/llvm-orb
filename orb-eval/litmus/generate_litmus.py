#!/usr/bin/env python3
r"""
generate_litmus.py -- splice Orb-compiled AArch64 assembly into litmus tests.

Takes the .cpp/.json pair that litmus_to_cpp.py produced, compiles it for
AArch64 at a given -O level, lifts each thread's body out of the assembly and
writes an AArch64 .litmus file that herd7 can check against aarch64.cat.

herd7 knows no symbols, no linker and no stack. Its memory is a set of named
locations, and a register can be given the *address* of one in the initial
state (`0:X1=x;`). Compiled code differs in three ways, and the lifting
handles each one:

  1. Global addresses. The compiler forms the address of lt_x itself:

         adrp x9, .Llt_x$local                   <- page of lt_x
         add  x9, x9, :lo12:.Llt_x$local         <- plus the offset in the page
         ldr  w8, [x9]
     or
         adrp x9, .Llt_x$local
         str  w8, [x9, :lo12:.Llt_x$local]       <- offset folded into the access

     Each location gets one register bound to it in the initial state, and the
     address-forming instructions are replaced by copies of that register:
     `adrp x9, sym` and `add x9, x9, :lo12:sym` both become `mov x9,x1`, and
     `[x9, :lo12:sym]` becomes `[x1]`. Every one of these names its symbol, so
     each is rewritten on its own. Everything else is left alone: where the
     address goes from there -- into another register, onto the stack and back
     -- herd7 follows itself, in every execution and along every path. The
     lifter does not have to know which register holds which address where.

  2. The stack. At -O0 every local lives in a stack slot, and the register
     allocator spills to the stack as well. A slot is ordinary memory that only
     its own thread touches, so each one becomes a location of its own, private
     to the thread: `str w8, [sp, #12]` in P1 becomes `str w8, [x2]` with
     `1:X2=P1_sp12;`. herd7 then sees the same memory events the hardware
     performs, including dependencies carried through a slot. `sub sp`/`add sp`
     (the frame set-up) has no meaning without a stack pointer and is dropped.
     A slot accessed with 8 bytes (a pointer) is declared int64_t; herd7
     rejects a test that mixes access sizes on undeclared locations.

  3. herd7's syntax. Immediates are decimal (`#0x1` becomes `#1`), a thread
     falls off its end instead of returning (`ret` becomes a branch to a label
     at the end), and label names lose their leading dot.

Registers bound to locations are taken from those the thread never mentions,
so the compiled code cannot overwrite them. Anything the lifter does not
recognise -- another use of sp, an address register that nothing has written,
an unlifted symbol -- is an error rather than a guess: herd7 reads an unbound
register as address 0 and would silently answer "Never".
"""

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path

SYM = r"\.L(\w+)\$local"
ADRP_RE = re.compile(r"^adrp\s+x(\d+),\s*" + SYM + r"$")
ADD_LO12_RE = re.compile(r"^add\s+x(\d+),\s*x\d+,\s*:lo12:" + SYM + r"$")
LO12_OPERAND_RE = re.compile(r"^:lo12:" + SYM + r"$")
ADD_SP_RE = re.compile(r"^add\s+x(\d+),\s*sp(?:,\s*#(\d+))?$")
FRAME_RE = re.compile(r"^(sub|add)\s+sp,\s*sp,\s*#\d+$")
MEM_RE = re.compile(r"\[([^\]]*)\](!?)")
REG_RE = re.compile(r"\b([wx])(\d+)\b")

# Instructions dropped from the lifted body.
#
# clrex clears the local exclusive monitor on a compare-exchange failure path
# of an exclusive-pair loop. herd7's AArch64 parser has no such instruction,
# because the model pairs an ldxr with its stxr through the rmw relation rather
# than tracking monitor state. clrex performs no memory access and orders
# nothing, so removing it changes no event and no edge in this model.
DROP = {"clrex"}

# Instructions whose first operand is read, not written.
NO_DEF = {"str", "stlr", "stur", "strb", "strh", "stlrb", "stlrh", "sturb",
          "sturh", "cmp", "cmn", "tst", "cbz", "cbnz", "tbz", "tbnz", "b",
          "dmb", "dsb", "isb", "ret", "nop"}

# herd7 declares a location's type in the initial state; int is the default.
TYPE_OF_WIDTH = {1: "int8_t", 2: "int16_t", 4: "int", 8: "int64_t"}


class LiftError(Exception):
    pass


def strip_comment(line):
    return line.split("//")[0].rstrip()


def extract_thread(asm, idx):
    """Lines of P<idx>'s body: its label through to .Lfunc_end.

    Not "up to the first ret" -- a function with several exits puts blocks
    *after* one. c_p's P0 is a compare-exchange whose failure path sits below
    the success path's ret, so stopping there drops a live branch target.
    """
    lines = asm.split("\n")
    start = next((i + 1 for i, line in enumerate(lines)
                  if re.match(r"^P%d:" % idx, line)), None)
    if start is None:
        raise LiftError("no P%d in the assembly" % idx)
    out = []
    for line in lines[start:]:
        if re.match(r"^\.Lfunc_end", line) or re.match(r"^[A-Za-z_]\w*:", line):
            return out
        out.append(line)
    raise LiftError("P%d never ends" % idx)


def access_width(mnem, reg):
    """Bytes accessed: ldrb/strb 1, ldrh/strh 2, else by the register."""
    if mnem.endswith("b") and mnem != "b":
        return 1
    if mnem.endswith("h"):
        return 2
    return 8 if reg.startswith("x") else 4


def lift_thread(body_lines, loc_of_global, idx):
    """Rewrite one thread's assembly into litmus form.

    Returns (instructions, {location: register number}, {slot: width}).
    """
    insns = []
    for raw in body_lines:
        s = " ".join(strip_comment(raw).split())
        if not s or (s.startswith(".") and not s.endswith(":")):
            continue                     # blank, or .cfi_*/.p2align/...
        insns.append(s)

    # Bind locations only to registers the thread never mentions, so nothing
    # in the compiled code can overwrite them. X0 carries the return value.
    used = {int(n) for s in insns for _, n in REG_RE.findall(s)}
    free = [n for n in range(1, 31) if n not in used]
    binding = {}
    slots = {}                           # stack offset -> access width

    def bind(loc):
        if loc not in binding:
            if not free:
                raise LiftError("no free register left to bind %s to" % loc)
            binding[loc] = free.pop(0)
        return binding[loc]

    def location(sym):
        return loc_of_global.get(sym, sym)

    def slot(off):
        return "P%d_sp%d" % (idx, off)

    out = []
    end_label = "Lend%d" % idx
    written = set()                      # registers some earlier line writes

    for s in insns:
        mnem = s.split()[0].lower()
        if mnem in DROP or FRAME_RE.match(s):
            continue
        if re.match(r"^\.?\w[\w.$]*:$", s):           # label
            if "$local" not in s:                      # not the function alias
                out.append(s.lstrip("."))
            continue
        # A litmus thread ends by falling off the bottom and has no `ret`.
        if mnem == "ret":
            out.append("b %s" % end_label)
            continue

        # Address materialisation: a copy of the location's register.
        m = ADRP_RE.match(s) or ADD_LO12_RE.match(s)
        if m:
            d = int(m.group(1))
            out.append("mov x%d,x%d" % (d, bind(location(m.group(2)))))
            written.add(d)
            continue
        m = ADD_SP_RE.match(s)
        if m:                                          # address of a slot
            d, off = int(m.group(1)), int(m.group(2) or 0)
            slots.setdefault(off, None)
            out.append("mov x%d,x%d" % (d, bind(slot(off))))
            written.add(d)
            continue
        if re.search(r"\bsp\b", MEM_RE.sub("", s)):
            raise LiftError("unhandled use of sp: %s" % s)

        def mem(mm):
            if mm.group(2):
                raise LiftError("pre-index addressing: %s" % s)
            ops = [o.strip() for o in mm.group(1).split(",")]
            base = ops[0]
            if base == "sp":                            # a stack slot
                off = int(ops[1].lstrip("#")) if len(ops) > 1 else 0
                w = access_width(mnem, s.split()[1].rstrip(","))
                if slots.get(off) not in (None, w):
                    raise LiftError("slot sp+%d accessed with two widths" % off)
                slots[off] = w
                return "[x%d]" % bind(slot(off))
            bm = re.match(r"^x(\d+)$", base)
            if not bm:
                raise LiftError("unexpected address operand: %s" % s)
            if len(ops) > 1:
                lm = LO12_OPERAND_RE.match(ops[1])
                if not lm:
                    raise LiftError("offset addressing: %s" % s)
                return "[x%d]" % bind(location(lm.group(1)))
            if int(bm.group(1)) not in written:
                raise LiftError("address register never written: %s" % s)
            return "[%s]" % base

        line = MEM_RE.sub(mem, s)
        if re.search(SYM, line):
            raise LiftError("unlifted symbol reference: %s" % s)
        if re.search(r"\]\s*,\s*#", line):
            raise LiftError("post-index addressing: %s" % s)
        # Branch targets lose the leading dot, matching the label definitions.
        line = re.sub(r"\.(LBB[\w.]+)", r"\1", line)
        # herd7's parser takes decimal immediates only.
        line = re.sub(r"#0x([0-9a-fA-F]+)",
                      lambda h: "#%d" % int(h.group(1), 16), line)

        parts = line.split(None, 1)
        if mnem not in NO_DEF and len(parts) > 1:
            dm = REG_RE.match(parts[1])
            if dm:
                written.add(int(dm.group(2)))
        out.append(line)

    # Two slots that overlap would be two locations sharing bytes.
    spans = sorted((off, w or 4) for off, w in slots.items())
    for (o1, w1), (o2, _) in zip(spans, spans[1:]):
        if o1 + w1 > o2:
            raise LiftError("overlapping stack slots at sp+%d and sp+%d" % (o1, o2))

    # A trailing branch to the end label, right before it, is just noise.
    if out and out[-1] == "b %s" % end_label:
        out.pop()
    if any(line == "b %s" % end_label for line in out):
        out.append("%s:" % end_label)
    widths = {slot(off): (w or 4) for off, w in slots.items()}
    return out, binding, widths


def build_litmus(name, meta, threads, label):
    """Assemble the .litmus text from per-thread instructions and bindings."""
    cols = [list(threads[t][0]) for t in sorted(threads)]
    height = max(len(c) for c in cols)
    for c in cols:
        c += [""] * (height - len(c))
    headers = ["P%d" % t for t in sorted(threads)]
    widths = [max([len(h)] + [len(r) for r in c]) for h, c in zip(headers, cols)]

    lines = ["AArch64 %s" % name,
             '"generated from %s by generate_litmus.py (%s)"'
             % (Path(meta["path"]).name, label)]

    init = []
    for t in sorted(threads):
        for loc, w in sorted(threads[t][2].items()):
            if w != 4:
                init.append("%s %s;" % (TYPE_OF_WIDTH[w], loc))
    for t in sorted(threads):
        for loc, reg in sorted(threads[t][1].items(), key=lambda kv: kv[1]):
            init.append("%d:X%d=%s;" % (t, reg, loc))
    for loc, val in sorted(meta["locations"].items()):
        if str(val) != "0":
            init.append("%s=%s;" % (loc, val))
    lines += ["{", " " + " ".join(init), "}"]

    lines.append(" " + " | ".join(h.ljust(w) for h, w in zip(headers, widths)) + " ;")
    for r in range(height):
        lines.append(" " + " | ".join(cols[i][r].ljust(widths[i])
                                      for i in range(len(cols))) + " ;")
    lines += ["exists", "(%s)" % translate_condition(meta)]
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


def compile_asm(cpp, asm, build, opt, flags, include):
    """Compile one translation unit to AArch64 assembly.

    Calls the Orb clang in <build>/bin directly. The translation units include
    nothing but litmus_prelude.h, which uses compiler built-ins only, and are
    only compiled to assembly, never linked -- so no C library headers, crt
    files or Nix cc-wrapper are needed.
    """
    # The same CPU as the benchmarks: without RCpc, acquirePC loads would
    # become LDAR and LDAPR would never be tested.
    cpu = os.environ.get("ORB_LITMUS_CPU_FLAGS", "-mcpu=ampere1a").split()
    cmd = [str(build / "bin" / "clang++"), "--target=aarch64-linux-gnu",
           "-fclangir", opt, "-S", "-I", str(include), "-o", str(asm), str(cpp)] + cpu
    for f in flags:
        cmd[4:4] = ["-Xclang", f]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        raise LiftError("compile failed:\n%s" % r.stderr[-600:])


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", type=Path, required=True,
                    help="directory of .cpp/.json from litmus_to_cpp.py")
    ap.add_argument("--out", type=Path, required=True)
    ap.add_argument("--build", type=Path, required=True)
    ap.add_argument("--compiler", default="orb",
                    help="orb, orb-c<N> (fence cost N), naive-orb or clangir")
    ap.add_argument("--opt", default="-O0", choices=["-O0", "-O1", "-O2", "-O3"],
                    help="optimisation level (default -O0)")
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
    config = "%s%s" % (args.compiler, args.opt)          # e.g. orb-c1-O0
    outdir = args.out / config
    outdir.mkdir(parents=True, exist_ok=True)

    ok = skipped = 0
    for meta_path in sorted(args.src.glob("*.json")):
        meta = json.loads(meta_path.read_text())
        name = meta["name"]
        asm = outdir / (name + ".s")
        try:
            compile_asm(args.src / (name + ".cpp"), asm, args.build, args.opt,
                        flags, args.src.parent)
            text = asm.read_text()
            loc_of_global = {g: l for l, g in meta["globals"].items()}
            threads = {t["idx"]: lift_thread(extract_thread(text, t["idx"]),
                                             loc_of_global, t["idx"])
                       for t in meta["threads"]}
            litmus = build_litmus(name, meta, threads,
                                  "%s, %s" % (args.compiler, args.opt))
        except LiftError as e:
            print("SKIP  %-16s %s" % (name, e), file=sys.stderr)
            skipped += 1
            continue
        (outdir / (name + ".litmus")).write_text(litmus)
        ok += 1
    print("%s: generated %d, skipped %d" % (config, ok, skipped), file=sys.stderr)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
