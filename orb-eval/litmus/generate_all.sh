#!/usr/bin/env bash
#
# Regenerate the whole litmus suite from herdtools7's c11popl15 catalogue.
#
#   $CATALOGUE/*.litmus         herdtools7's c11popl15 catalogue
#   tests/*.litmus              classic ordering shapes (see tests/README.md)
#        |  litmus_to_cpp.py
#        v
#   src/<name>.cpp + .json      compilable C++ and its metadata
#        |  generate_litmus.py  (compiles at each -O level, lifts the asm)
#        v
#   out/<compiler>-O<n>/<name>.litmus
#
# Then run ./run_litmus_tests.sh and ./negative_control.sh.

set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
BUILD="${ORB_BUILD:-$ROOT/build}"
HERDTOOLS_DIR="${HERDTOOLS_DIR:-/scratch/$USER/herdtools7}"
CATALOGUE="${ORB_LITMUS_CATALOGUE_SRC:-$HERDTOOLS_DIR/catalogue/c11popl15/tests/illustrative}"
# orb-c<N>: the synthesis pipeline with fence cost N. Cost 1 favours barriers,
# cost 20 promoted accesses, so both kinds of mechanism are checked.
COMPILERS="${ORB_LITMUS_COMPILERS:-orb-c1 orb-c20 naive-orb clangir}"
OPTS="${ORB_LITMUS_OPTS:--O0 -O1 -O2}"

[ -x "$BUILD/bin/clang++" ] || { echo "no bin/clang++ in $BUILD (set ORB_BUILD)" >&2; exit 2; }
[ -d "$CATALOGUE" ] || { echo "no litmus catalogue at $CATALOGUE (set HERDTOOLS_DIR)" >&2; exit 2; }

rm -rf "$HERE/src" "$HERE/out"

echo "== parsing .litmus -> .cpp"
# Catalogue tests that duplicate another one are skipped (catalogue-duplicates.txt).
dups=" $(grep -vE '^\s*(#|$)' "$HERE/catalogue-duplicates.txt" | awk '{print $1}' | tr '\n' ' ') "
catalogue=()
for f in "$CATALOGUE"/*.litmus; do
  case "$dups" in *" $(basename "$f" .litmus) "*) continue ;; esac
  catalogue+=("$f")
done
echo "   $((${#catalogue[@]})) catalogue tests after removing duplicates"
shapes=("$HERE"/tests/*.litmus)
echo "   plus ${#shapes[@]} ordering shapes from tests/"
python3 "$HERE/litmus_to_cpp.py" "${shapes[@]}" "${catalogue[@]}" -o "$HERE/src"

for opt in $OPTS; do
  for c in $COMPILERS; do
    echo "== compiling and lifting: $c $opt"
    python3 "$HERE/generate_litmus.py" --src "$HERE/src" --out "$HERE/out" \
        --build "$BUILD" --compiler "$c" --opt="$opt" 2>&1 | grep -v '^Warning: supplying'
  done
done

echo
echo "done. now run:  ./run_litmus_tests.sh  and  ./negative_control.sh"
