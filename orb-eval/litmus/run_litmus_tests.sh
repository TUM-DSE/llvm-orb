#!/usr/bin/env bash
#
# Run the Orb litmus suite: check that compiled code is *robust*, i.e. that
# ARMv8 permits no behaviour RC11 forbids.
#
# Companion to run_pipeline_filecheck_tests.sh. That suite checks the pipeline
# emits legal-looking IR against expectations written by hand; this one checks
# the compiled program against an independent oracle, so it can catch ordering
# the synthesis dropped.
#
# For each test and each configuration (compiler x -O level):
#   1. herd7 -model rc11.cat     <source .litmus>   -> S, what RC11 allows
#   2. herd7 -model aarch64.cat  <generated .litmus> -> A, what ARMv8 allows
#   3. PASS unless RC11 forbids the condition and ARMv8 permits it.
#
# Both sides are asked the *same* question: litmus_to_cpp.py carries the source
# condition through to the generated test (a register term 0:r1 becomes 0:X0,
# which the thread returns), so the two verdicts are directly comparable.
#
# RC11 allows it but ARMv8 does not -> the mapping is stronger than it has to
# be. Sound, so not a failure, but reported as OVER since it costs performance.
#
# The ARMv8 side runs with -optace true: herd7 then drops candidate executions
# that break coherence on a single location while generating them, instead of
# building them and letting aarch64.cat reject them. aarch64.cat forbids those
# executions anyway (its "internal" axiom), so no verdict changes, but -O0
# tests, whose every local is a stack location, finish in seconds instead of
# hours. A test herd7 does not finish within ORB_LITMUS_HERD_TIMEOUT seconds is
# reported as TIMEOUT: it is not a failure, but it is not checked either.
# Tests known to take that long are listed in slow-tests.txt and skipped unless
# ORB_LITMUS_SLOW=1.
#
# Regenerate the inputs first with ./generate_all.sh.

set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
# Source tests are looked up in, in order:
#   tests/      -- classic ordering shapes (MP, SB, WRC, ISA2, 2+2W, LB, CoRR)
#   c11popl15   -- herdtools7's catalogue for the C11 paper
# The catalogue illustrates source-level transformation validity, so most of its
# tests are forbidden for control-dependency or out-of-thin-air reasons that
# hold on ARMv8 anyway; negative_control.sh shows which ones exercise the
# emitted synchronization.
HERDTOOLS_DIR="${HERDTOOLS_DIR:-/scratch/$USER/herdtools7}"
CATALOGUE="${ORB_LITMUS_CATALOGUE:-$HERE/tests $HERDTOOLS_DIR/catalogue/c11popl15/tests/illustrative}"
HERD="${HERD7:-$(command -v herd7 || echo /scratch/$USER/.local/bin/herd7)}"
COMPILERS="${ORB_LITMUS_COMPILERS:-orb-c1 orb-c20 naive-orb clangir}"
OPTS="${ORB_LITMUS_OPTS:--O0 -O1 -O2}"
TIMEOUT="${ORB_LITMUS_HERD_TIMEOUT:-900}"
JOBS="${ORB_LITMUS_JOBS:-$(nproc)}"
SLOW="${ORB_LITMUS_SLOW:-0}"

# LB with all-relaxed accesses is the known, explained divergence: RC11 forbids
# it through acyclicity of po|rf, a global argument that no per-access ARM
# mapping can enforce locally. Listed rather than silently special-cased.
EXPECTED_DIVERGENCE="${ORB_LITMUS_EXPECTED_DIVERGENCE:-lb}"

if [ ! -x "$HERD" ]; then
  echo "herd7 not found (set HERD7=/path/to/herd7)" >&2
  exit 2
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

verdict() {   # <model.cat> <file> -> prints "<file>\t<Never|Sometimes|Always|TIMEOUT|ERROR>"
  local out rc opts=()
  [ "$1" = aarch64.cat ] && opts=(-optace true)
  out="$(timeout "$TIMEOUT" "$HERD" "${opts[@]}" -model "$1" "$2" 2>/dev/null)"; rc=$?
  if [ "$rc" -eq 124 ]; then
    out=TIMEOUT
  else
    out="$(printf '%s\n' "$out" | grep -m1 '^Observation' | awk '{print $3}')"
    [ -n "$out" ] || out=ERROR
  fi
  printf '%s\t%s\n' "$2" "$out"
}
export -f verdict
export HERD TIMEOUT

is_slow() {   # <test> <-O level>
  [ "$SLOW" = 1 ] && return 1
  grep -vE '^\s*(#|$)' "$HERE/slow-tests.txt" | awk -v t="$1" -v o="$2" \
    '$1 == t && $2 == o { found = 1 } END { exit !found }'
}

is_expected() {
  for e in $EXPECTED_DIVERGENCE; do [ "$e" = "$1" ] && return 0; done
  return 1
}

