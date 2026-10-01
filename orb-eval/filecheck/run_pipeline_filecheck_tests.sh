#!/usr/bin/env bash
#
# Run the Orb *pipeline* FileCheck suite (control flow and function calls).
#
# Companion to run_filecheck_tests.sh, which checks the static per-operation
# mappings. This one runs the full pipeline including --order-analysis and
# --fence-synthesis, where several different target programs are all correct.
#
# For every test file and every --fence-cost-base setting:
#   1. the CHECK prefix must match          (invariants: no cpp_atomic left,
#                                            accesses present with right type)
#   2. at least ONE ORB-SOLUTIONS prefix must match
#                                           (some legal ordering mechanism)
# and once per file:
#   3. the NAIVE prefix must match the --cpp-atomic-to-arm-atomic-naive output
#                                           (that mapping is deterministic)
#
# Regenerate the test files with:
#   python3 generate_pipeline_filecheck_tests.py

set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
BIN="${ORB_BUILD:-$ROOT/build}/bin"
CLANG="$BIN/clang++"
CIROPT="$BIN/cir-opt"
FILECHECK="$BIN/FileCheck"
MLIR="$HERE/mlir"
mkdir -p "$MLIR"

GREEN='\033[0;32m'; RED='\033[0;31m'; BLUE='\033[0;34m'; DIM='\033[0;90m'; NC='\033[0m'

for tool in "$CLANG" "$CIROPT" "$FILECHECK"; do
  if [ ! -x "$tool" ]; then
    echo -e "${RED}Missing tool: $tool${NC}"
    echo "Build clang++, cir-opt and FileCheck first."
    exit 1
  fi
done

# The CIR pre-lowering prefix, kept identical to populateCIRPreLoweringPasses()
# in clang/lib/CIR/Lowering/CIRPasses.cpp followed by the Orb front half of
# populateOrbPasses(). If that pipeline changes, change it here too.
PRE="--cir-hoist-allocas --cir-flatten-cfg --cir-eh-abi-lowering --cir-goto-solver"
PRE="$PRE --cir-to-cf --cir-to-ptr --cir-to-cpp-atomic"
ORB_TAIL="--order-analysis --cpp-atomic-to-arm-atomic"
NAIVE_TAIL="--order-analysis --cpp-atomic-to-arm-atomic-naive"

# Fence-synthesis cost settings to sweep. Low values make barriers cheap and
# push the synthesis towards inserting fences; high values push it towards
# promoting accesses. A legal program must come out either way.
COSTS="${ORB_TEST_COSTS:-1 2 6 20}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT


pass=0; fail=0; failed_names=()

emit_cir() {   # emit_cir <src> <out>
  "$CLANG" -fclangir -emit-cir -O0 -o "$2" "$1" 2>"$TMP/clang.err"
}

for src in "$HERE"/test_orb_pipeline_*.cpp; do
  base="$(basename "$src" .cpp)"
  echo -e "${BLUE}======================================================================${NC}"
  echo -e "${BLUE}${base}${NC}"

  solutions="$(sed -n 's|^// ORB-SOLUTIONS: ||p' "$src")"
  if [ -z "$solutions" ]; then
    echo -e "  ${RED}no ORB-SOLUTIONS header -- regenerate the test files${NC}"
    fail=$((fail+1)); failed_names+=("$base: missing header"); continue
  fi

  if ! emit_cir "$src" "$MLIR/$base.cir"; then
    echo -e "  ${RED}clang++ -emit-cir failed${NC}"; sed 's/^/    /' "$TMP/clang.err" | head -5
    fail=$((fail+1)); failed_names+=("$base: clang"); continue
  fi

  # Orb pipeline, swept over the cost model
  for cost in $COSTS; do
    out="$MLIR/$base.c$cost.mlir"
    if ! "$CIROPT" "$MLIR/$base.cir" $PRE $ORB_TAIL \
         --fence-synthesis=fence-cost-base=$cost -o "$out" 2>"$TMP/synth.log"; then
      echo -e "  ${RED}FAIL${NC} cost=$cost  cir-opt error"
      sed 's/^/    /' "$TMP/synth.log" | tail -5
      fail=$((fail+1)); failed_names+=("$base cost=$cost: cir-opt"); continue
    fi

    # Invariants. --implicit-check-not makes a surviving cpp_atomic op fail.
    if ! "$FILECHECK" --check-prefix=CHECK \
         --implicit-check-not='cpp_atomic.' "$src" <"$out" >"$TMP/fc.err" 2>&1; then
      echo -e "  ${RED}FAIL${NC} cost=$cost  invariants (CHECK)"
      sed 's/^/    /' "$TMP/fc.err" | head -12
      fail=$((fail+1)); failed_names+=("$base cost=$cost: CHECK"); continue
    fi

    # At least one acceptable ordering mechanism.
    matched=""
    for sol in $solutions; do
      if "$FILECHECK" --check-prefix="$sol" "$src" <"$out" >/dev/null 2>&1; then
        matched="$sol"; break
      fi
    done
    if [ -z "$matched" ]; then
      echo -e "  ${RED}FAIL${NC} cost=$cost  no accepted solution matched ($solutions)"
      echo -e "    ${DIM}synthesis said: $(grep -o 'done ordered=[^ ]* overspecified=[0-9]*' "$TMP/synth.log" | head -1)${NC}"
      echo "    emitted primitives:"
      grep -o 'arm_atomic\.atomic_[a-z]*[^{]*memory_order([0-9]*' "$out" \
        | sed 's/%[0-9]*//g; s/  */ /g; s/^/      /' | sort | uniq -c | head -8
      fail=$((fail+1)); failed_names+=("$base cost=$cost: no solution")
      continue
    fi

    remaining="$(grep -o 'remaining=[0-9]*' "$TMP/synth.log" | head -1)"
    echo -e "  [${GREEN}OK${NC}]   cost=$cost  solution=${matched}  ${DIM}${remaining}${NC}"
    pass=$((pass+1))
  done

  # Naive pipeline: one deterministic answer
  out="$MLIR/$base.naive.mlir"
  if ! "$CIROPT" "$MLIR/$base.cir" $PRE $NAIVE_TAIL -o "$out" 2>/dev/null; then
    echo -e "  ${RED}FAIL${NC} naive    cir-opt error"
    fail=$((fail+1)); failed_names+=("$base: naive cir-opt")
  elif ! "$FILECHECK" --check-prefix=NAIVE \
        --implicit-check-not='cpp_atomic.' "$src" <"$out" >"$TMP/fc.err" 2>&1; then
    echo -e "  ${RED}FAIL${NC} naive    static mapping mismatch"
    sed 's/^/    /' "$TMP/fc.err" | head -12
    fail=$((fail+1)); failed_names+=("$base: NAIVE")
  else
    echo -e "  [${GREEN}OK${NC}]   naive    static mapping"
    pass=$((pass+1))
  fi
done

echo -e "${BLUE}======================================================================${NC}"
if [ "$fail" -eq 0 ]; then
  echo -e "${GREEN}All $pass checks passed.${NC}"
  exit 0
fi
echo -e "${RED}$fail check(s) failed, $pass passed:${NC}"
for f in "${failed_names[@]}"; do echo "  - $f"; done
exit 1
