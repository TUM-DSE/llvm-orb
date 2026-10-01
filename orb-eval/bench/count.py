#!/usr/bin/env python3
"""Collect the per-translation-unit data of the benchmark builds into CSV files.

For every configuration built by build.sh, and for every object file compiled
in it (the objects listed in its compile_times.csv, so configure's test
programs are excluded):

  primitives.csv   synchronizing instructions in the object file, counted with
                   llvm-objdump -- comparable across all configurations,
                   including stock Clang
  orbstats.csv     the [OrbStats] line of the compiler: memory events of the
                   target program by kind and memory order, including relaxed
                   atomics and plain accesses, which the object file cannot
                   distinguish (Orb configurations only)
  synthesis.csv    the synthesis summary ("done ordered=...") of the Orb passes:
                   required and covered pairs, over-specified pairs,
                   promotions, time
  compile_times.csv wall time of each compilation
  pass_times.csv   MLIR pass timing (-mmlir --mlir-timing), top-level passes

Usage: count.py [--work DIR] [--objdump PATH] [config ...]
"""

import argparse
import csv
import os
import re
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent

KINDS = ["ldar", "ldapr", "stlr", "dmb_full", "dmb_ld", "dmb_st", "rmw_llsc", "rmw_lse"]
LDAR = {"ldar", "ldarb", "ldarh"}
LDAPR = {"ldapr", "ldaprb", "ldaprh", "ldapur", "ldapurb", "ldapurh",
         "ldapursb", "ldapursh", "ldapursw"}
STLR = {"stlr", "stlrb", "stlrh", "stlur", "stlurb", "stlurh"}
LLSC_PREFIX = ("ldxr", "ldaxr", "stxr", "stlxr", "ldxp", "ldaxp", "stxp", "stlxp")
LSE_PREFIX = ("cas", "swp", "ldadd", "ldclr", "ldeor", "ldset", "ldsmax", "ldsmin",
              "ldumax", "ldumin", "stadd", "stclr", "steor", "stset", "stsmax",
              "stsmin", "stumax", "stumin")
INSN_RE = re.compile(r"^\s+([a-z][a-z0-9.]*)(?:\s+(.*))?$")

STATS_RE = re.compile(r"^\[OrbStats\] module=(\S+) (.*)$")
# The synthesis reports promotions and remaining pairs, the naive pass only
# remaining pairs.
SYNTH_RE = re.compile(
    r"^\[(FenceSynthesis|NaiveCppToArm)\] <([^>]*)> done ordered=(\d+)/(\d+)"
    r" overspecified=(\d+)(?: promotions=(\d+))?(?: remaining=(\d+))? t=(\d+)ms")
PASS_RE = re.compile(r"^\s+([0-9.]+) \(\s*[0-9.]+%\)  (\S.*)$")


def classify(mnemonic, operands):
    m = mnemonic
    if m in LDAR:
        return "ldar"
    if m in LDAPR:
        return "ldapr"
    if m in STLR:
        return "stlr"
    if m == "dmb":
        op = (operands or "").strip().lower()
        if op.endswith("ld"):
            return "dmb_ld"
        if op.endswith("st"):
            return "dmb_st"
        return "dmb_full"
    if m == "clrex" or m.startswith(LLSC_PREFIX):
        return "rmw_llsc"
    if m.startswith(LSE_PREFIX):
        return "rmw_lse"
    return None


def count_object(objdump, obj):
    counts = dict.fromkeys(KINDS, 0)
    insns = 0
    out = subprocess.run([objdump, "-d", "--no-show-raw-insn", "--no-leading-addr", str(obj)],
                         capture_output=True, text=True)
    if out.returncode != 0:
        raise RuntimeError("llvm-objdump failed on %s: %s" % (obj, out.stderr.strip()))
    for line in out.stdout.splitlines():
        if not line.startswith(("\t", " ")) or line.rstrip().endswith(":"):
            continue
        m = INSN_RE.match(line)
        if not m:
            continue
        insns += 1
        kind = classify(m.group(1), m.group(2))
        if kind:
            counts[kind] += 1
    return insns, counts


