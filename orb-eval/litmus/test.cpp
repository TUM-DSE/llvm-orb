// Generated from /scratch/alex/herdtools7/catalogue/c11popl15/tests/illustrative/fig1.litmus by litmus_to_cpp.py -- do not edit.
// Test: fig1
// Condition: (a=1 /\ x=1 /\ y=1) (exists)
#include <atomic>
// #include <iostream>

// Initial state: a=0; x=0; y=0
volatile int a = 0;
std::atomic_int x = 0;
std::atomic_int y = 0;

void P0(volatile int* a, std::atomic_int* x, std::atomic_int* y) {
  *a = 1;
  int r0 = atomic_load_explicit(x, std::memory_order_relaxed);
  int r1 = *a;
  atomic_store_explicit(y, 1, std::memory_order_relaxed);
}

void P1(std::atomic_int* x, std::atomic_int* y) {
  int r2 = atomic_load_explicit(y, std::memory_order_relaxed);
  atomic_store_explicit(x, 1, std::memory_order_relaxed);
}

int main() {
    P0(&a, &x, &y); 
    P1(&x, &y);
    // std::cout << "Hello World!" << std::endl;
    return 0;
}