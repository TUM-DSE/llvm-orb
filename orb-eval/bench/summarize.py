#!/usr/bin/env python3
"""Summarize the benchmark data collected by count.py and run_bench.sh.

Reads the CSV files in $RESULTS and writes, next to them:

  relaxations.csv          synchronizing instructions per configuration, summed
                           over the library and benchmark objects, plus the
                           change relative to the naive configuration
  relaxations_by_group.csv the same per benchmark program and library
  irstats.csv              the [OrbStats] memory events per configuration
  synthesis_summary.csv    required, covered and
                           over-specified pairs, promotions, time
  compile.csv              compile time per configuration and pipeline stage,
                           total relative to the baseline
  runtime.csv              median throughput per program and configuration,
                           normalized to the baseline, with the geometric mean
  summary.md               all of the above as Markdown tables

The baseline is clangir at -O0. Synchronization is compared at -O0 only: at
higher levels LLVM inlines, deletes and merges code after Orb has made its
decisions, so the object files no longer show those decisions. The counts of
the optimized builds remain in primitives.csv and orbstats.csv.

Usage: summarize.py [--results DIR] [--baseline CONFIG]
"""

import argparse
import csv
import math
import os
import statistics
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
KINDS = ["ldar", "ldapr", "stlr", "dmb_full", "dmb_ld", "dmb_st", "rmw_llsc", "rmw_lse"]
STRONG = ["ldar", "ldapr", "stlr"]
BARRIERS = ["dmb_full", "dmb_ld", "dmb_st"]
IRKEYS = ["ld_rlx", "ld_acqpc", "ld_acq", "st_rlx", "st_rel", "fence_rlx", "fence_acq",
          "fence_rel", "fence_acqrel", "ptr_ld", "ptr_st", "other"]
# Top-level MLIR passes grouped into pipeline stages for the compile-time plot.
STAGES = [
    ("cir-to-cir", {"CIRCanonicalize", "CIRSimplify", "IdiomRecognizer", "TargetLowering",
                    "CXXABILowering", "LoweringPrepare"}),
    ("cir-to-cf/ptr", {"HoistAllocas", "CIRFlattenCFG", "CIREHABILowering", "GotoSolver",
                       "CIRToCF", "CIRToPtr"}),
    ("cir-to-cpp-atomic", {"CIRToCppAtomic"}),
    ("order-analysis", {"OrderAnalysisPass"}),
    ("boundary", {"ConvertCppAtomicToArmAtomicPass", "ConvertCppAtomicToArmAtomicNaivePass"}),
    ("fence-synthesis", {"FenceSynthesisPass"}),
    ("to-llvm", {"cir::direct::ConvertCIRToLLVMPass", "ConvertArmAtomicToLLVMPass",
                 "ConvertToLLVMPass", "CIROrbCleanup"}),
]


def read(path):
    if not path.exists() or path.stat().st_size == 0:
        return []
    with open(path) as f:
        return list(csv.DictReader(f))


def write(path, rows, fields):
    with open(path, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields, extrasaction="ignore")
        w.writeheader()
        w.writerows(rows)


def md_table(rows, fields, fmt=None):
    fmt = fmt or {}
    out = ["| " + " | ".join(fields) + " |", "|" + "---|" * len(fields)]
    for r in rows:
        out.append("| " + " | ".join(fmt.get(k, "{}").format(r.get(k, "")) for k in fields) + " |")
    return "\n".join(out)


def split_config(cfg):
    """("orb-c20", "-O2") for "orb-c20-O2"; unsuffixed configurations are -O0."""
    base, sep, level = cfg.rpartition("-O")
    if sep and len(level) == 1 and level in "0123sz":
        return base, "-O" + level
    return cfg, "-O0"


def config_order(configs):
    rank = {"clang": 0, "clangir": 1, "naive-orb": 2}
    def key(c):
        base, level = split_config(c)
        return (level, rank.get(base, 3), base)
    return sorted(configs, key=key)


def at_O0(rows):
    return [r for r in rows if split_config(r["config"])[1] == "-O0"]


def relaxations(prim, baseline):
    """Sum synchronizing instructions over library and benchmark objects."""
    tot, by_group = defaultdict(lambda: defaultdict(int)), defaultdict(lambda: defaultdict(int))
    for r in prim:
        if r["kind"] not in ("lib", "bench"):
            continue
        for k in KINDS:
            tot[r["config"]][k] += int(r[k])
            by_group[(r["kind"], r["group"], r["config"])][k] += int(r[k])
    rows = []
    for cfg in config_order(tot):
        t = tot[cfg]
        row = {"config": cfg, **t, "strong": sum(t[k] for k in STRONG),
               "barriers": sum(t[k] for k in BARRIERS)}
        row["sync"] = row["strong"] + row["barriers"]
        rows.append(row)
    base = next((r for r in rows if r["config"] == baseline), None)
    naive = next((r for r in rows if r["config"] == "naive-orb"), None)
    for r in rows:
        r["sync_vs_" + baseline] = "%.3f" % (r["sync"] / base["sync"]) if base and base["sync"] else ""
        if naive and r["config"].startswith("orb"):
            r["relaxed_accesses_vs_naive"] = naive["strong"] - r["strong"]
            r["barrier_change_vs_naive"] = r["barriers"] - naive["barriers"]
    group_rows = []
    for (kind, group, cfg), t in sorted(by_group.items()):
        row = {"kind": kind, "group": group, "config": cfg, **t,
               "strong": sum(t[k] for k in STRONG), "barriers": sum(t[k] for k in BARRIERS)}
        group_rows.append(row)
    return rows, group_rows


