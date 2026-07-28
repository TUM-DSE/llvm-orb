#include <atomic>

void test_atomics(std::atomic<int>& atomic_val) {
    // 1. Atomic Load
    int expected = atomic_val.load(std::memory_order_acquire);
    
    // 2. Atomic Compare-and-Exchange (RMW)
    int desired = 42;
    atomic_val.compare_exchange_strong(
        expected, 
        desired, 
        std::memory_order_acq_rel, 
        std::memory_order_relaxed
    );
}