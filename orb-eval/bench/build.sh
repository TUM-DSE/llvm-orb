#!/usr/bin/env bash
#
# Builds userspace-rcu once per compiler configuration.
#
#   ./build.sh                 all configurations of config.sh
#   ./build.sh naive-orb orb-c1
#
# Each configuration gets its own out-of-tree build in $WORK/build/<config> and
# its own logs in $WORK/logs/<config>: configure.log, make.log, the per-file
# compile times and the compiler output of every translation unit (see
# orb-timed-cc). Needs the toolchain of make-toolchain.sh.

set -euo pipefail
source "$(dirname "$0")/config.sh"

# autotools and make, from the pinned nixpkgs unless already installed
if ! command -v autoreconf >/dev/null 2>&1 || ! command -v libtoolize >/dev/null 2>&1 \
   || ! command -v m4 >/dev/null 2>&1 || ! command -v make >/dev/null 2>&1; then
  if command -v nix >/dev/null 2>&1 && [ -z "${BENCH_IN_NIX_SHELL:-}" ]; then
    export BENCH_IN_NIX_SHELL=1
    exec nix shell "$BENCH_NIXPKGS#autoconf" "$BENCH_NIXPKGS#automake" \
      "$BENCH_NIXPKGS#libtool" "$BENCH_NIXPKGS#gnum4" "$BENCH_NIXPKGS#gnumake" "$BENCH_NIXPKGS#gnused" \
      "$BENCH_NIXPKGS#gawk" -c "$0" "$@"
  fi
  echo "need autoconf, automake, libtool, m4 and make" >&2; exit 2
fi

[ -x "$TOOLCHAIN/bin/cc" ] || { echo "no toolchain in $TOOLCHAIN; run ./make-toolchain.sh" >&2; exit 2; }

# Source, once. A dedicated clone keeps the checkout unconfigured, which
# out-of-tree builds require.
if [ ! -d "$URCU_SRC/.git" ]; then
  git clone --quiet "$URCU_REPO" "$URCU_SRC"
fi
git -C "$URCU_SRC" -c advice.detachedHead=false checkout --quiet "$URCU_COMMIT"
if [ ! -f "$URCU_SRC/src/Makefile.in" ]; then
  # `nix shell` puts the tools on PATH but does not set ACLOCAL_PATH, so
  # aclocal would not find libtool's macros. The upstream ./bootstrap also turns
  # every autotools warning into an error, which newer autotools trigger;
  # autoreconf without -Werror generates the same files.
  lt_m4="$(dirname "$(command -v libtoolize)")/../share/aclocal"
  export ACLOCAL_PATH="$lt_m4${ACLOCAL_PATH:+:$ACLOCAL_PATH}"
  git -C "$URCU_SRC" clean -fdxq
  (cd "$URCU_SRC" && mkdir -p config && autoreconf -vif > "$WORK/bootstrap.log" 2>&1) \
    || { echo "bootstrap failed, see $WORK/bootstrap.log" >&2; exit 1; }
fi

host=()
[ -n "$BENCH_CROSS" ] && host=(--host="$BENCH_CROSS-unknown-linux-gnu")
ln -sf orb-timed-cc "$BENCH_DIR/orb-timed-c++"

configs=("$@")
[ ${#configs[@]} -gt 0 ] || read -r -a configs <<< "$BENCH_CONFIGS"

for cfg in "${configs[@]}"; do
  flags="$(config_flags "$cfg")"
  B="$WORK/build/$cfg"; L="$WORK/logs/$cfg"
  rm -rf "$B" "$L"; mkdir -p "$B" "$L"
  echo "== $cfg: $flags $BENCH_OPT $BENCH_CPU_FLAGS"
  printf 'object,source,seconds,status\n' > "$L/compile_times.csv"

  export BENCH_REAL_CC="$TOOLCHAIN/bin/cc" BENCH_REAL_CXX="$TOOLCHAIN/bin/c++"
  export BENCH_CONFIG="$cfg" BENCH_CONFIG_FLAGS="$flags"
  export BENCH_LOG="$L" BENCH_BUILD_DIR="$B" BENCH_MLIR_TIMING

  # shellcheck disable=SC2086  # URCU_CONFIGURE_FLAGS is a list of flags
  (cd "$B" && BENCH_PHASE=configure "$URCU_SRC/configure" "${host[@]}" \
      CC="$BENCH_DIR/orb-timed-cc" CXX="$BENCH_DIR/orb-timed-c++" \
      CFLAGS="$BENCH_OPT $BENCH_CPU_FLAGS" CXXFLAGS="$BENCH_OPT $BENCH_CPU_FLAGS" \
      $URCU_CONFIGURE_FLAGS > "$L/configure.log" 2>&1) \
    || { echo "   configure failed, see $L/configure.log" >&2; exit 1; }

  start=$(date +%s)
  (cd "$B" && BENCH_PHASE=build make -j"$BENCH_JOBS" > "$L/make.log" 2>&1) \
    || { echo "   build failed, see $L/make.log" >&2; exit 1; }
  echo "   built in $(( $(date +%s) - start )) s, $(($(wc -l < "$L/compile_times.csv") - 1)) translation units"

  missing=()
  for p in $BENCH_PROGRAMS; do [ -x "$B/tests/benchmark/$p" ] || missing+=("$p"); done
  if [ ${#missing[@]} -gt 0 ]; then
    echo "   missing benchmark programs: ${missing[*]}" >&2; exit 1
  fi
done
