#!/usr/bin/env bash
#
# Runs the whole benchmark: toolchain, builds, instruction counts, runtime,
# summary. Steps can be selected:
#
#   ./run_all.sh                          all steps
#   ./run_all.sh build count summarize    no runtime measurement
#
# Settings come from config.sh and can be overridden from the environment.

set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/config.sh"

steps=("$@")
[ ${#steps[@]} -gt 0 ] || steps=(toolchain build count bench summarize)

echo "Orb build:      $ORB_BUILD ($("$ORB_BUILD/bin/clang" --version | head -1))"
echo "work dir:       $WORK"
echo "configurations: $BENCH_CONFIGS"
echo "flags:          $BENCH_OPT $BENCH_CPU_FLAGS${BENCH_CROSS:+ (cross: $BENCH_CROSS)}"

for step in "${steps[@]}"; do
  echo "=== $step"
  case "$step" in
    toolchain) "$HERE/make-toolchain.sh" ;;
    build)     "$HERE/build.sh" ;;
    count)     python3 "$HERE/count.py" --work "$WORK" ;;
    bench)     "$HERE/run_bench.sh" ;;
    summarize) python3 "$HERE/summarize.py" --results "$RESULTS" ;;
    *) echo "unknown step $step (toolchain, build, count, bench, summarize)" >&2; exit 2 ;;
  esac
done
