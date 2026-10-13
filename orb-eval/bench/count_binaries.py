#!/usr/bin/env python3
"""Count the synchronizing instructions of every linked benchmark program.

count.py counts per object file. This script counts the programs as they run:
each benchmark binary, which contains the program's own objects and the members
of the static userspace-rcu libraries it links, but not the C library (linked
dynamically). The instruction classes are those of count.py.

Run it in this directory after build.sh, on the machine that holds the builds:

    python3 count_binaries.py                    # clangir naive-orb orb-c1 orb-c20
    python3 count_binaries.py clangir-O2 ...     # other configurations

Writes $RESULTS/binaries.csv (default work/results/binaries.csv).
"""

import csv
import os
import subprocess
import sys
from pathlib import Path

HERE = Path(os.getcwd())
sys.path.insert(0, str(HERE))
from count import KINDS, count_object  # noqa: E402


def bench_programs():
    out = subprocess.run(["bash", "-c", "source ./config.sh >/dev/null; echo $BENCH_PROGRAMS"],
                         capture_output=True, text=True, check=True)
    return out.stdout.split()


def main():
    configs = sys.argv[1:] or ["clangir", "naive-orb", "orb-c1", "orb-c20"]
    work = Path(os.environ.get("BENCH_WORK", HERE / "work"))
    results = Path(os.environ.get("BENCH_RESULTS", work / "results"))
    objdump = os.environ.get("BENCH_OBJDUMP") or str(
        Path(os.environ.get("ORB_BUILD", HERE.parent.parent / "build")) / "bin" / "llvm-objdump")
    rows = []
    for cfg in configs:
        for prog in bench_programs():
            binary = work / "build" / cfg / "tests" / "benchmark" / prog
            # With shared libraries, libtool would leave a wrapper script here
            # and the real binary in .libs; the harness builds static ones.
            if binary.read_bytes()[:2] == b"#!":
                binary = binary.parent / ".libs" / prog
            insns, counts = count_object(objdump, binary)
            rows.append({"config": cfg, "program": prog, "insns": insns, **counts})
        print("%-12s %d programs" % (cfg, len(bench_programs())), file=sys.stderr)
    results.mkdir(parents=True, exist_ok=True)
    out = results / "binaries.csv"
    with open(out, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["config", "program", "insns"] + KINDS)
        w.writeheader()
        w.writerows(rows)
    print("wrote %s (%d rows)" % (out, len(rows)))


if __name__ == "__main__":
    main()
