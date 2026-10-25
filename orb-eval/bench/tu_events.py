#!/usr/bin/env python3
"""Memory events and ordering pairs per translation unit, from the synthesis logs.

The fence synthesis prints, for every translation unit with at least one
required pair, the number of memory events ("n="), of required pairs
("required pairs=") and of pairs the relaxed target program already orders
("pre-ordered="). This script collects them from $WORK/logs/<config>/tu/*.log
into $RESULTS/tu_events.csv. Only the synthesis configurations (orb-c*) are
read: the naive pipeline prints a second "n=" line of its own after the
boundary, for the ordering matrix it builds to log the covered pairs.

    python3 tu_events.py                 # orb-c1 orb-c20
    python3 tu_events.py orb-c20-O2 ...  # other configurations
"""

import csv
import os
import re
import sys
from pathlib import Path

WORK = Path(os.environ.get("BENCH_WORK", Path(__file__).resolve().parent / "work"))
RESULTS = Path(os.environ.get("BENCH_RESULTS", WORK / "results"))

FIELDS = {
    "events": re.compile(r"\[FenceSynthesis\] <[^>]*> n=(\d+)"),
    "required": re.compile(r"\[FenceSynthesis\] <[^>]*> required pairs=(\d+)"),
    "preordered": re.compile(r"\[FenceSynthesis\] <[^>]*> pre-ordered=(\d+)/"),
}


def unit_name(log):
    """src__liburcu_la-urcu.o.log -> src/liburcu_la-urcu.o"""
    return log.name.removesuffix(".log").replace("__", "/")


def main():
    configs = sys.argv[1:] or ["orb-c1", "orb-c20"]
    rows = []
    for cfg in configs:
        for log in sorted((WORK / "logs" / cfg / "tu").glob("*.log")):
            text = log.read_text(errors="replace")
            row = {"config": cfg, "object": unit_name(log)}
            for key, rx in FIELDS.items():
                found = rx.findall(text)
                # One line per module; a translation unit is one module.
                row[key] = int(found[0]) if found else 0
            rows.append(row)
    RESULTS.mkdir(parents=True, exist_ok=True)
    out = RESULTS / "tu_events.csv"
    with open(out, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["config", "object", "events", "required", "preordered"])
        w.writeheader()
        w.writerows(rows)
    print("wrote %s (%d rows)" % (out, len(rows)))


if __name__ == "__main__":
    main()