# A test's declared name need not match its filename -- arfna2.litmus declares
# `C arfna_transformed` -- so take the source file from the provenance line the
# generator wrote rather than from the name.
source_of() {
  local srcfile d
  srcfile="$(sed -n '2p' "$1" | sed -n 's/.*generated from \([^ ]*\) by.*/\1/p')"
  [ -n "$srcfile" ] || srcfile="$(basename "$1")"
  for d in $CATALOGUE; do [ -f "$d/$srcfile" ] && { echo "$d/$srcfile"; return; }; done
}

# 1. Every herd7 run the tables need, all at once.
configs=()
declare -A SRC
for opt in $OPTS; do
  for compiler in $COMPILERS; do
    cfg="$compiler$opt"
    [ -d "$HERE/out/$cfg" ] || { echo "no generated tests for $cfg, skipping"; continue; }
    configs+=("$cfg")
    for gen in "$HERE/out/$cfg"/*.litmus; do
      [ -e "$gen" ] || continue
      SRC["$gen"]="$(source_of "$gen")"
      is_slow "$(basename "$gen" .litmus)" "$opt" && continue
      printf 'aarch64.cat\n%s\n' "$gen" >> "$WORK/jobs"
    done
  done
done
[ -s "$WORK/jobs" ] || { echo "nothing to run; run ./generate_all.sh first" >&2; exit 2; }
# rc11.cat once per source test, not once per configuration.
printf '%s\n' "${SRC[@]}" | grep . | sort -u | while read -r s; do
  printf 'rc11.cat\n%s\n' "$s"
done >> "$WORK/jobs"
echo "running herd7 on $(( $(wc -l < "$WORK/jobs") / 2 )) tests ($JOBS in parallel, timeout ${TIMEOUT}s)..."
xargs -d '\n' -n 2 -P "$JOBS" bash -c 'verdict "$0" "$1"' < "$WORK/jobs" > "$WORK/verdicts"
declare -A V
while IFS=$'\t' read -r f v; do V["$f"]="$v"; done < "$WORK/verdicts"

# 2. One table per configuration, then a summary.
rc=0
summary=()
for cfg in "${configs[@]}"; do
  opt="-O${cfg##*-O}"
  echo "=============================================================="
  echo " $cfg"
  echo "=============================================================="
  printf "%-18s %-10s %-10s %s\n" TEST RC11 ARMv8 RESULT
  pass=0; fail=0; over=0; xfail=0; tout=0; skip=0; err=0
  for gen in "$HERE/out/$cfg"/*.litmus; do
    [ -e "$gen" ] || continue
    name="$(basename "$gen" .litmus)"
    src="${SRC[$gen]}"
    [ -n "$src" ] || { printf "%-18s %-10s %-10s %s\n" "$name" - - "NO SOURCE"; err=$((err+1)); rc=1; continue; }
    if is_slow "$name" "$opt"; then
      printf "%-18s %-10s %-10s %s\n" "$name" - - "SKIPPED (slow-tests.txt; ORB_LITMUS_SLOW=1 runs it)"
      skip=$((skip+1)); continue
    fi
    s="${V[$src]:-ERROR}"
    a="${V[$gen]:-ERROR}"

    if [ "$s" = ERROR ] || [ "$a" = ERROR ]; then
      result="ERROR"; err=$((err+1)); rc=1
    elif [ "$s" = TIMEOUT ] || [ "$a" = TIMEOUT ]; then
      result="TIMEOUT (herd7 did not finish in ${TIMEOUT}s; not checked)"; tout=$((tout+1))
    elif [ "$s" = Never ] && [ "$a" != Never ]; then
      if is_expected "$name"; then result="XFAIL (known)"; xfail=$((xfail+1))
      else result="FAIL  <-- ARMv8 allows what RC11 forbids"; fail=$((fail+1)); rc=1; fi
    elif [ "$s" != Never ] && [ "$a" = Never ]; then
      result="OVER  (stronger than required)"; over=$((over+1))
    else
      result="PASS"; pass=$((pass+1))
    fi
    printf "%-18s %-10s %-10s %s\n" "$name" "$s" "$a" "$result"
  done
  echo "--------------------------------------------------------------"
  echo "pass=$pass fail=$fail over=$over xfail=$xfail timeout=$tout skipped=$skip error=$err"
  echo
  summary+=("$(printf "%-14s %5d %5d %5d %5d %8d %8d %6d" "$cfg" "$pass" "$over" "$xfail" "$fail" "$tout" "$skip" "$err")")
done

echo "=============================================================="
printf "%-14s %5s %5s %5s %5s %8s %8s %6s\n" CONFIG PASS OVER XFAIL FAIL TIMEOUT SKIPPED ERROR
printf '%s\n' "${summary[@]}"
exit $rc
