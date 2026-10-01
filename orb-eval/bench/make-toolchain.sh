#!/usr/bin/env bash
#
# Creates $WORK/toolchain/bin/{cc,c++}: C and C++ compiler drivers that run the
# Orb clang from $ORB_BUILD/bin, able to compile and link ordinary programs.
#
# The Orb clang is a bare compiler. On NixOS it finds no C library headers, crt
# files or libgcc, because none of them live at the usual FHS paths. Nix solves
# this with its cc-wrapper, a script that adds those paths and then executes the
# real compiler. This script builds the cc-wrapper of the pinned nixpkgs
# (the one the Orb compiler itself is built with), keeps it alive with a GC root
# in $WORK/toolchain, and copies its two driver scripts with the executed
# compiler replaced by the Orb clang.
#
# The replacement goes through a small shim, orb-clang(++), for one reason: the
# cc-wrapper passes -resource-dir pointing at the builtin headers of *its own*
# clang (clang 21), and the Orb clang (clang 23) would silently compile against
# them. The shim appends the Orb clang's own -resource-dir, which takes
# precedence because clang uses the last one given.
#
# Without Nix, the drivers are the shims themselves, which is sufficient on a
# system with the C library at the standard paths.
#
# BENCH_CROSS=aarch64 builds a cross toolchain for AArch64 instead, to validate
# the harness on an x86 machine.

set -euo pipefail
source "$(dirname "$0")/config.sh"

mkdir -p "$TOOLCHAIN/bin"
[ -x "$ORB_BUILD/bin/clang" ] || { echo "no Orb clang in $ORB_BUILD/bin (set ORB_BUILD)" >&2; exit 2; }
RES="$("$ORB_BUILD/bin/clang" -print-resource-dir)"

for tool in clang clang++; do
  cat > "$TOOLCHAIN/bin/orb-$tool" <<EOF
#!/bin/sh
# The Orb clang, forced onto its own builtin headers (see make-toolchain.sh).
exec "$ORB_BUILD/bin/$tool" "\$@" -resource-dir="$RES"
EOF
  chmod +x "$TOOLCHAIN/bin/orb-$tool"
done

if command -v nix >/dev/null 2>&1; then
  if [ -n "$BENCH_CROSS" ]; then
    attr="pkgsCross.${BENCH_CROSS}-multiplatform.llvmPackages.stdenv.cc"
  else
    attr="llvmPackages.stdenv.cc"
  fi
  echo "building the Nix cc-wrapper $BENCH_NIXPKGS#$attr"
  nix build "$BENCH_NIXPKGS#$attr" --out-link "$TOOLCHAIN/nix-cc"
  wrapper="$(readlink -f "$TOOLCHAIN/nix-cc")"
  orig="$(cat "$wrapper/nix-support/orig-cc")"

  # The wrapper scripts are called clang/clang++, or <triple>-clang(++) in a
  # cross toolchain; each executes $orig/bin/clang(++).
  for kind in cc c++; do
    if [ "$kind" = cc ]; then pat='*clang'; tool=clang; else pat='*clang++'; tool=clang++; fi
    src="$(find "$wrapper/bin/" -maxdepth 1 -name "$pat" | head -1)"
    [ -n "$src" ] || { echo "no $pat in $wrapper/bin" >&2; exit 2; }
    sed -e "s|$orig/bin/clang++|$TOOLCHAIN/bin/orb-clang++|g" \
        -e "s|$orig/bin/clang\\b|$TOOLCHAIN/bin/orb-$tool|g" \
        "$src" > "$TOOLCHAIN/bin/$kind"
    chmod +x "$TOOLCHAIN/bin/$kind"
    if grep -q "$orig/bin" "$TOOLCHAIN/bin/$kind"; then
      echo "failed to redirect $src to the Orb clang" >&2; exit 2
    fi
  done
else
  ln -sf orb-clang "$TOOLCHAIN/bin/cc"
  ln -sf orb-clang++ "$TOOLCHAIN/bin/c++"
fi

# Smoke test: compile and link a threaded C program, check that the Orb clang
# and its own resource directory are used.
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cat > "$tmp/t.c" <<'EOF'
#include <pthread.h>
#include <stdio.h>
static int x;
static void *run(void *p) { __atomic_store_n(&x, 1, __ATOMIC_RELEASE); return p; }
int main(void) {
  pthread_t t; pthread_create(&t, 0, run, 0); pthread_join(t, 0);
  printf("ok %d\n", __atomic_load_n(&x, __ATOMIC_ACQUIRE));
  return 0;
}
EOF
"$TOOLCHAIN/bin/cc" $BENCH_CPU_FLAGS -O0 -pthread "$tmp/t.c" -o "$tmp/t"
"$TOOLCHAIN/bin/cc" --version | head -1
echo "resource dir: $("$TOOLCHAIN/bin/cc" -print-resource-dir)"
if [ -z "$BENCH_CROSS" ]; then "$tmp/t"; else echo "cross toolchain: linked $(file -b "$tmp/t" | cut -d, -f1-2)"; fi
echo "toolchain ready in $TOOLCHAIN/bin"
