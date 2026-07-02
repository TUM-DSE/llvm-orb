// === PHASE 3: CIR -> ArmAtomic === 

// RUN: ./../../../../../build/bin/cir-opt tests/test_cir_to_arm_atomic.mlir --cir-to-cpp-atomic --cpp-atomic-to-arm-atomic | ./../../../../../build/bin/FileCheck tests/test_cir_to_arm_atomic.mlir


// --- 1. LOADS ---
// CHECK-LABEL: cir.func @test_arm_load_i8_relaxed
cir.func @test_arm_load_i8_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(1)
  %0 = cir.load deref volatile align(1) atomic(relaxed) %arg0 : !cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: cir.func @test_arm_load_i8_acquire
cir.func @test_arm_load_i8_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(1)
  %0 = cir.load deref volatile align(1) atomic(acquire) %arg0 : !cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: cir.func @test_arm_load_i8_seqcst
cir.func @test_arm_load_i8_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(1)
  %0 = cir.load deref volatile align(1) atomic(seq_cst) %arg0 : !cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: cir.func @test_arm_load_i16_relaxed
cir.func @test_arm_load_i16_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(2)
  %0 = cir.load deref volatile align(2) atomic(relaxed) %arg0 : !cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: cir.func @test_arm_load_i16_acquire
cir.func @test_arm_load_i16_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(2)
  %0 = cir.load deref volatile align(2) atomic(acquire) %arg0 : !cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: cir.func @test_arm_load_i16_seqcst
cir.func @test_arm_load_i16_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(2)
  %0 = cir.load deref volatile align(2) atomic(seq_cst) %arg0 : !cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: cir.func @test_arm_load_i32_relaxed
cir.func @test_arm_load_i32_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(4)
  %0 = cir.load deref volatile align(4) atomic(relaxed) %arg0 : !cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: cir.func @test_arm_load_i32_acquire
cir.func @test_arm_load_i32_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4)
  %0 = cir.load deref volatile align(4) atomic(acquire) %arg0 : !cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: cir.func @test_arm_load_i32_seqcst
cir.func @test_arm_load_i32_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4)
  %0 = cir.load deref volatile align(4) atomic(seq_cst) %arg0 : !cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: cir.func @test_arm_load_i64_relaxed
cir.func @test_arm_load_i64_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(8)
  %0 = cir.load deref volatile align(8) atomic(relaxed) %arg0 : !cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: cir.func @test_arm_load_i64_acquire
cir.func @test_arm_load_i64_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8)
  %0 = cir.load deref volatile align(8) atomic(acquire) %arg0 : !cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: cir.func @test_arm_load_i64_seqcst
cir.func @test_arm_load_i64_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8)
  %0 = cir.load deref volatile align(8) atomic(seq_cst) %arg0 : !cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: cir.func @test_arm_load_f32_relaxed
