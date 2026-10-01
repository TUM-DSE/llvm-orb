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
# The hand-written shapes in tests/ are the ones that do exercise it, and all
# of them move. Exits non-zero only if *no* weakening has any effect, which
# would mean the suite cannot fail at all.

set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
HERD="${HERD7:-$(command -v herd7 || echo /scratch/$USER/.local/bin/herd7)}"
# Default: every synthesis configuration that was generated (out/orb-c*).
if [ $# -gt 0 ]; then DIRS=("$@"); else DIRS=("$HERE"/out/orb-c*); fi
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if [ ! -x "$HERD" ]; then echo "herd7 not found (set HERD7=)" >&2; exit 2; fi

verdict() {
  local out
  out="$("$HERD" -model aarch64.cat "$1" 2>/dev/null | grep -m1 '^Observation')" || true
  if [ -z "$out" ]; then echo "ERROR"; else echo "$out" | awk '{print $3}'; fi
}

printf "%-9s %-18s %-15s %-10s %-12s %s\n" CONFIG TEST WEAKENING BEFORE AFTER RESULT
rc=0; checked=0; effective=0; inert=0

files=()
for d in "${DIRS[@]}"; do files+=("$d"/*.litmus); done
for f in "${files[@]}"; do
  [ -e "$f" ] || continue
  cfg="$(basename "$(dirname "$f")")"
  name="$(basename "$f" .litmus)"
  before="$(verdict "$f")"
  [ "$before" = Never ] || continue      # only a Never can be broken into a Sometimes

  # Each weakening removes one kind of ordering mechanism everywhere in the
  # test: barriers, acquire loads (LDAR, LDAPR) or store-releases (STLR).
  for weakening in drop-dmb downgrade-ldar downgrade-ldapr downgrade-stlr; do
    case "$weakening" in
      drop-dmb)
        grep -q 'dmb' "$f" || continue
        sed 's/\bdmb  *ish[a-z]*\b/nop/g' "$f" > "$WORK/$name.litmus" ;;
      downgrade-ldar)
        grep -qw 'ldar' "$f" || continue
        sed 's/\bldar\b/ldr/g' "$f" > "$WORK/$name.litmus" ;;
      downgrade-ldapr)
        grep -qw 'ldapr' "$f" || continue
        sed 's/\bldapr\b/ldr/g' "$f" > "$WORK/$name.litmus" ;;
      downgrade-stlr)
        grep -qw 'stlr' "$f" || continue
        sed 's/\bstlr\b/str/g' "$f" > "$WORK/$name.litmus" ;;
    esac

    after="$(verdict "$WORK/$name.litmus")"
    checked=$((checked+1))
    if [ "$after" = ERROR ]; then
      result="ERROR"; rc=1
    elif [ "$after" != Never ]; then
      result="ordering-dependent (this green result means something)"
      effective=$((effective+1))
    else
      result="not ordering-dependent (forbidden for another reason)"
      inert=$((inert+1))
    fi
    printf "%-9s %-18s %-15s %-10s %-12s %s\n" "$cfg" "$name" "$weakening" "$before" "$after" "$result"
  done
done

echo "----------------------------------------------------------------------"
echo "weakenings checked=$checked  ordering-dependent=$effective  inert=$inert"
[ "$checked" -eq 0 ] && { echo "no weakenings applied -- control proves nothing" >&2; exit 2; }
if [ "$effective" -eq 0 ]; then
  echo "NO weakening changed any verdict -- the suite cannot fail; check the" >&2
  echo "generator is not dropping ordering instructions and that aarch64.cat" >&2
  echo "is the model actually being used." >&2
  exit 1
fi
exit $rc
