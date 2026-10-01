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
# For each test:
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
# Regenerate the inputs first:
#   python3 litmus_to_cpp.py <catalogue>/*.litmus -o src
#   python3 generate_litmus.py --src src --out out --build <build> --compiler orb

set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
# Two corpora, searched in order:
#   tests/      -- hand-written ordering shapes (MP, SB, WRC, ISA2, 2+2W, ...)
#   c11popl15   -- herdtools7's catalogue for the RC11 paper
# The catalogue illustrates source-level transformation validity, so most of its
# tests are forbidden for control-dependency or out-of-thin-air reasons that
# hold on ARMv8 anyway; negative_control.sh shows they do not exercise fence
# synthesis. The hand-written shapes are the ones that do.
HERDTOOLS_DIR="${HERDTOOLS_DIR:-/scratch/$USER/herdtools7}"
CATALOGUE="${ORB_LITMUS_CATALOGUE:-$HERE/tests $HERDTOOLS_DIR/catalogue/c11popl15/tests/illustrative}"
HERD="${HERD7:-$(command -v herd7 || echo /scratch/$USER/.local/bin/herd7)}"
COMPILERS="${ORB_LITMUS_COMPILERS:-orb-c1 orb-c20 naive-orb clangir}"

# LB with all-relaxed accesses is the known, explained divergence: RC11 forbids
# it through acyclicity of po|rf, a global argument that no per-access ARM
# mapping can enforce locally. Listed rather than silently special-cased.
EXPECTED_DIVERGENCE="${ORB_LITMUS_EXPECTED_DIVERGENCE:-lb}"

if [ ! -x "$HERD" ]; then
  echo "herd7 not found (set HERD7=/path/to/herd7)" >&2
  exit 2
fi

verdict() {   # <model.cat> <file> -> "Never" | "Sometimes" | "Always" | "ERROR"
  local out
  out="$("$HERD" -model "$1" "$2" 2>/dev/null | grep -m1 '^Observation')" || true
  if [ -z "$out" ]; then echo "ERROR"; else echo "$out" | awk '{print $3}'; fi
}

is_expected() {
  for e in $EXPECTED_DIVERGENCE; do [ "$e" = "$1" ] && return 0; done
  return 1
}

rc=0
for compiler in $COMPILERS; do
  dir="$HERE/out/$compiler"
  [ -d "$dir" ] || { echo "no generated tests for $compiler, skipping"; continue; }

  echo "=============================================================="
  echo " $compiler"
  echo "=============================================================="
  printf "%-18s %-10s %-10s %s\n" TEST RC11 ARMv8 RESULT
  pass=0; fail=0; over=0; xfail=0; err=0

  for gen in "$dir"/*.litmus; do
    [ -e "$gen" ] || continue
    name="$(basename "$gen" .litmus)"
    # A test's declared name need not match its filename -- arfna2.litmus
    # declares `C arfna_transformed` -- so take the source file from the
    # provenance line the generator wrote rather than from the name.
    srcfile="$(sed -n '2p' "$gen" | sed -n 's/.*generated from \([^ ]*\) by.*/\1/p')"
    [ -n "$srcfile" ] || srcfile="$name.litmus"
    src=""
    for d in $CATALOGUE; do [ -f "$d/$srcfile" ] && { src="$d/$srcfile"; break; }; done
    [ -n "$src" ] || { printf "%-18s %-10s %-10s %s\n" "$name" - - "NO SOURCE"; continue; }

    s="$(verdict rc11.cat "$src")"
    a="$(verdict aarch64.cat "$gen")"

    if [ "$s" = ERROR ] || [ "$a" = ERROR ]; then
      result="ERROR"; err=$((err+1)); rc=1
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
  echo "pass=$pass fail=$fail over=$over xfail=$xfail error=$err"
  echo
done

exit $rc