def group_of(obj):
    """Benchmark program, library or directory an object belongs to."""
    p = Path(obj)
    name = p.name[:-2] if p.name.endswith(".o") else p.name
    if p.parts[:2] == ("tests", "benchmark"):
        return "bench", name.split("-")[0]
    if p.parts[:1] == ("src",):
        return "lib", name.split("_la-")[0] if "_la-" in name else name
    return "other", "/".join(p.parts[:-1]) or "."


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--work", type=Path, default=Path(os.environ.get("BENCH_WORK", HERE / "work")))
    ap.add_argument("--objdump", default=os.environ.get("BENCH_OBJDUMP"))
    ap.add_argument("configs", nargs="*")
    args = ap.parse_args()

    work = args.work.resolve()
    results = Path(os.environ.get("BENCH_RESULTS", work / "results"))
    results.mkdir(parents=True, exist_ok=True)
    objdump = args.objdump or str(Path(os.environ.get(
        "ORB_BUILD", HERE.parent.parent / "build")) / "bin" / "llvm-objdump")
    version = subprocess.run([objdump, "--version"], capture_output=True, text=True).stdout
    if "aarch64" not in version:
        sys.exit("%s has no AArch64 disassembler (rebuild it, or set BENCH_OBJDUMP)" % objdump)

    configs = args.configs or sorted(p.name for p in (work / "logs").iterdir() if p.is_dir())

    rows = {k: [] for k in ["primitives", "orbstats", "synthesis", "compile_times", "pass_times"]}
    for cfg in configs:
        log_dir, build_dir = work / "logs" / cfg, work / "build" / cfg
        with open(log_dir / "compile_times.csv") as f:
            units = list(csv.DictReader(f))
        for u in units:
            obj = u["object"]
            kind, group = group_of(obj)
            rows["compile_times"].append({"config": cfg, "object": obj, "kind": kind,
                                          "group": group, "source": u["source"],
                                          "seconds": u["seconds"], "status": u["status"]})
            if (build_dir / obj).exists():
                insns, counts = count_object(objdump, build_dir / obj)
                rows["primitives"].append(dict(config=cfg, object=obj, kind=kind, group=group,
                                               insns=insns, **counts))
            log = log_dir / "tu" / (obj.replace("/", "__") + ".log")
            if not log.exists():
                continue
            report = 0
            for line in log.read_text(errors="replace").splitlines():
                m = STATS_RE.match(line)
                if m:
                    fields = dict(kv.split("=", 1) for kv in m.group(2).split())
                    rows["orbstats"].append(dict(config=cfg, object=obj, kind=kind,
                                                 group=group, module=m.group(1), **fields))
                    continue
                m = SYNTH_RE.match(line)
                if m:
                    rows["synthesis"].append({
                        "config": cfg, "object": obj, "kind": kind, "group": group,
                        "pass": m.group(1), "covered": m.group(3), "required": m.group(4),
                        "overspecified": m.group(5), "promotions": m.group(6) or "",
                        "remaining": m.group(7) or "", "ms": m.group(8)})
                    continue
                if "Execution time report" in line:
                    report += 1
                    continue
                m = PASS_RE.match(line)
                if m and report and not m.group(2).startswith(" "):
                    rows["pass_times"].append({"config": cfg, "object": obj, "kind": kind,
                                               "group": group, "report": report,
                                               "pass": m.group(2).strip(),
                                               "seconds": m.group(1)})
        print("%-10s %4d objects" % (cfg, len(units)), file=sys.stderr)

    for name, data in rows.items():
        path = results / (name + ".csv")
        if not data:
            path.write_text("")
            continue
        fields = list(data[0].keys())
        for r in data:
            fields += [k for k in r if k not in fields]
        with open(path, "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=fields)
            w.writeheader()
            w.writerows(data)
        print("wrote %s (%d rows)" % (path, len(data)), file=sys.stderr)


if __name__ == "__main__":
    main()
