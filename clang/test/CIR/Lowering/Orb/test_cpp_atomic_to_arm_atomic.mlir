// === PHASE 2: CppAtomic -> ArmAtomic === 

// RUN: ./../../../../../build/bin/cir-opt tests/test_cpp_atomic_to_arm_atomic.mlir --cpp-atomic-to-arm-atomic | ./../../../../../build/bin/FileCheck tests/test_cpp_atomic_to_arm_atomic.mlir


// --- 1. LOADS ---
// CHECK-LABEL: cir.func @test_arm_load_i8_relaxed
cir.func @test_arm_load_i8_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(1)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: cir.func @test_arm_load_i8_acquire
cir.func @test_arm_load_i8_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(1)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: cir.func @test_arm_load_i8_seqcst
cir.func @test_arm_load_i8_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(1)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(4 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: cir.func @test_arm_load_i16_relaxed
cir.func @test_arm_load_i16_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(2)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: cir.func @test_arm_load_i16_acquire
cir.func @test_arm_load_i16_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(2)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: cir.func @test_arm_load_i16_seqcst
cir.func @test_arm_load_i16_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(2)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(4 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: cir.func @test_arm_load_i32_relaxed
cir.func @test_arm_load_i32_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(4)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: cir.func @test_arm_load_i32_acquire
cir.func @test_arm_load_i32_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: cir.func @test_arm_load_i32_seqcst
cir.func @test_arm_load_i32_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(4 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: cir.func @test_arm_load_i64_relaxed
cir.func @test_arm_load_i64_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(8)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: cir.func @test_arm_load_i64_acquire
cir.func @test_arm_load_i64_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: cir.func @test_arm_load_i64_seqcst
cir.func @test_arm_load_i64_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(4 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: cir.func @test_arm_load_f32_relaxed
cir.func @test_arm_load_f32_relaxed(%arg0 : !cir.ptr<!cir.float>) -> !cir.float {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(4)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(4) : !cir.ptr<!cir.float>
  cir.return %0 : !cir.float
}

// CHECK-LABEL: cir.func @test_arm_load_f32_acquire
cir.func @test_arm_load_f32_acquire(%arg0 : !cir.ptr<!cir.float>) -> !cir.float {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4) : !cir.ptr<!cir.float>
  cir.return %0 : !cir.float
}

// CHECK-LABEL: cir.func @test_arm_load_f32_seqcst
cir.func @test_arm_load_f32_seqcst(%arg0 : !cir.ptr<!cir.float>) -> !cir.float {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(4 : i32) align(4) : !cir.ptr<!cir.float>
  cir.return %0 : !cir.float
}

// CHECK-LABEL: cir.func @test_arm_load_f64_relaxed
cir.func @test_arm_load_f64_relaxed(%arg0 : !cir.ptr<!cir.double>) -> !cir.double {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(8)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(8) : !cir.ptr<!cir.double>
  cir.return %0 : !cir.double
}

// CHECK-LABEL: cir.func @test_arm_load_f64_acquire
cir.func @test_arm_load_f64_acquire(%arg0 : !cir.ptr<!cir.double>) -> !cir.double {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8) : !cir.ptr<!cir.double>
  cir.return %0 : !cir.double
}

// CHECK-LABEL: cir.func @test_arm_load_f64_seqcst
cir.func @test_arm_load_f64_seqcst(%arg0 : !cir.ptr<!cir.double>) -> !cir.double {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8)
  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order(4 : i32) align(8) : !cir.ptr<!cir.double>
  cir.return %0 : !cir.double
}

// --- 2. STORES ---
// CHECK-LABEL: cir.func @test_arm_store_i8_relaxed
cir.func @test_arm_store_i8_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(1)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(1) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i8_release
cir.func @test_arm_store_i8_release(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(1)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(1) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i8_seqcst
cir.func @test_arm_store_i8_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(1)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(4 : i32) align(1) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i16_relaxed
cir.func @test_arm_store_i16_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(2)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(2) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i16_release
cir.func @test_arm_store_i16_release(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(2)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(2) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i16_seqcst
cir.func @test_arm_store_i16_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(2)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(4 : i32) align(2) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i32_relaxed
cir.func @test_arm_store_i32_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(4)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(4) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i32_release
cir.func @test_arm_store_i32_release(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i32_seqcst
cir.func @test_arm_store_i32_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(4 : i32) align(4) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i64_relaxed
cir.func @test_arm_store_i64_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(8)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(8) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i64_release
cir.func @test_arm_store_i64_release(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i64_seqcst
cir.func @test_arm_store_i64_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(4 : i32) align(8) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f32_relaxed
cir.func @test_arm_store_f32_relaxed(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(4)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(4) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f32_release
cir.func @test_arm_store_f32_release(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f32_seqcst
cir.func @test_arm_store_f32_seqcst(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(4 : i32) align(4) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f64_relaxed
cir.func @test_arm_store_f64_relaxed(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(8)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(8) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f64_release
cir.func @test_arm_store_f64_release(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f64_seqcst
cir.func @test_arm_store_f64_seqcst(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8)
  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order(4 : i32) align(8) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// --- 3. FENCES ---
// CHECK-LABEL: cir.func @test_arm_fence_acquire
cir.func @test_arm_fence_acquire() {
  // CHECK: arm_atomic.atomic_fence memory_order(1 : i32)
  cpp_atomic.atomic_fence memory_order(1 : i32)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_fence_release
cir.func @test_arm_fence_release() {
  // CHECK: arm_atomic.atomic_fence memory_order(2 : i32)
  cpp_atomic.atomic_fence memory_order(2 : i32)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_fence_acqrel
cir.func @test_arm_fence_acqrel() {
  // CHECK: arm_atomic.atomic_fence memory_order(3 : i32)
  cpp_atomic.atomic_fence memory_order(3 : i32)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_fence_seqcst
cir.func @test_arm_fence_seqcst() {
  // CHECK: arm_atomic.atomic_fence memory_order(3 : i32)
  cpp_atomic.atomic_fence memory_order(4 : i32)
  cir.return
}

// --- 4. CMPXCHG ---
// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_relaxed_relaxed
cir.func @test_arm_cmpxchg_i8_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_relaxed_acquire
cir.func @test_arm_cmpxchg_i8_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(1 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_relaxed_seqcst
cir.func @test_arm_cmpxchg_i8_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(4 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acquire_relaxed
cir.func @test_arm_cmpxchg_i8_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acquire_acquire
cir.func @test_arm_cmpxchg_i8_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(1 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acquire_seqcst
cir.func @test_arm_cmpxchg_i8_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(4 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_release_relaxed
cir.func @test_arm_cmpxchg_i8_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_release_acquire
cir.func @test_arm_cmpxchg_i8_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(1 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_release_seqcst
cir.func @test_arm_cmpxchg_i8_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(4 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acqrel_relaxed
cir.func @test_arm_cmpxchg_i8_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acqrel_acquire
cir.func @test_arm_cmpxchg_i8_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(1 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acqrel_seqcst
cir.func @test_arm_cmpxchg_i8_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(4 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_seqcst_relaxed
cir.func @test_arm_cmpxchg_i8_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_seqcst_acquire
cir.func @test_arm_cmpxchg_i8_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(1 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_seqcst_seqcst
cir.func @test_arm_cmpxchg_i8_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(4 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_relaxed_relaxed
cir.func @test_arm_cmpxchg_i16_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_relaxed_acquire
cir.func @test_arm_cmpxchg_i16_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(1 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_relaxed_seqcst
cir.func @test_arm_cmpxchg_i16_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(4 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acquire_relaxed
cir.func @test_arm_cmpxchg_i16_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acquire_acquire
cir.func @test_arm_cmpxchg_i16_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(1 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acquire_seqcst
cir.func @test_arm_cmpxchg_i16_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(4 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_release_relaxed
cir.func @test_arm_cmpxchg_i16_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_release_acquire
cir.func @test_arm_cmpxchg_i16_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(1 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_release_seqcst
cir.func @test_arm_cmpxchg_i16_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(4 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acqrel_relaxed
cir.func @test_arm_cmpxchg_i16_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acqrel_acquire
cir.func @test_arm_cmpxchg_i16_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(1 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acqrel_seqcst
cir.func @test_arm_cmpxchg_i16_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(4 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_seqcst_relaxed
cir.func @test_arm_cmpxchg_i16_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_seqcst_acquire
cir.func @test_arm_cmpxchg_i16_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(1 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_seqcst_seqcst
cir.func @test_arm_cmpxchg_i16_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(4 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_relaxed_relaxed
cir.func @test_arm_cmpxchg_i32_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_relaxed_acquire
cir.func @test_arm_cmpxchg_i32_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(1 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_relaxed_seqcst
cir.func @test_arm_cmpxchg_i32_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(4 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acquire_relaxed
cir.func @test_arm_cmpxchg_i32_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acquire_acquire
cir.func @test_arm_cmpxchg_i32_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(1 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acquire_seqcst
cir.func @test_arm_cmpxchg_i32_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(4 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_release_relaxed
cir.func @test_arm_cmpxchg_i32_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_release_acquire
cir.func @test_arm_cmpxchg_i32_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(1 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_release_seqcst
cir.func @test_arm_cmpxchg_i32_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(4 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acqrel_relaxed
cir.func @test_arm_cmpxchg_i32_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acqrel_acquire
cir.func @test_arm_cmpxchg_i32_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(1 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acqrel_seqcst
cir.func @test_arm_cmpxchg_i32_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(4 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_seqcst_relaxed
cir.func @test_arm_cmpxchg_i32_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_seqcst_acquire
cir.func @test_arm_cmpxchg_i32_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(1 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_seqcst_seqcst
cir.func @test_arm_cmpxchg_i32_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(4 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_relaxed_relaxed
cir.func @test_arm_cmpxchg_i64_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_relaxed_acquire
cir.func @test_arm_cmpxchg_i64_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(1 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_relaxed_seqcst
cir.func @test_arm_cmpxchg_i64_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(4 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acquire_relaxed
cir.func @test_arm_cmpxchg_i64_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acquire_acquire
cir.func @test_arm_cmpxchg_i64_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(1 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acquire_seqcst
cir.func @test_arm_cmpxchg_i64_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(4 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_release_relaxed
cir.func @test_arm_cmpxchg_i64_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_release_acquire
cir.func @test_arm_cmpxchg_i64_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(1 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_release_seqcst
cir.func @test_arm_cmpxchg_i64_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(4 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acqrel_relaxed
cir.func @test_arm_cmpxchg_i64_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acqrel_acquire
cir.func @test_arm_cmpxchg_i64_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(1 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acqrel_seqcst
cir.func @test_arm_cmpxchg_i64_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(4 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_seqcst_relaxed
cir.func @test_arm_cmpxchg_i64_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_seqcst_acquire
cir.func @test_arm_cmpxchg_i64_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(1 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_seqcst_seqcst
cir.func @test_arm_cmpxchg_i64_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(4 : i32) failure_order(4 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// --- 5. ATOMIC FETCH ---
// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_add_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_add_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_add_vol_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_sub_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_sub_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_sub_vol_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_and_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_and_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_and_vol_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_or_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_or_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_or_vol_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_xor_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_xor_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_xor_vol_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_nand_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_max_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_min_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_relaxed_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_add_
cir.func @test_cpp_to_arm_fetch_i8_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_add_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_add_vol_
cir.func @test_cpp_to_arm_fetch_i8_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_sub_
cir.func @test_cpp_to_arm_fetch_i8_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_sub_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_sub_vol_
cir.func @test_cpp_to_arm_fetch_i8_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_and_
cir.func @test_cpp_to_arm_fetch_i8_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_and_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_and_vol_
cir.func @test_cpp_to_arm_fetch_i8_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_or_
cir.func @test_cpp_to_arm_fetch_i8_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_or_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_or_vol_
cir.func @test_cpp_to_arm_fetch_i8_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_xor_
cir.func @test_cpp_to_arm_fetch_i8_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_xor_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_xor_vol_
cir.func @test_cpp_to_arm_fetch_i8_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_nand_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_max_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_min_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acquire_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_add_
cir.func @test_cpp_to_arm_fetch_i8_release_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_add_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_add_vol_
cir.func @test_cpp_to_arm_fetch_i8_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_sub_
cir.func @test_cpp_to_arm_fetch_i8_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_sub_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_sub_vol_
cir.func @test_cpp_to_arm_fetch_i8_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_and_
cir.func @test_cpp_to_arm_fetch_i8_release_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_and_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_and_vol_
cir.func @test_cpp_to_arm_fetch_i8_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_or_
cir.func @test_cpp_to_arm_fetch_i8_release_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_or_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_or_vol_
cir.func @test_cpp_to_arm_fetch_i8_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_xor_
cir.func @test_cpp_to_arm_fetch_i8_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_xor_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_xor_vol_
cir.func @test_cpp_to_arm_fetch_i8_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_nand_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_max_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_min_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_release_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_add_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_add_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_add_vol_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_sub_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_sub_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_sub_vol_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_and_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_and_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_and_vol_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_or_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_or_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_or_vol_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_xor_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_xor_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_xor_vol_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_nand_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_max_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_min_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_acqrel_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_add_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_add_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_add_vol_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_sub_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_sub_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_sub_vol_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_and_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_and_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_and_vol_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_or_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_or_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_or_vol_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_xor_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_xor_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_xor_vol_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_nand_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_max_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_min_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i8_seqcst_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i8_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_add_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_add_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_add_vol_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_sub_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_sub_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_sub_vol_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_and_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_and_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_and_vol_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_or_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_or_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_or_vol_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_xor_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_xor_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_xor_vol_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_nand_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_max_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_min_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_relaxed_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_add_
cir.func @test_cpp_to_arm_fetch_i16_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_add_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_add_vol_
cir.func @test_cpp_to_arm_fetch_i16_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_sub_
cir.func @test_cpp_to_arm_fetch_i16_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_sub_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_sub_vol_
cir.func @test_cpp_to_arm_fetch_i16_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_and_
cir.func @test_cpp_to_arm_fetch_i16_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_and_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_and_vol_
cir.func @test_cpp_to_arm_fetch_i16_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_or_
cir.func @test_cpp_to_arm_fetch_i16_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_or_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_or_vol_
cir.func @test_cpp_to_arm_fetch_i16_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_xor_
cir.func @test_cpp_to_arm_fetch_i16_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_xor_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_xor_vol_
cir.func @test_cpp_to_arm_fetch_i16_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_nand_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_max_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_min_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acquire_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_add_
cir.func @test_cpp_to_arm_fetch_i16_release_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_add_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_add_vol_
cir.func @test_cpp_to_arm_fetch_i16_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_sub_
cir.func @test_cpp_to_arm_fetch_i16_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_sub_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_sub_vol_
cir.func @test_cpp_to_arm_fetch_i16_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_and_
cir.func @test_cpp_to_arm_fetch_i16_release_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_and_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_and_vol_
cir.func @test_cpp_to_arm_fetch_i16_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_or_
cir.func @test_cpp_to_arm_fetch_i16_release_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_or_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_or_vol_
cir.func @test_cpp_to_arm_fetch_i16_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_xor_
cir.func @test_cpp_to_arm_fetch_i16_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_xor_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_xor_vol_
cir.func @test_cpp_to_arm_fetch_i16_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_nand_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_max_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_min_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_release_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_add_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_add_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_add_vol_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_sub_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_sub_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_sub_vol_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_and_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_and_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_and_vol_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_or_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_or_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_or_vol_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_xor_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_xor_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_xor_vol_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_nand_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_max_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_min_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_acqrel_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_add_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_add_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_add_vol_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_sub_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_sub_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_sub_vol_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_and_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_and_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_and_vol_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_or_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_or_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_or_vol_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_xor_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_xor_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_xor_vol_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_nand_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_max_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_min_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i16_seqcst_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i16_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_add_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_add_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_add_vol_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_sub_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_sub_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_sub_vol_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_and_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_and_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_and_vol_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_or_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_or_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_or_vol_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_xor_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_xor_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_xor_vol_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_nand_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_max_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_min_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_relaxed_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_add_
cir.func @test_cpp_to_arm_fetch_i32_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_add_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_add_vol_
cir.func @test_cpp_to_arm_fetch_i32_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_sub_
cir.func @test_cpp_to_arm_fetch_i32_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_sub_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_sub_vol_
cir.func @test_cpp_to_arm_fetch_i32_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_and_
cir.func @test_cpp_to_arm_fetch_i32_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_and_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_and_vol_
cir.func @test_cpp_to_arm_fetch_i32_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_or_
cir.func @test_cpp_to_arm_fetch_i32_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_or_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_or_vol_
cir.func @test_cpp_to_arm_fetch_i32_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_xor_
cir.func @test_cpp_to_arm_fetch_i32_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_xor_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_xor_vol_
cir.func @test_cpp_to_arm_fetch_i32_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_nand_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_max_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_min_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acquire_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_add_
cir.func @test_cpp_to_arm_fetch_i32_release_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_add_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_add_vol_
cir.func @test_cpp_to_arm_fetch_i32_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_sub_
cir.func @test_cpp_to_arm_fetch_i32_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_sub_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_sub_vol_
cir.func @test_cpp_to_arm_fetch_i32_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_and_
cir.func @test_cpp_to_arm_fetch_i32_release_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_and_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_and_vol_
cir.func @test_cpp_to_arm_fetch_i32_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_or_
cir.func @test_cpp_to_arm_fetch_i32_release_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_or_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_or_vol_
cir.func @test_cpp_to_arm_fetch_i32_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_xor_
cir.func @test_cpp_to_arm_fetch_i32_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_xor_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_xor_vol_
cir.func @test_cpp_to_arm_fetch_i32_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_nand_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_max_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_min_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_release_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_add_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_add_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_add_vol_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_sub_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_sub_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_sub_vol_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_and_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_and_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_and_vol_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_or_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_or_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_or_vol_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_xor_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_xor_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_xor_vol_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_nand_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_max_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_min_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_acqrel_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_add_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_add_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_add_vol_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_sub_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_sub_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_sub_vol_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_and_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_and_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_and_vol_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_or_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_or_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_or_vol_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_xor_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_xor_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_xor_vol_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_nand_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_max_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_min_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i32_seqcst_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i32_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_add_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_add_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_add_vol_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_sub_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_sub_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_sub_vol_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_and_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_and_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_and_vol_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_or_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_or_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_or_vol_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_xor_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_xor_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_xor_vol_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_nand_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_max_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_min_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_relaxed_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_add_
cir.func @test_cpp_to_arm_fetch_i64_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_add_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_add_vol_
cir.func @test_cpp_to_arm_fetch_i64_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_sub_
cir.func @test_cpp_to_arm_fetch_i64_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_sub_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_sub_vol_
cir.func @test_cpp_to_arm_fetch_i64_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_and_
cir.func @test_cpp_to_arm_fetch_i64_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_and_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_and_vol_
cir.func @test_cpp_to_arm_fetch_i64_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_or_
cir.func @test_cpp_to_arm_fetch_i64_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_or_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_or_vol_
cir.func @test_cpp_to_arm_fetch_i64_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_xor_
cir.func @test_cpp_to_arm_fetch_i64_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_xor_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_xor_vol_
cir.func @test_cpp_to_arm_fetch_i64_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_nand_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_max_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_min_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acquire_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_add_
cir.func @test_cpp_to_arm_fetch_i64_release_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_add_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_add_vol_
cir.func @test_cpp_to_arm_fetch_i64_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_sub_
cir.func @test_cpp_to_arm_fetch_i64_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_sub_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_sub_vol_
cir.func @test_cpp_to_arm_fetch_i64_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_and_
cir.func @test_cpp_to_arm_fetch_i64_release_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_and_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_and_vol_
cir.func @test_cpp_to_arm_fetch_i64_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_or_
cir.func @test_cpp_to_arm_fetch_i64_release_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_or_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_or_vol_
cir.func @test_cpp_to_arm_fetch_i64_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_xor_
cir.func @test_cpp_to_arm_fetch_i64_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_xor_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_xor_vol_
cir.func @test_cpp_to_arm_fetch_i64_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_nand_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_max_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_min_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_release_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_add_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_add_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_add_vol_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_sub_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_sub_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_sub_vol_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_and_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_and_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_and_vol_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_or_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_or_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_or_vol_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_xor_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_xor_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_xor_vol_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_nand_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_max_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_min_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_acqrel_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_add_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_add_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_add_vol_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_sub_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_sub_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_sub_vol_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_and_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_and_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_and_vol_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_and_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_or_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_or_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_or_vol_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_or_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_xor_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_xor_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_xor_vol_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_xor_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_nand_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_nand_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_max_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_min_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_i64_seqcst_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_i64_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_add_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_add_ff_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_add_vol_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_sub_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_sub_ff_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_sub_vol_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_max_ff_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_min_ff_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_relaxed_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_add_
cir.func @test_cpp_to_arm_fetch_f32_acquire_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_add_ff_
cir.func @test_cpp_to_arm_fetch_f32_acquire_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_add_vol_
cir.func @test_cpp_to_arm_fetch_f32_acquire_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_sub_
cir.func @test_cpp_to_arm_fetch_f32_acquire_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_sub_ff_
cir.func @test_cpp_to_arm_fetch_f32_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_sub_vol_
cir.func @test_cpp_to_arm_fetch_f32_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_max_ff_
cir.func @test_cpp_to_arm_fetch_f32_acquire_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_min_ff_
cir.func @test_cpp_to_arm_fetch_f32_acquire_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acquire_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_add_
cir.func @test_cpp_to_arm_fetch_f32_release_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_add_ff_
cir.func @test_cpp_to_arm_fetch_f32_release_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_add_vol_
cir.func @test_cpp_to_arm_fetch_f32_release_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_sub_
cir.func @test_cpp_to_arm_fetch_f32_release_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_sub_ff_
cir.func @test_cpp_to_arm_fetch_f32_release_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_sub_vol_
cir.func @test_cpp_to_arm_fetch_f32_release_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_max_ff_
cir.func @test_cpp_to_arm_fetch_f32_release_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_min_ff_
cir.func @test_cpp_to_arm_fetch_f32_release_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_release_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_add_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_add_ff_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_add_vol_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_sub_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_sub_ff_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_sub_vol_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_max_ff_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_min_ff_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_acqrel_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_add_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_add_ff_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_add_vol_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_sub_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_sub_ff_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_sub_vol_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_max_ff_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_min_ff_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f32_seqcst_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f32_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_add_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_add_ff_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_add_vol_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_sub_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_sub_ff_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_sub_vol_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_max_ff_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_min_ff_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_relaxed_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_add_
cir.func @test_cpp_to_arm_fetch_f64_acquire_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_add_ff_
cir.func @test_cpp_to_arm_fetch_f64_acquire_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_add_vol_
cir.func @test_cpp_to_arm_fetch_f64_acquire_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_sub_
cir.func @test_cpp_to_arm_fetch_f64_acquire_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_sub_ff_
cir.func @test_cpp_to_arm_fetch_f64_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_sub_vol_
cir.func @test_cpp_to_arm_fetch_f64_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_max_ff_
cir.func @test_cpp_to_arm_fetch_f64_acquire_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_min_ff_
cir.func @test_cpp_to_arm_fetch_f64_acquire_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acquire_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_add_
cir.func @test_cpp_to_arm_fetch_f64_release_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_add_ff_
cir.func @test_cpp_to_arm_fetch_f64_release_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_add_vol_
cir.func @test_cpp_to_arm_fetch_f64_release_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_sub_
cir.func @test_cpp_to_arm_fetch_f64_release_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_sub_ff_
cir.func @test_cpp_to_arm_fetch_f64_release_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_sub_vol_
cir.func @test_cpp_to_arm_fetch_f64_release_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_max_ff_
cir.func @test_cpp_to_arm_fetch_f64_release_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_min_ff_
cir.func @test_cpp_to_arm_fetch_f64_release_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_release_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_add_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_add_ff_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_add_vol_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_sub_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_sub_ff_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_sub_vol_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_max_ff_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_min_ff_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_acqrel_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_add_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_add_ff_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_add_vol_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_add_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_sub_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_sub_ff_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_sub_vol_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_sub_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_max_ff_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_max_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_min_ff_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_fetch_f64_seqcst_min_vol_ff_
cir.func @test_cpp_to_arm_fetch_f64_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// --- 6. ATOMIC XCHG ---
// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_relaxed_
cir.func @test_cpp_to_arm_xchg_i8_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_relaxed_vol_
cir.func @test_cpp_to_arm_xchg_i8_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_acquire_
cir.func @test_cpp_to_arm_xchg_i8_acquire_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_acquire_vol_
cir.func @test_cpp_to_arm_xchg_i8_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_release_
cir.func @test_cpp_to_arm_xchg_i8_release_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_release_vol_
cir.func @test_cpp_to_arm_xchg_i8_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_acqrel_
cir.func @test_cpp_to_arm_xchg_i8_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_acqrel_vol_
cir.func @test_cpp_to_arm_xchg_i8_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_seqcst_
cir.func @test_cpp_to_arm_xchg_i8_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i8_seqcst_vol_
cir.func @test_cpp_to_arm_xchg_i8_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_relaxed_
cir.func @test_cpp_to_arm_xchg_i16_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_relaxed_vol_
cir.func @test_cpp_to_arm_xchg_i16_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_acquire_
cir.func @test_cpp_to_arm_xchg_i16_acquire_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_acquire_vol_
cir.func @test_cpp_to_arm_xchg_i16_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_release_
cir.func @test_cpp_to_arm_xchg_i16_release_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_release_vol_
cir.func @test_cpp_to_arm_xchg_i16_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_acqrel_
cir.func @test_cpp_to_arm_xchg_i16_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_acqrel_vol_
cir.func @test_cpp_to_arm_xchg_i16_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_seqcst_
cir.func @test_cpp_to_arm_xchg_i16_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i16_seqcst_vol_
cir.func @test_cpp_to_arm_xchg_i16_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_relaxed_
cir.func @test_cpp_to_arm_xchg_i32_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_relaxed_vol_
cir.func @test_cpp_to_arm_xchg_i32_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_acquire_
cir.func @test_cpp_to_arm_xchg_i32_acquire_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_acquire_vol_
cir.func @test_cpp_to_arm_xchg_i32_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_release_
cir.func @test_cpp_to_arm_xchg_i32_release_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_release_vol_
cir.func @test_cpp_to_arm_xchg_i32_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_acqrel_
cir.func @test_cpp_to_arm_xchg_i32_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_acqrel_vol_
cir.func @test_cpp_to_arm_xchg_i32_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_seqcst_
cir.func @test_cpp_to_arm_xchg_i32_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i32_seqcst_vol_
cir.func @test_cpp_to_arm_xchg_i32_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_relaxed_
cir.func @test_cpp_to_arm_xchg_i64_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_relaxed_vol_
cir.func @test_cpp_to_arm_xchg_i64_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_acquire_
cir.func @test_cpp_to_arm_xchg_i64_acquire_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_acquire_vol_
cir.func @test_cpp_to_arm_xchg_i64_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_release_
cir.func @test_cpp_to_arm_xchg_i64_release_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_release_vol_
cir.func @test_cpp_to_arm_xchg_i64_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_acqrel_
cir.func @test_cpp_to_arm_xchg_i64_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_acqrel_vol_
cir.func @test_cpp_to_arm_xchg_i64_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_seqcst_
cir.func @test_cpp_to_arm_xchg_i64_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_i64_seqcst_vol_
cir.func @test_cpp_to_arm_xchg_i64_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(4 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_relaxed_
cir.func @test_cpp_to_arm_xchg_f32_relaxed_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_relaxed_vol_
cir.func @test_cpp_to_arm_xchg_f32_relaxed_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_acquire_
cir.func @test_cpp_to_arm_xchg_f32_acquire_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_acquire_vol_
cir.func @test_cpp_to_arm_xchg_f32_acquire_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_release_
cir.func @test_cpp_to_arm_xchg_f32_release_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_release_vol_
cir.func @test_cpp_to_arm_xchg_f32_release_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_acqrel_
cir.func @test_cpp_to_arm_xchg_f32_acqrel_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_acqrel_vol_
cir.func @test_cpp_to_arm_xchg_f32_acqrel_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_seqcst_
cir.func @test_cpp_to_arm_xchg_f32_seqcst_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f32_seqcst_vol_
cir.func @test_cpp_to_arm_xchg_f32_seqcst_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(4 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_relaxed_
cir.func @test_cpp_to_arm_xchg_f64_relaxed_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_relaxed_vol_
cir.func @test_cpp_to_arm_xchg_f64_relaxed_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_acquire_
cir.func @test_cpp_to_arm_xchg_f64_acquire_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_acquire_vol_
cir.func @test_cpp_to_arm_xchg_f64_acquire_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_release_
cir.func @test_cpp_to_arm_xchg_f64_release_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_release_vol_
cir.func @test_cpp_to_arm_xchg_f64_release_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_acqrel_
cir.func @test_cpp_to_arm_xchg_f64_acqrel_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_acqrel_vol_
cir.func @test_cpp_to_arm_xchg_f64_acqrel_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_seqcst_
cir.func @test_cpp_to_arm_xchg_f64_seqcst_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_cpp_to_arm_xchg_f64_seqcst_vol_
cir.func @test_cpp_to_arm_xchg_f64_seqcst_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32)
  %0 = cpp_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(4 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