cir.func @test_arm_load_f32_relaxed(%arg0 : !cir.ptr<!cir.float>) -> !cir.float {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(4)
  %0 = cir.load deref volatile align(4) atomic(relaxed) %arg0 : !cir.ptr<!cir.float>, !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: cir.func @test_arm_load_f32_acquire
cir.func @test_arm_load_f32_acquire(%arg0 : !cir.ptr<!cir.float>) -> !cir.float {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4)
  %0 = cir.load deref volatile align(4) atomic(acquire) %arg0 : !cir.ptr<!cir.float>, !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: cir.func @test_arm_load_f32_seqcst
cir.func @test_arm_load_f32_seqcst(%arg0 : !cir.ptr<!cir.float>) -> !cir.float {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4)
  %0 = cir.load deref volatile align(4) atomic(seq_cst) %arg0 : !cir.ptr<!cir.float>, !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: cir.func @test_arm_load_f64_relaxed
cir.func @test_arm_load_f64_relaxed(%arg0 : !cir.ptr<!cir.double>) -> !cir.double {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(8)
  %0 = cir.load deref volatile align(8) atomic(relaxed) %arg0 : !cir.ptr<!cir.double>, !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: cir.func @test_arm_load_f64_acquire
cir.func @test_arm_load_f64_acquire(%arg0 : !cir.ptr<!cir.double>) -> !cir.double {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8)
  %0 = cir.load deref volatile align(8) atomic(acquire) %arg0 : !cir.ptr<!cir.double>, !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: cir.func @test_arm_load_f64_seqcst
cir.func @test_arm_load_f64_seqcst(%arg0 : !cir.ptr<!cir.double>) -> !cir.double {
  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8)
  %0 = cir.load deref volatile align(8) atomic(seq_cst) %arg0 : !cir.ptr<!cir.double>, !cir.double
  cir.return %0 : !cir.double
}

// --- 2. STORES ---
// CHECK-LABEL: cir.func @test_arm_store_i8_relaxed
cir.func @test_arm_store_i8_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(1)
  cir.store volatile align(1) atomic(relaxed) %arg1, %arg0 : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i8_release
cir.func @test_arm_store_i8_release(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(1)
  cir.store volatile align(1) atomic(release) %arg1, %arg0 : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i8_seqcst
cir.func @test_arm_store_i8_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(1)
  cir.store volatile align(1) atomic(seq_cst) %arg1, %arg0 : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i16_relaxed
cir.func @test_arm_store_i16_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(2)
  cir.store volatile align(2) atomic(relaxed) %arg1, %arg0 : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i16_release
cir.func @test_arm_store_i16_release(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(2)
  cir.store volatile align(2) atomic(release) %arg1, %arg0 : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i16_seqcst
cir.func @test_arm_store_i16_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(2)
  cir.store volatile align(2) atomic(seq_cst) %arg1, %arg0 : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i32_relaxed
cir.func @test_arm_store_i32_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(4)
  cir.store volatile align(4) atomic(relaxed) %arg1, %arg0 : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i32_release
cir.func @test_arm_store_i32_release(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4)
  cir.store volatile align(4) atomic(release) %arg1, %arg0 : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i32_seqcst
cir.func @test_arm_store_i32_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4)
  cir.store volatile align(4) atomic(seq_cst) %arg1, %arg0 : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i64_relaxed
cir.func @test_arm_store_i64_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(8)
  cir.store volatile align(8) atomic(relaxed) %arg1, %arg0 : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i64_release
cir.func @test_arm_store_i64_release(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8)
  cir.store volatile align(8) atomic(release) %arg1, %arg0 : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_i64_seqcst
cir.func @test_arm_store_i64_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8)
  cir.store volatile align(8) atomic(seq_cst) %arg1, %arg0 : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f32_relaxed
cir.func @test_arm_store_f32_relaxed(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(4)
  cir.store volatile align(4) atomic(relaxed) %arg1, %arg0 : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f32_release
cir.func @test_arm_store_f32_release(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4)
  cir.store volatile align(4) atomic(release) %arg1, %arg0 : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f32_seqcst
cir.func @test_arm_store_f32_seqcst(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4)
  cir.store volatile align(4) atomic(seq_cst) %arg1, %arg0 : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f64_relaxed
cir.func @test_arm_store_f64_relaxed(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(8)
  cir.store volatile align(8) atomic(relaxed) %arg1, %arg0 : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f64_release
cir.func @test_arm_store_f64_release(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8)
  cir.store volatile align(8) atomic(release) %arg1, %arg0 : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_store_f64_seqcst
cir.func @test_arm_store_f64_seqcst(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8)
  cir.store volatile align(8) atomic(seq_cst) %arg1, %arg0 : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// --- 3. FENCES ---
// CHECK-LABEL: cir.func @test_arm_fence_acquire
cir.func @test_arm_fence_acquire() {
  // CHECK: arm_atomic.atomic_fence memory_order(1 : i32)
  cir.atomic.fence syncscope(system) acquire
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_fence_release
cir.func @test_arm_fence_release() {
  // CHECK: arm_atomic.atomic_fence memory_order(2 : i32)
  cir.atomic.fence syncscope(system) release
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_fence_acqrel
cir.func @test_arm_fence_acqrel() {
  // CHECK: arm_atomic.atomic_fence memory_order(3 : i32)
  cir.atomic.fence syncscope(system) acq_rel
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_fence_seqcst
cir.func @test_arm_fence_seqcst() {
  // CHECK: arm_atomic.atomic_fence memory_order(3 : i32)
  cir.atomic.fence syncscope(system) seq_cst
  cir.return
}

// --- 4. CMPXCHG ---
// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_relaxed_relaxed
cir.func @test_arm_cmpxchg_i8_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_relaxed_acquire
cir.func @test_arm_cmpxchg_i8_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_relaxed_seqcst
cir.func @test_arm_cmpxchg_i8_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acquire_relaxed
cir.func @test_arm_cmpxchg_i8_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acquire_acquire
cir.func @test_arm_cmpxchg_i8_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acquire_seqcst
cir.func @test_arm_cmpxchg_i8_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_release_relaxed
cir.func @test_arm_cmpxchg_i8_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(release) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_release_acquire
cir.func @test_arm_cmpxchg_i8_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(release) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_release_seqcst
cir.func @test_arm_cmpxchg_i8_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(release) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acqrel_relaxed
cir.func @test_arm_cmpxchg_i8_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acqrel_acquire
cir.func @test_arm_cmpxchg_i8_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_acqrel_seqcst
cir.func @test_arm_cmpxchg_i8_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_seqcst_relaxed
cir.func @test_arm_cmpxchg_i8_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_seqcst_acquire
cir.func @test_arm_cmpxchg_i8_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i8_seqcst_seqcst
cir.func @test_arm_cmpxchg_i8_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_relaxed_relaxed
cir.func @test_arm_cmpxchg_i16_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_relaxed_acquire
cir.func @test_arm_cmpxchg_i16_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_relaxed_seqcst
cir.func @test_arm_cmpxchg_i16_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acquire_relaxed
cir.func @test_arm_cmpxchg_i16_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acquire_acquire
cir.func @test_arm_cmpxchg_i16_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acquire_seqcst
cir.func @test_arm_cmpxchg_i16_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_release_relaxed
cir.func @test_arm_cmpxchg_i16_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(release) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_release_acquire
cir.func @test_arm_cmpxchg_i16_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(release) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_release_seqcst
cir.func @test_arm_cmpxchg_i16_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(release) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acqrel_relaxed
cir.func @test_arm_cmpxchg_i16_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acqrel_acquire
cir.func @test_arm_cmpxchg_i16_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_acqrel_seqcst
cir.func @test_arm_cmpxchg_i16_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_seqcst_relaxed
cir.func @test_arm_cmpxchg_i16_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_seqcst_acquire
cir.func @test_arm_cmpxchg_i16_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i16_seqcst_seqcst
cir.func @test_arm_cmpxchg_i16_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_relaxed_relaxed
cir.func @test_arm_cmpxchg_i32_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_relaxed_acquire
cir.func @test_arm_cmpxchg_i32_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_relaxed_seqcst
cir.func @test_arm_cmpxchg_i32_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acquire_relaxed
cir.func @test_arm_cmpxchg_i32_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acquire_acquire
cir.func @test_arm_cmpxchg_i32_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acquire_seqcst
cir.func @test_arm_cmpxchg_i32_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_release_relaxed
cir.func @test_arm_cmpxchg_i32_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(release) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_release_acquire
cir.func @test_arm_cmpxchg_i32_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(release) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_release_seqcst
cir.func @test_arm_cmpxchg_i32_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(release) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acqrel_relaxed
cir.func @test_arm_cmpxchg_i32_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acqrel_acquire
cir.func @test_arm_cmpxchg_i32_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_acqrel_seqcst
cir.func @test_arm_cmpxchg_i32_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_seqcst_relaxed
cir.func @test_arm_cmpxchg_i32_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_seqcst_acquire
cir.func @test_arm_cmpxchg_i32_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i32_seqcst_seqcst
cir.func @test_arm_cmpxchg_i32_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_relaxed_relaxed
cir.func @test_arm_cmpxchg_i64_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_relaxed_acquire
cir.func @test_arm_cmpxchg_i64_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_relaxed_seqcst
cir.func @test_arm_cmpxchg_i64_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acquire_relaxed
cir.func @test_arm_cmpxchg_i64_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acquire_acquire
cir.func @test_arm_cmpxchg_i64_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acquire_seqcst
cir.func @test_arm_cmpxchg_i64_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_release_relaxed
cir.func @test_arm_cmpxchg_i64_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(release) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_release_acquire
cir.func @test_arm_cmpxchg_i64_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(release) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_release_seqcst
cir.func @test_arm_cmpxchg_i64_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(release) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acqrel_relaxed
cir.func @test_arm_cmpxchg_i64_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acqrel_acquire
cir.func @test_arm_cmpxchg_i64_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_acqrel_seqcst
cir.func @test_arm_cmpxchg_i64_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_seqcst_relaxed
cir.func @test_arm_cmpxchg_i64_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_seqcst_acquire
cir.func @test_arm_cmpxchg_i64_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_cmpxchg_i64_seqcst_seqcst
cir.func @test_arm_cmpxchg_i64_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK: arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8)
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