def irstats(stats):
    tot = defaultdict(lambda: defaultdict(int))
    for r in stats:
        for k in IRKEYS:
            tot[r["config"]][k] += int(r.get(k) or 0)
    rows = [{"config": c, **tot[c]} for c in config_order(tot)]
    naive = tot.get("naive-orb")
    for r in rows:
        r["strong"] = r["ld_acqpc"] + r["ld_acq"] + r["st_rel"]
        r["barriers"] = r["fence_acq"] + r["fence_rel"] + r["fence_acqrel"]
        if naive and r["config"] != "naive-orb":
            r["relaxed_accesses_vs_naive"] = (naive["ld_acqpc"] + naive["ld_acq"]
                                              + naive["st_rel"]) - r["strong"]
    return rows


def synthesis(synth):
    tot = defaultdict(lambda: defaultdict(int))
    for r in synth:
        t = tot[r["config"]]
        t["modules"] += 1
        for k in ("required", "covered", "overspecified", "promotions", "remaining", "ms"):
            t[k] += int(r[k] or 0)
    return [{"config": c, **tot[c]} for c in config_order(tot)]


def compile_times(ct, passes, baseline):
    per_cfg = defaultdict(list)
    for r in ct:
        if r["status"] == "0":
            per_cfg[r["config"]].append(float(r["seconds"]))
    stage = defaultdict(lambda: defaultdict(float))
    for r in passes:
        if r["pass"] in ("Total", "Rest"):
            continue
        for name, members in STAGES:
            if r["pass"] in members:
                stage[r["config"]][name] += float(r["seconds"])
                break
        else:
            stage[r["config"]]["other-mlir"] += float(r["seconds"])
    mlir_total = defaultdict(float)
    for r in passes:
        if r["pass"] == "Total":
            mlir_total[r["config"]] += float(r["seconds"])
    rows = []
    for cfg in config_order(per_cfg):
        times = per_cfg[cfg]
        row = {"config": cfg, "units": len(times), "total_s": round(sum(times), 2),
               "median_unit_s": round(statistics.median(times), 3) if times else ""}
        for name, _ in STAGES:
            row[name + "_s"] = round(stage[cfg].get(name, 0.0), 2)
        row["other-mlir_s"] = round(stage[cfg].get("other-mlir", 0.0), 2)
        row["outside-mlir_s"] = round(sum(times) - mlir_total[cfg], 2) if cfg in mlir_total else ""
        rows.append(row)
    base = next((r for r in rows if r["config"] == baseline), None)
    for r in rows:
        r["total_vs_" + baseline] = round(r["total_s"] / base["total_s"], 2) if base and base["total_s"] else ""
    return rows


