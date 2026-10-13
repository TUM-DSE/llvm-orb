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
 * Loads, stores, fences and compare-exchange: the operations the litmus tests
 * use. Compare-exchange does not go through the Orb pipeline (ClangIR lowers
 * it straight to an LLVM cmpxchg), but the tests using it still check that
 * nothing around it lets ARMv8 show behaviour RC11 forbids. litmus_to_cpp.py
 * rejects a test that uses any other atomic, and leaving those undefined here
 * means one that slipped past the filter fails to compile rather than being
 * compiled with a guess at its meaning.
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

/* C11's compare-exchange takes the expected value through a pointer and
 * writes the current value back to it on failure, exactly like the builtin. */
#define atomic_compare_exchange_strong_explicit(p, e, d, s, f) \
  __atomic_compare_exchange_n((p), (e), (d), 0, (s), (f))
#define atomic_compare_exchange_weak_explicit(p, e, d, s, f) \
  __atomic_compare_exchange_n((p), (e), (d), 1, (s), (f))

/* Non-explicit forms default to seq_cst, per C11. */
#define atomic_load(p)       atomic_load_explicit((p), memory_order_seq_cst)
#define atomic_store(p, v)   atomic_store_explicit((p), (v), memory_order_seq_cst)
#define atomic_compare_exchange_strong(p, e, d) \
  atomic_compare_exchange_strong_explicit((p), (e), (d), memory_order_seq_cst, \
                                          memory_order_seq_cst)
#define atomic_compare_exchange_weak(p, e, d) \
  atomic_compare_exchange_weak_explicit((p), (e), (d), memory_order_seq_cst, \
                                        memory_order_seq_cst)

#endif /* ORB_LITMUS_PRELUDE_H */
