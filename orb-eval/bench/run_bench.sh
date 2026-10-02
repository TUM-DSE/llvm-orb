#!/usr/bin/env bash
#
# Runs the userspace-rcu benchmark programs of every configuration and records
# their throughput. Run it on the machine being measured, after build.sh.
#
#   ./run_bench.sh                  all configurations, all programs
#   BENCH_REPS=1 BENCH_DURATION=1 ./run_bench.sh      quick check
#   BENCH_RESUME=1 ./run_bench.sh   continue an interrupted measurement: keep
#                                   runtime_raw.tsv, skip the runs it records
#
# Every program is started as
#   <program> <readers> <writers> <seconds> [-a cpu]...
# (the queue and stack programs read the first two numbers as dequeuers and
# enqueuers), and its SUMMARY line is appended to $RESULTS/runtime_raw.tsv.
# Repetitions are the outermost loop and the order of the configurations
# rotates from one repetition to the next, so that slow drift of the machine
# (thermal, other users) does not favour one configuration.

set -euo pipefail
source "$(dirname "$0")/config.sh"

read -r -a configs <<< "${1:+$*}"
[ ${#configs[@]} -gt 0 ] || read -r -a configs <<< "$BENCH_CONFIGS"
read -r -a programs <<< "$BENCH_PROGRAMS"
read -r -a runner <<< "$BENCH_RUNNER"

threads=$((BENCH_READERS + BENCH_WRITERS))
affinity=()
if [ "$BENCH_AFFINITY" = 1 ]; then
  if [ "$threads" -le "$(nproc)" ]; then
    for ((c = 0; c < threads; c++)); do affinity+=(-a "$c"); done
  else
    echo "note: $threads threads but only $(nproc) CPUs, not pinning" >&2
  fi
fi

for cfg in "${configs[@]}"; do
  for p in "${programs[@]}"; do
    [ -x "$WORK/build/$cfg/tests/benchmark/$p" ] \
      || { echo "missing $WORK/build/$cfg/tests/benchmark/$p; run build.sh" >&2; exit 1; }
  done
done

mkdir -p "$RESULTS"
out="$RESULTS/runtime_raw.tsv"
header="# $(date -Is) host=$(hostname) cpus=$(nproc) readers=$BENCH_READERS writers=$BENCH_WRITERS duration=$BENCH_DURATION reps=$BENCH_REPS affinity=$BENCH_AFFINITY"
declare -A done_runs=()
if [ "${BENCH_RESUME:-0}" = 1 ] && [ -s "$out" ]; then
  # A resumed measurement appends; its header line records when it resumed.
  while IFS=$'\t' read -r r p c _; do
    done_runs["$r/$p/$c"]=1
  done < <(grep -v '^#' "$out" | tail -n +2)
  echo "${header/#\# /# resumed } (${#done_runs[@]} runs already recorded)" >> "$out"
else
  { echo "$header"; printf 'rep\tprogram\tconfig\tstatus\twall_s\tsummary\n'; } > "$out"
fi

total=$((BENCH_REPS * ${#programs[@]} * ${#configs[@]}))
todo=$total
for key in "${!done_runs[@]}"; do
  IFS=/ read -r r p c <<< "$key"
  if [ "$r" -le "$BENCH_REPS" ] && [[ " ${programs[*]} " == *" $p "* ]] \
     && [[ " ${configs[*]} " == *" $c "* ]]; then
    todo=$((todo - 1))
  fi
done
echo "$todo runs of ${BENCH_DURATION}s, about $((todo * (BENCH_DURATION + 1) / 60)) minutes; writing $out"
n=0
for ((rep = 1; rep <= BENCH_REPS; rep++)); do
  shift_by=$(( (rep - 1) % ${#configs[@]} ))
  order=("${configs[@]:$shift_by}" "${configs[@]:0:$shift_by}")
  for p in "${programs[@]}"; do
    for cfg in "${order[@]}"; do
      n=$((n + 1))
      [ -z "${done_runs["$rep/$p/$cfg"]:-}" ] || continue
      bin="$WORK/build/$cfg/tests/benchmark/$p"
      start=$(date +%s%N)
      set +e
      line="$(timeout $((BENCH_DURATION * 4 + 60)) "${runner[@]}" "$bin" \
                "$BENCH_READERS" "$BENCH_WRITERS" "$BENCH_DURATION" "${affinity[@]}" 2>/dev/null \
              | grep -m1 '^SUMMARY')"
      status=$?
      set -e
      wall=$(awk -v a="$start" -v b="$(date +%s%N)" 'BEGIN { printf "%.3f", (b - a) / 1e9 }')
      printf '%d\t%s\t%s\t%d\t%s\t%s\n' "$rep" "$p" "$cfg" "$status" "$wall" "$line" >> "$out"
      printf '\r[%d/%d] rep %d %-22s %-10s' "$n" "$total" "$rep" "$p" "$cfg" >&2
    done
  done
done
echo >&2
echo "done: $out"