def runtime(tsv, baseline):
    if not tsv.exists():
        return [], []
    samples = defaultdict(lambda: defaultdict(list))
    with open(tsv) as f:
        lines = [l for l in f if not l.startswith("#")]
    failed = defaultdict(int)
    for r in csv.DictReader(lines, delimiter="\t"):
        tok = (r.get("summary") or "").split()
        if r["status"] != "0" or len(tok) < 3 or tok[0] != "SUMMARY":
            failed[(r["program"], r["config"])] += 1
            continue
        kv = dict(zip(tok[2::2], tok[3::2]))
        dur = float(kv.get("testdur", 0)) or 1.0
        rd = kv.get("nr_reads", kv.get("nr_dequeues"))
        wr = kv.get("nr_writes", kv.get("nr_enqueues"))
        if rd is None or wr is None:
            continue
        samples[(r["program"], r["config"])]["read"].append(int(rd) / dur)
        samples[(r["program"], r["config"])]["write"].append(int(wr) / dur)
    programs = sorted({p for p, _ in samples})
    configs = config_order({c for _, c in samples})
    # A run that crashed or timed out has no throughput. The geometric means
    # only use programs in which every configuration passed every repetition,
    # so that all configurations are averaged over the same programs.
    common = [p for p in programs
              if all((p, c) in samples and not failed.get((p, c)) for c in configs)]
    excluded = sorted({p for p, _ in failed} | (set(programs) - set(common)))
    rows = []
    for p in programs:
        base = samples.get((p, baseline))
        for c in configs:
            s = samples.get((p, c))
            if not s:
                continue
            row = {"program": p, "config": c, "reps": len(s["read"]),
                   "failed": failed.get((p, c), 0)}
            for side in ("read", "write"):
                med = statistics.median(s[side])
                row[side + "_ops_s"] = round(med, 1)
                row[side + "_rsd"] = round(statistics.pstdev(s[side]) / med, 4) if med else ""
                bmed = statistics.median(base[side]) if base else 0
                row[side + "_norm"] = round(med / bmed, 4) if bmed else ""
            rows.append(row)
    geo = []
    for c in configs:
        g = {"config": c}
        for side in ("read", "write"):
            vals = [r[side + "_norm"] for r in rows
                    if r["config"] == c and r["program"] in common and r[side + "_norm"]]
            g[side + "_geomean"] = round(math.exp(sum(map(math.log, vals)) / len(vals)), 4) if vals else ""
            g["programs"] = len(vals)
        geo.append(g)
    failures = [{"program": p, "config": c, "failed": n} for (p, c), n in sorted(failed.items())]
    return rows, geo, failures, excluded


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    work = Path(os.environ.get("BENCH_WORK", HERE / "work"))
    ap.add_argument("--results", type=Path, default=Path(os.environ.get("BENCH_RESULTS", work / "results")))
    ap.add_argument("--baseline", default="clangir")
    args = ap.parse_args()
    R = args.results

    md = ["# Orb benchmark results", ""]
    rel, rel_group = relaxations(at_O0(read(R / "primitives.csv")), args.baseline)
    if rel:
        f = ["config"] + KINDS + ["strong", "barriers", "sync", "sync_vs_" + args.baseline,
                                  "relaxed_accesses_vs_naive", "barrier_change_vs_naive"]
        write(R / "relaxations.csv", rel, f)
        write(R / "relaxations_by_group.csv", rel_group,
              ["kind", "group", "config"] + KINDS + ["strong", "barriers"])
        md += ["## Synchronizing instructions (library and benchmark objects, -O0)", "",
               "strong = LDAR + LDAPR + STLR; barriers = DMB; read-modify-writes bypass Orb. "
               "Compared at -O0 only: at higher levels LLVM inlines, deletes and merges code "
               "after Orb has made its decisions.", "",
               md_table(rel, f), ""]
    ir = irstats(at_O0(read(R / "orbstats.csv")))
    if ir:
        f = ["config"] + IRKEYS + ["strong", "barriers", "relaxed_accesses_vs_naive"]
        write(R / "irstats.csv", ir, f)
        md += ["## Memory events after the boundary ([OrbStats], all translation units, -O0)", "",
               md_table(ir, f), ""]
    syn = synthesis(at_O0(read(R / "synthesis.csv")))
    if syn:
        f = ["config", "modules", "required", "covered", "overspecified", "promotions",
             "remaining", "ms"]
        write(R / "synthesis_summary.csv", syn, f)
        md += ["## Ordering (all translation units, -O0)", "",
               "For naive-orb, `ms` is the time of the verification that builds the target "
               "ordering matrix after the naive conversion; it is not part of the mapping.", "",
               md_table(syn, f), ""]
    comp = compile_times(read(R / "compile_times.csv"), read(R / "pass_times.csv"), args.baseline)
    if comp:
        f = (["config", "units", "total_s", "total_vs_" + args.baseline, "median_unit_s"]
             + [n + "_s" for n, _ in STAGES]
             + ["other-mlir_s", "outside-mlir_s"])
        write(R / "compile.csv", comp, f)
        md += ["## Compile time (seconds, all translation units)", "",
               "outside-mlir = front end and LLVM code generation. For naive-orb, "
               "order-analysis and most of `boundary` are the verification above.", "",
               md_table(comp, f), ""]
    rows, geo, failures, excluded = runtime(R / "runtime_raw.tsv", args.baseline)
    if rows or failures:
        f = ["program", "config", "reps", "failed", "read_ops_s", "read_rsd", "read_norm",
             "write_ops_s", "write_rsd", "write_norm"]
        write(R / "runtime.csv", rows, f)
        write(R / "runtime_geomean.csv", geo, ["config", "programs", "read_geomean", "write_geomean"])
        write(R / "runtime_failures.csv", failures, ["program", "config", "failed"])
        md += ["## Runtime: geometric mean of throughput relative to %s (%s)"
               % (args.baseline, split_config(args.baseline)[1]), "",
               "Over the programs in which every configuration passed every repetition"
               + (" (excluded: %s)." % ", ".join(excluded) if excluded else "."), "",
               md_table(geo, ["config", "programs", "read_geomean", "write_geomean"]), ""]
        if failures:
            md += ["## Failed runs (crash, assertion or timeout; no throughput)", "",
                   md_table(failures, ["program", "config", "failed"]), ""]
        md += ["## Runtime per program (median throughput, ops/s)", "", md_table(rows, f), ""]
    (R / "summary.md").write_text("\n".join(md) + "\n")
    print("wrote %s" % (R / "summary.md"))


if __name__ == "__main__":
    main()
