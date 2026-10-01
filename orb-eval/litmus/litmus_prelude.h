/*===----------------------------------------------------------------------===
 * litmus_prelude.h -- the C11 atomics surface that herdtools7 litmus tests use,
 * expressed with the __atomic_* builtins.
 *
 * Generated litmus threads include this instead of <stdatomic.h>/<atomic>.
 * Two reasons:
 *   - <atomic> does not resolve cleanly under the clang-wrapper on this NixOS
 *     setup (no libstdc++ include path), and
 *   - the FileCheck suite already drives the pipeline through __atomic_*, so
 *     both suites exercise the same front-end path into cpp_atomic.
 *
 * Loads, stores and fences only -- the operations this suite tests the mapping
 * of. Read-modify-write ops are out of scope and belong to the RMWOps branch,
 * so no exchange, compare-exchange or fetch_* macro is defined here.
 *
 * litmus_to_cpp.py already drops a test that uses one, so nothing should reach
 * this header needing them; leaving them undefined means that if a test ever
 * slips past the filter it fails to compile rather than quietly being measured
 * as though it said something about load/store/fence ordering.
 *===----------------------------------------------------------------------===*/
#ifndef ORB_LITMUS_PRELUDE_H
#define ORB_LITMUS_PRELUDE_H

/* Plain int, not _Atomic: the __atomic_* builtins reject _Atomic-qualified
 * pointers (those need __c11_atomic_*), and the FileCheck suite already drives
 * Orb through __atomic_* on plain globals. Keeping both suites on one front-end
 * path means a difference between them is a real difference, not an artefact of
 * two different lowerings.
 *
 * The one thing this gives up is implicit atomicity: under C11 a bare `*p = 1`
 * through an atomic_int* is a seq_cst store, whereas here it would be a plain
 * one. litmus_to_cpp.py rewrites that construct explicitly rather than letting
 * it degrade silently. */
typedef int atomic_int;

#define memory_order_relaxed __ATOMIC_RELAXED
#define memory_order_consume __ATOMIC_CONSUME
#define memory_order_acquire __ATOMIC_ACQUIRE
#define memory_order_release __ATOMIC_RELEASE
#define memory_order_acq_rel __ATOMIC_ACQ_REL
#define memory_order_seq_cst __ATOMIC_SEQ_CST

#define atomic_load_explicit(p, mo)     __atomic_load_n((p), (mo))
#define atomic_store_explicit(p, v, mo) __atomic_store_n((p), (v), (mo))
#define atomic_thread_fence(mo)         __atomic_thread_fence((mo))

/* Non-explicit forms default to seq_cst, per C11. */
#define atomic_load(p)       atomic_load_explicit((p), memory_order_seq_cst)
#define atomic_store(p, v)   atomic_store_explicit((p), (v), memory_order_seq_cst)

#endif /* ORB_LITMUS_PRELUDE_H */
