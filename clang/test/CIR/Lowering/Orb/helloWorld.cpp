#include <atomic>

int main() {

    std::atomic<int> my_atomic{0};

    std::atomic_thread_fence(std::memory_order_release);

    my_atomic.store(42, std::memory_order_relaxed);

    return 0;
}