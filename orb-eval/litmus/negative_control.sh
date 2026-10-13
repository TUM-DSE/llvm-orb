#!/usr/bin/env bash
#
# Negative control for the litmus suite.
#
# A differential suite can pass vacuously: if the generator dropped the
# ordering instructions, or spliced the assembly wrongly, or herd7 were reading
# a model that forbids everything, every test would still report Never == Never
# and the run would look green. This script checks the suite can actually fail.
#
# For each test whose generated code carries an ordering mechanism, weaken that
# mechanism -- delete the barrier, or downgrade the acquire load to a plain one
# -- and re-ask herd7. If the verdict flips from Never to Sometimes, that test
# really is held by the ordering Orb emitted, and a green result for it means
# something.
#
# A test whose verdict does not move is not a failure: it forbids its outcome
# for a reason other than the barrier. Most of the c11popl15 catalogue is like
# this -- its tests illustrate which *source-level* transformations are valid,
# and their outcomes are ruled out by control dependencies or by the absence of
# out-of-thin-air values, which hold on ARMv8 whatever the mapping emits. c is
# the clearest case: each thread only reaches its store if the other thread
# already stored, so neither ever does. Such tests still check the compiler
# introduces no new behaviour; they just do not exercise fence synthesis. They
# are counted separately, as coverage rather than as an error.
#
# The ordering shapes in tests/ all exercise it. Exits non-zero only if *no*
# weakening has any effect, which would mean the suite cannot fail at all.
#
# herd7 runs as in run_litmus_tests.sh: -optace true, in parallel, and a test
# that does not finish within ORB_LITMUS_HERD_TIMEOUT seconds is left out, as
# are the tests in slow-tests.txt unless ORB_LITMUS_SLOW=1.

