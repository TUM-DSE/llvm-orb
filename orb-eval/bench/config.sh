# Configuration of the benchmark harness, sourced by every script in this
# directory. Every setting can be overridden from the environment.

BENCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORB_ROOT="$(cd "$BENCH_DIR/../.." && pwd)"
ORB_BUILD="${ORB_BUILD:-$ORB_ROOT/build}"

# Everything generated -- sources, toolchain, builds, logs, results -- lives
# here and is ignored by git.
WORK="${BENCH_WORK:-$BENCH_DIR/work}"
RESULTS="${BENCH_RESULTS:-$WORK/results}"
TOOLCHAIN="$WORK/toolchain"

# The nixpkgs revision pinned by the repository's flake.lock, i.e. the
# toolchain the Orb compiler itself is built with. Used for the C library,
# crt files and libgcc of the benchmark builds and for autotools.
if [ -z "${BENCH_NIXPKGS:-}" ]; then
  BENCH_NIXPKGS="github:nixos/nixpkgs/$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["nodes"]["nixpkgs"]["locked"]["rev"])' "$ORB_ROOT/flake.lock")"
fi

# Benchmark source: Sebastian Reimers' fork of userspace-rcu, the version used
# for the Orb paper.
URCU_REPO="${URCU_REPO:-https://github.com/ReimersS/userspace-rcu.git}"
URCU_COMMIT="${URCU_COMMIT:-3a605bc34f215cd0e1f2086cf08526cd90e48edf}"
URCU_SRC="$WORK/userspace-rcu"

# All variants are configured identically. compiler-atomic-builtins makes
# urcu's atomics and barriers __atomic_* built-ins -- the loads, stores and
# fences that Orb analyses -- instead of __sync_synchronize() and friends.
# Static libraries keep libtool wrapper scripts out of the benchmark runs.
URCU_CONFIGURE_FLAGS="${URCU_CONFIGURE_FLAGS:---enable-compiler-atomic-builtins --disable-shared --enable-static}"

# Native build by default. BENCH_CROSS=aarch64 cross-compiles for AArch64; it
# exists only to validate the harness on an x86 machine.
BENCH_CROSS="${BENCH_CROSS:-}"
if [ -n "$BENCH_CROSS" ]; then TARGET_ARCH="$BENCH_CROSS"; else TARGET_ARCH="$(uname -m)"; fi

# Optimization level: -O0, as in the Orb paper's evaluation.
BENCH_OPT="${BENCH_OPT:--O0}"

# CPU selection. It must enable RCpc, or acquire loads become LDAR in every
# configuration and the naive mapping's LDAPR disappears; it also decides
# whether read-modify-writes use LSE instructions or LL/SC loops. Set it to
# the machine's core, e.g. -mcpu=ampere1a, rather than relying on native.
if [ -z "${BENCH_CPU_FLAGS+set}" ]; then
  if [ -n "$BENCH_CROSS" ]; then BENCH_CPU_FLAGS="-mcpu=ampere1a"
  elif [ "$TARGET_ARCH" = aarch64 ]; then BENCH_CPU_FLAGS="-mcpu=native"
  else BENCH_CPU_FLAGS=""; fi
fi

# Compiler configurations. Cost 1 makes barriers cheap relative to promoted
# accesses, cost 20 makes them expensive, so the synthesis uses both kinds of
# mechanism. clangir is the baseline: Orb is ClangIR plus Orb's passes, so
# clangir isolates Orb's effect. Stock clang (configuration "clang") is left
# out by default: its synchronization counts equal clangir's, but its -O0 code
# is much faster than ClangIR's, which would be charged to Orb.
BENCH_COSTS="${BENCH_COSTS:-1 20}"
# Every configuration is built at each of these levels. Configurations at a
# level other than -O0 carry it as a suffix: clangir-O2, orb-c20-O2, ...
BENCH_OPTS="${BENCH_OPTS:--O0 -O2}"
if [ -z "${BENCH_CONFIGS:-}" ]; then
  BENCH_CONFIGS=""
  for o in $BENCH_OPTS; do
    sfx=""; [ "$o" = -O0 ] || sfx="$o"
    for c in clangir naive-orb $(for k in $BENCH_COSTS; do echo "orb-c$k"; done); do
      BENCH_CONFIGS="${BENCH_CONFIGS:+$BENCH_CONFIGS }$c$sfx"
    done
  done
fi

# The compiler flags of a configuration. orb-timed-cc appends them after the
# build's own flags, so the -O of a suffixed configuration overrides the -O0
# of $BENCH_OPT.
config_flags() {
  case "$1" in
    *-O[0-3sz]) local base; base="$(config_flags "${1%-O?}")" || return 1
                echo "${base:+$base }-${1##*-}" ;;
    clang)     echo "" ;;
    clangir)   echo "-fclangir" ;;
    naive-orb) echo "-fclangir -Xclang -naive-orb" ;;
    orb-c*)    echo "-fclangir -Xclang -orb -Xclang -orb-fence-cost-base=${1#orb-c}" ;;
    *)         echo "unknown configuration: $1" >&2; return 1 ;;
  esac
}

# Compilation. One job by default, so that per-file compile times are not
# distorted by other compilations running at the same time.
BENCH_JOBS="${BENCH_JOBS:-1}"
# Per-pass MLIR timing (-mmlir --mlir-timing) for the ClangIR-based builds.
BENCH_MLIR_TIMING="${BENCH_MLIR_TIMING:-1}"

# Runtime measurement, following the Orb paper: 32 readers and 32 writers.
BENCH_READERS="${BENCH_READERS:-32}"
BENCH_WRITERS="${BENCH_WRITERS:-32}"
BENCH_DURATION="${BENCH_DURATION:-5}"   # seconds per run
BENCH_REPS="${BENCH_REPS:-5}"
# Pin the threads to CPUs 0..(readers+writers-1) with the programs' -a option.
BENCH_AFFINITY="${BENCH_AFFINITY:-1}"
# Prefix for running the programs, e.g. "qemu-aarch64" when cross-compiling.
BENCH_RUNNER="${BENCH_RUNNER:-}"
# Programs taking "<readers|dequeuers> <writers|enqueuers> <seconds>" and
# printing a SUMMARY line. Left out: the *_timing and *_dynamic_link/dynlink
# variants (same code), test_urcu_yield (random yields), the micro
# benchmarks without a SUMMARY line, and test_urcu_wfs, which segfaults with
# every compiler, stock Clang included (a defect of the test program).
BENCH_PROGRAMS="${BENCH_PROGRAMS:-test_urcu test_urcu_mb test_urcu_qsbr test_urcu_bp test_urcu_gc test_urcu_mb_gc test_urcu_qsbr_gc test_urcu_lgc test_urcu_mb_lgc test_urcu_qsbr_lgc test_urcu_defer test_urcu_assign test_urcu_hash test_urcu_lfq test_urcu_wfq test_urcu_wfcq test_urcu_lfs test_urcu_lfs_rcu test_mutex test_rwlock test_perthreadlock}"