set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
HERD="${HERD7:-$(command -v herd7 || echo /scratch/$USER/.local/bin/herd7)}"
TIMEOUT="${ORB_LITMUS_HERD_TIMEOUT:-900}"
JOBS="${ORB_LITMUS_JOBS:-$(nproc)}"
# Default: every synthesis configuration that was generated (out/orb-c*-O*).
if [ $# -gt 0 ]; then DIRS=("$@"); else DIRS=("$HERE"/out/orb-c*); fi
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if [ ! -x "$HERD" ]; then echo "herd7 not found (set HERD7=)" >&2; exit 2; fi

verdict() {   # <file> -> prints "<file>\t<verdict>"
  local out rc
  out="$(timeout "$TIMEOUT" "$HERD" -optace true -model aarch64.cat "$1" 2>/dev/null)"; rc=$?
  if [ "$rc" -eq 124 ]; then
    out=TIMEOUT
  else
    out="$(printf '%s\n' "$out" | grep -m1 '^Observation' | awk '{print $3}')"
    [ -n "$out" ] || out=ERROR
  fi
  printf '%s\t%s\n' "$1" "$out"
}
export -f verdict
export HERD TIMEOUT

run_all() {   # file list on stdin -> verdict lines on stdout
  xargs -d '\n' -n 1 -P "$JOBS" bash -c 'verdict "$0"'
}

is_slow() {   # <generated .litmus> -> listed in slow-tests.txt for its -O level
  [ "${ORB_LITMUS_SLOW:-0}" = 1 ] && return 1
  local name opt
  name="$(basename "$1" .litmus)"
  opt="-O$(basename "$(dirname "$1")" | sed 's/.*-O//')"
  grep -vE '^\s*(#|$)' "$HERE/slow-tests.txt" | awk -v t="$name" -v o="$opt" \
    '$1 == t && $2 == o { found = 1 } END { exit !found }'
}

# 1. The unweakened verdicts. Only a Never can be broken into a Sometimes.
files=()
for d in "${DIRS[@]}"; do
  for f in "$d"/*.litmus; do
    [ -e "$f" ] || continue
    is_slow "$f" || files+=("$f")
  done
done
printf '%s\n' "${files[@]}" | run_all > "$WORK/before"
declare -A BEFORE
while IFS=$'\t' read -r f v; do BEFORE["$f"]="$v"; done < "$WORK/before"

# 2. Each weakening removes one kind of ordering mechanism everywhere in the
#    test: barriers, acquire loads (LDAR, LDAPR) or store-releases (STLR).
weaken() {   # <weakening> <file> -> weakened test on stdout, or nothing
  case "$1" in
    drop-dmb)        grep -q 'dmb' "$2"    && sed 's/\bdmb  *ish[a-z]*\b/nop/g' "$2" ;;
    downgrade-ldar)  grep -qw 'ldar' "$2"  && sed 's/\bldar\b/ldr/g' "$2" ;;
    downgrade-ldapr) grep -qw 'ldapr' "$2" && sed 's/\bldapr\b/ldr/g' "$2" ;;
    downgrade-stlr)  grep -qw 'stlr' "$2"  && sed 's/\bstlr\b/str/g' "$2" ;;
  esac
}
: > "$WORK/weakened"
declare -A ORIGIN
for f in "${!BEFORE[@]}"; do
  [ "${BEFORE[$f]}" = Never ] || continue
  cfg="$(basename "$(dirname "$f")")"
  name="$(basename "$f" .litmus)"
  for weakening in drop-dmb downgrade-ldar downgrade-ldapr downgrade-stlr; do
    w="$WORK/$cfg/$name.$weakening.litmus"
    mkdir -p "$WORK/$cfg"
    weaken "$weakening" "$f" > "$w" || { rm -f "$w"; continue; }
    [ -s "$w" ] || { rm -f "$w"; continue; }
    ORIGIN["$w"]="$cfg $name $weakening"
    echo "$w" >> "$WORK/weakened"
  done
done
run_all < "$WORK/weakened" > "$WORK/after"

# 3. Report, sorted by configuration, test and weakening.
while IFS=$'\t' read -r w after; do
  [ "$after" = TIMEOUT ] && continue
  read -r cfg name weakening <<< "${ORIGIN[$w]}"
  if [ "$after" = ERROR ]; then
    result="ERROR"
  elif [ "$after" != Never ]; then
    result="ordering-dependent (this green result means something)"
  else
    result="not ordering-dependent (forbidden for another reason)"
  fi
  printf "%-12s %-18s %-15s %-10s %-12s %s\n" "$cfg" "$name" "$weakening" Never "$after" "$result"
done < "$WORK/after" | sort -k1,1 -k2,2 -k3,3 > "$WORK/report"
printf "%-12s %-18s %-15s %-10s %-12s %s\n" CONFIG TEST WEAKENING BEFORE AFTER RESULT
cat "$WORK/report"
checked="$(wc -l < "$WORK/report")"
effective="$(grep -c 'ordering-dependent (this' "$WORK/report")"
inert="$(grep -c 'not ordering-dependent' "$WORK/report")"
errors="$(grep -c ' ERROR$' "$WORK/report")"
skipped_before="$(grep -c $'\tTIMEOUT$' "$WORK/before")"
skipped_after="$(grep -c $'\tTIMEOUT$' "$WORK/after")"

echo "----------------------------------------------------------------------"
echo "weakenings checked=$checked  ordering-dependent=$effective  inert=$inert  error=$errors"
echo "left out after a herd7 timeout: $skipped_before tests, $skipped_after weakened tests"
[ "$checked" -eq 0 ] && { echo "no weakenings applied -- control proves nothing" >&2; exit 2; }
if [ "$effective" -eq 0 ]; then
  echo "NO weakening changed any verdict -- the suite cannot fail; check the" >&2
  echo "generator is not dropping ordering instructions and that aarch64.cat" >&2
  echo "is the model actually being used." >&2
  exit 1
fi
[ "$errors" -eq 0 ] || exit 1
exit 0
