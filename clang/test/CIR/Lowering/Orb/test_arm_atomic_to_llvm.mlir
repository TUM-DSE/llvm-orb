// === PHASE 4: ArmAtomic -> LLVMIR === 

// RUN: ./../../../../../build/bin/cir-opt tests/test_arm_atomic_to_llvm.mlir --arm-atomic-to-llvm | ./../../../../../build/bin/FileCheck tests/test_arm_atomic_to_llvm.mlir


// --- 1. LOADS ---
// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i8_relaxed
cir.func @test_arm_to_llvm_load_i8_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic monotonic {alignment = 1 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i8_acquire
cir.func @test_arm_to_llvm_load_i8_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 1 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i8_seqcst
cir.func @test_arm_to_llvm_load_i8_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 1 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i16_relaxed
cir.func @test_arm_to_llvm_load_i16_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic monotonic {alignment = 2 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i16_acquire
cir.func @test_arm_to_llvm_load_i16_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 2 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i16_seqcst
cir.func @test_arm_to_llvm_load_i16_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 2 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i32_relaxed
cir.func @test_arm_to_llvm_load_i32_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic monotonic {alignment = 4 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i32_acquire
cir.func @test_arm_to_llvm_load_i32_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 4 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i32_seqcst
cir.func @test_arm_to_llvm_load_i32_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 4 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i64_relaxed
cir.func @test_arm_to_llvm_load_i64_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic monotonic {alignment = 8 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i64_acquire
cir.func @test_arm_to_llvm_load_i64_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 8 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_i64_seqcst
cir.func @test_arm_to_llvm_load_i64_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 8 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_f32_relaxed
cir.func @test_arm_to_llvm_load_f32_relaxed(%arg0 : !cir.ptr<!cir.float>) -> !cir.float {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic monotonic {alignment = 4 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(4) : !cir.ptr<!cir.float>
  cir.return %0 : !cir.float
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_f32_acquire
cir.func @test_arm_to_llvm_load_f32_acquire(%arg0 : !cir.ptr<!cir.float>) -> !cir.float {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 4 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4) : !cir.ptr<!cir.float>
  cir.return %0 : !cir.float
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_f32_seqcst
cir.func @test_arm_to_llvm_load_f32_seqcst(%arg0 : !cir.ptr<!cir.float>) -> !cir.float {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 4 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(4) : !cir.ptr<!cir.float>
  cir.return %0 : !cir.float
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_f64_relaxed
cir.func @test_arm_to_llvm_load_f64_relaxed(%arg0 : !cir.ptr<!cir.double>) -> !cir.double {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic monotonic {alignment = 8 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(0 : i32) align(8) : !cir.ptr<!cir.double>
  cir.return %0 : !cir.double
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_f64_acquire
cir.func @test_arm_to_llvm_load_f64_acquire(%arg0 : !cir.ptr<!cir.double>) -> !cir.double {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 8 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8) : !cir.ptr<!cir.double>
  cir.return %0 : !cir.double
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_load_f64_seqcst
cir.func @test_arm_to_llvm_load_f64_seqcst(%arg0 : !cir.ptr<!cir.double>) -> !cir.double {
  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK: llvm.load volatile [[PTR]] atomic acquire {alignment = 8 : i64}
  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order(1 : i32) align(8) : !cir.ptr<!cir.double>
  cir.return %0 : !cir.double
}

// --- 2. STORES ---
// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i8_relaxed
cir.func @test_arm_to_llvm_store_i8_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic monotonic {alignment = 1 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(1) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i8_release
cir.func @test_arm_to_llvm_store_i8_release(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 1 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(1) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i8_seqcst
cir.func @test_arm_to_llvm_store_i8_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 1 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(1) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i16_relaxed
cir.func @test_arm_to_llvm_store_i16_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic monotonic {alignment = 2 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(2) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i16_release
cir.func @test_arm_to_llvm_store_i16_release(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 2 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(2) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i16_seqcst
cir.func @test_arm_to_llvm_store_i16_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 2 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(2) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i32_relaxed
cir.func @test_arm_to_llvm_store_i32_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic monotonic {alignment = 4 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(4) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i32_release
cir.func @test_arm_to_llvm_store_i32_release(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 4 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i32_seqcst
cir.func @test_arm_to_llvm_store_i32_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 4 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i64_relaxed
cir.func @test_arm_to_llvm_store_i64_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic monotonic {alignment = 8 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(8) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i64_release
cir.func @test_arm_to_llvm_store_i64_release(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 8 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_i64_seqcst
cir.func @test_arm_to_llvm_store_i64_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 8 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_f32_relaxed
cir.func @test_arm_to_llvm_store_f32_relaxed(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic monotonic {alignment = 4 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(4) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_f32_release
cir.func @test_arm_to_llvm_store_f32_release(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 4 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_f32_seqcst
cir.func @test_arm_to_llvm_store_f32_seqcst(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 4 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(4) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_f64_relaxed
cir.func @test_arm_to_llvm_store_f64_relaxed(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic monotonic {alignment = 8 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(0 : i32) align(8) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_f64_release
cir.func @test_arm_to_llvm_store_f64_release(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 8 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_store_f64_seqcst
cir.func @test_arm_to_llvm_store_f64_seqcst(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic release {alignment = 8 : i64}
  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order(2 : i32) align(8) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// --- 3. FENCES ---
// CHECK-LABEL: cir.func @test_arm_to_llvm_fence_relaxed
cir.func @test_arm_to_llvm_fence_relaxed() {
  // CHECK-NOT: llvm.fence
  // CHECK: cir.return
  arm_atomic.atomic_fence memory_order(0 : i32)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fence_acquire
cir.func @test_arm_to_llvm_fence_acquire() {
  // CHECK: llvm.fence acquire
  arm_atomic.atomic_fence memory_order(1 : i32)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fence_release
cir.func @test_arm_to_llvm_fence_release() {
  // CHECK: llvm.fence release
  arm_atomic.atomic_fence memory_order(2 : i32)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fence_acqrel
cir.func @test_arm_to_llvm_fence_acqrel() {
  // CHECK: llvm.fence acq_rel
  arm_atomic.atomic_fence memory_order(3 : i32)
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fence_seqcst
cir.func @test_arm_to_llvm_fence_seqcst() {
  // CHECK: llvm.fence acq_rel
  arm_atomic.atomic_fence memory_order(3 : i32)
  cir.return
}

// --- 4. CMPXCHG ---
// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_relaxed_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i8_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] monotonic monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_relaxed_acquire
cir.func @test_arm_to_llvm_cmpxchg_i8_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_relaxed_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i8_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_acquire_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i8_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_acquire_acquire
cir.func @test_arm_to_llvm_cmpxchg_i8_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_acquire_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i8_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_release_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i8_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] release monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_release_acquire
cir.func @test_arm_to_llvm_cmpxchg_i8_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_release_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i8_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_acqrel_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i8_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_acqrel_acquire
cir.func @test_arm_to_llvm_cmpxchg_i8_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_acqrel_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i8_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_seqcst_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i8_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_seqcst_acquire
cir.func @test_arm_to_llvm_cmpxchg_i8_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i8_seqcst_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i8_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 1 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(1) : !cir.ptr<!cir.int<s, 8>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_relaxed_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i16_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] monotonic monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_relaxed_acquire
cir.func @test_arm_to_llvm_cmpxchg_i16_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_relaxed_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i16_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_acquire_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i16_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_acquire_acquire
cir.func @test_arm_to_llvm_cmpxchg_i16_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_acquire_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i16_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_release_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i16_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] release monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_release_acquire
cir.func @test_arm_to_llvm_cmpxchg_i16_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_release_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i16_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_acqrel_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i16_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_acqrel_acquire
cir.func @test_arm_to_llvm_cmpxchg_i16_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_acqrel_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i16_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_seqcst_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i16_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_seqcst_acquire
cir.func @test_arm_to_llvm_cmpxchg_i16_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i16_seqcst_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i16_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 2 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(2) : !cir.ptr<!cir.int<s, 16>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_relaxed_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i32_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] monotonic monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_relaxed_acquire
cir.func @test_arm_to_llvm_cmpxchg_i32_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_relaxed_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i32_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_acquire_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i32_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_acquire_acquire
cir.func @test_arm_to_llvm_cmpxchg_i32_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_acquire_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i32_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_release_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i32_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] release monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_release_acquire
cir.func @test_arm_to_llvm_cmpxchg_i32_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_release_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i32_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_acqrel_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i32_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_acqrel_acquire
cir.func @test_arm_to_llvm_cmpxchg_i32_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_acqrel_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i32_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_seqcst_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i32_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_seqcst_acquire
cir.func @test_arm_to_llvm_cmpxchg_i32_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i32_seqcst_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i32_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 4 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(4) : !cir.ptr<!cir.int<s, 32>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_relaxed_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i64_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] monotonic monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(0 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_relaxed_acquire
cir.func @test_arm_to_llvm_cmpxchg_i64_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_relaxed_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i64_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_acquire_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i64_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_acquire_acquire
cir.func @test_arm_to_llvm_cmpxchg_i64_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acquire monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(1 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_acquire_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i64_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_release_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i64_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] release monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(2 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_release_acquire
cir.func @test_arm_to_llvm_cmpxchg_i64_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_release_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i64_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_acqrel_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i64_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_acqrel_acquire
cir.func @test_arm_to_llvm_cmpxchg_i64_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_acqrel_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i64_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_seqcst_relaxed
cir.func @test_arm_to_llvm_cmpxchg_i64_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_seqcst_acquire
cir.func @test_arm_to_llvm_cmpxchg_i64_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_cmpxchg_i64_seqcst_seqcst
cir.func @test_arm_to_llvm_cmpxchg_i64_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2
  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] acq_rel monotonic {alignment = 8 : i64}
  // CHECK-DAG: llvm.extractvalue [[RES]][0]
  // CHECK-DAG: llvm.extractvalue [[RES]][1]
  %0:2 = arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order(3 : i32) failure_order(0 : i32) align(8) : !cir.ptr<!cir.int<s, 64>>, !cir.bool
  cir.return
}

// --- 5. ATOMIC FETCH ---
// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_add_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_add_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_add_vol_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_sub_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_sub_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_sub_vol_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_and_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_and_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_and_vol_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_or_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_or_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_or_vol_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_xor_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_xor_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_xor_vol_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_nand_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_max_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_min_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_relaxed_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_add_
cir.func @test_arm_to_llvm_fetch_i8_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acquire
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_add_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_add_vol_
cir.func @test_arm_to_llvm_fetch_i8_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acquire
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_sub_
cir.func @test_arm_to_llvm_fetch_i8_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_sub_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_sub_vol_
cir.func @test_arm_to_llvm_fetch_i8_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_and_
cir.func @test_arm_to_llvm_fetch_i8_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acquire
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_and_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_and_vol_
cir.func @test_arm_to_llvm_fetch_i8_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acquire
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_or_
cir.func @test_arm_to_llvm_fetch_i8_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acquire
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_or_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_or_vol_
cir.func @test_arm_to_llvm_fetch_i8_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acquire
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_xor_
cir.func @test_arm_to_llvm_fetch_i8_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acquire
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_xor_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_xor_vol_
cir.func @test_arm_to_llvm_fetch_i8_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acquire
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_nand_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_max_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_min_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acquire_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_add_
cir.func @test_arm_to_llvm_fetch_i8_release_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] release
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_add_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_add_vol_
cir.func @test_arm_to_llvm_fetch_i8_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] release
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_sub_
cir.func @test_arm_to_llvm_fetch_i8_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] release
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_sub_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_sub_vol_
cir.func @test_arm_to_llvm_fetch_i8_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] release
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_and_
cir.func @test_arm_to_llvm_fetch_i8_release_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] release
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_and_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_and_vol_
cir.func @test_arm_to_llvm_fetch_i8_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] release
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_or_
cir.func @test_arm_to_llvm_fetch_i8_release_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] release
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_or_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_or_vol_
cir.func @test_arm_to_llvm_fetch_i8_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] release
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_xor_
cir.func @test_arm_to_llvm_fetch_i8_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] release
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_xor_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_xor_vol_
cir.func @test_arm_to_llvm_fetch_i8_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] release
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_nand_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_max_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_min_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_release_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_add_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_add_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_add_vol_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_sub_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_sub_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_sub_vol_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_and_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_and_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_and_vol_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_or_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_or_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_or_vol_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_xor_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_xor_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_xor_vol_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_nand_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_max_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_min_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_acqrel_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_add_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_add_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_add_vol_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_sub_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_sub_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_sub_vol_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_and_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_and_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_and_vol_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_or_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_or_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_or_vol_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_xor_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_xor_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_xor_vol_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_nand_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_max_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_min_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i8_seqcst_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i8_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_add_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_add_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_add_vol_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_sub_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_sub_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_sub_vol_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_and_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_and_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_and_vol_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_or_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_or_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_or_vol_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_xor_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_xor_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_xor_vol_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_nand_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_max_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_min_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_relaxed_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_add_
cir.func @test_arm_to_llvm_fetch_i16_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acquire
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_add_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_add_vol_
cir.func @test_arm_to_llvm_fetch_i16_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acquire
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_sub_
cir.func @test_arm_to_llvm_fetch_i16_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_sub_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_sub_vol_
cir.func @test_arm_to_llvm_fetch_i16_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_and_
cir.func @test_arm_to_llvm_fetch_i16_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acquire
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_and_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_and_vol_
cir.func @test_arm_to_llvm_fetch_i16_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acquire
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_or_
cir.func @test_arm_to_llvm_fetch_i16_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acquire
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_or_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_or_vol_
cir.func @test_arm_to_llvm_fetch_i16_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acquire
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_xor_
cir.func @test_arm_to_llvm_fetch_i16_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acquire
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_xor_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_xor_vol_
cir.func @test_arm_to_llvm_fetch_i16_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acquire
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_nand_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_max_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_min_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acquire_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_add_
cir.func @test_arm_to_llvm_fetch_i16_release_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] release
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_add_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_add_vol_
cir.func @test_arm_to_llvm_fetch_i16_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] release
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_sub_
cir.func @test_arm_to_llvm_fetch_i16_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] release
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_sub_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_sub_vol_
cir.func @test_arm_to_llvm_fetch_i16_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] release
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_and_
cir.func @test_arm_to_llvm_fetch_i16_release_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] release
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_and_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_and_vol_
cir.func @test_arm_to_llvm_fetch_i16_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] release
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_or_
cir.func @test_arm_to_llvm_fetch_i16_release_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] release
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_or_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_or_vol_
cir.func @test_arm_to_llvm_fetch_i16_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] release
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_xor_
cir.func @test_arm_to_llvm_fetch_i16_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] release
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_xor_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_xor_vol_
cir.func @test_arm_to_llvm_fetch_i16_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] release
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_nand_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_max_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_min_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_release_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_add_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_add_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_add_vol_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_sub_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_sub_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_sub_vol_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_and_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_and_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_and_vol_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_or_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_or_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_or_vol_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_xor_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_xor_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_xor_vol_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_nand_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_max_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_min_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_acqrel_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_add_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_add_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_add_vol_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_sub_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_sub_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_sub_vol_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_and_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_and_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_and_vol_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_or_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_or_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_or_vol_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_xor_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_xor_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_xor_vol_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_nand_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_max_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_min_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i16_seqcst_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i16_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_add_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_add_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_add_vol_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_sub_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_sub_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_sub_vol_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_and_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_and_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_and_vol_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_or_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_or_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_or_vol_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_xor_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_xor_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_xor_vol_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_nand_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_max_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_min_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_relaxed_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_add_
cir.func @test_arm_to_llvm_fetch_i32_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acquire
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_add_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_add_vol_
cir.func @test_arm_to_llvm_fetch_i32_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acquire
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_sub_
cir.func @test_arm_to_llvm_fetch_i32_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_sub_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_sub_vol_
cir.func @test_arm_to_llvm_fetch_i32_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_and_
cir.func @test_arm_to_llvm_fetch_i32_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acquire
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_and_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_and_vol_
cir.func @test_arm_to_llvm_fetch_i32_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acquire
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_or_
cir.func @test_arm_to_llvm_fetch_i32_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acquire
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_or_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_or_vol_
cir.func @test_arm_to_llvm_fetch_i32_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acquire
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_xor_
cir.func @test_arm_to_llvm_fetch_i32_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acquire
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_xor_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_xor_vol_
cir.func @test_arm_to_llvm_fetch_i32_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acquire
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_nand_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_max_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_min_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acquire_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_add_
cir.func @test_arm_to_llvm_fetch_i32_release_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] release
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_add_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_add_vol_
cir.func @test_arm_to_llvm_fetch_i32_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] release
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_sub_
cir.func @test_arm_to_llvm_fetch_i32_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] release
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_sub_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_sub_vol_
cir.func @test_arm_to_llvm_fetch_i32_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] release
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_and_
cir.func @test_arm_to_llvm_fetch_i32_release_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] release
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_and_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_and_vol_
cir.func @test_arm_to_llvm_fetch_i32_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] release
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_or_
cir.func @test_arm_to_llvm_fetch_i32_release_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] release
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_or_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_or_vol_
cir.func @test_arm_to_llvm_fetch_i32_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] release
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_xor_
cir.func @test_arm_to_llvm_fetch_i32_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] release
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_xor_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_xor_vol_
cir.func @test_arm_to_llvm_fetch_i32_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] release
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_nand_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_max_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_min_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_release_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_add_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_add_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_add_vol_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_sub_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_sub_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_sub_vol_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_and_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_and_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_and_vol_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_or_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_or_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_or_vol_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_xor_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_xor_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_xor_vol_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_nand_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_max_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_min_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_acqrel_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_add_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_add_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_add_vol_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_sub_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_sub_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_sub_vol_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_and_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_and_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_and_vol_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_or_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_or_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_or_vol_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_xor_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_xor_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_xor_vol_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_nand_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_max_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_min_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i32_seqcst_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i32_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_add_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_add_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_add_vol_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_sub_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_sub_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_sub_vol_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_and_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_and_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_and_vol_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_or_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_or_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_or_vol_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_xor_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_xor_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_xor_vol_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_nand_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_max_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_min_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_relaxed_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_add_
cir.func @test_arm_to_llvm_fetch_i64_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acquire
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_add_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_add_vol_
cir.func @test_arm_to_llvm_fetch_i64_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acquire
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_sub_
cir.func @test_arm_to_llvm_fetch_i64_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_sub_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_sub_vol_
cir.func @test_arm_to_llvm_fetch_i64_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_and_
cir.func @test_arm_to_llvm_fetch_i64_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acquire
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_and_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_and_vol_
cir.func @test_arm_to_llvm_fetch_i64_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acquire
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_or_
cir.func @test_arm_to_llvm_fetch_i64_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acquire
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_or_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_or_vol_
cir.func @test_arm_to_llvm_fetch_i64_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acquire
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_xor_
cir.func @test_arm_to_llvm_fetch_i64_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acquire
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_xor_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_xor_vol_
cir.func @test_arm_to_llvm_fetch_i64_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acquire
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_nand_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_max_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_min_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acquire_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_add_
cir.func @test_arm_to_llvm_fetch_i64_release_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] release
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_add_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_add_vol_
cir.func @test_arm_to_llvm_fetch_i64_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] release
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_sub_
cir.func @test_arm_to_llvm_fetch_i64_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] release
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_sub_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_sub_vol_
cir.func @test_arm_to_llvm_fetch_i64_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] release
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_and_
cir.func @test_arm_to_llvm_fetch_i64_release_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] release
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_and_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_and_vol_
cir.func @test_arm_to_llvm_fetch_i64_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] release
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_or_
cir.func @test_arm_to_llvm_fetch_i64_release_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] release
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_or_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_or_vol_
cir.func @test_arm_to_llvm_fetch_i64_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] release
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_xor_
cir.func @test_arm_to_llvm_fetch_i64_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] release
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_xor_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_xor_vol_
cir.func @test_arm_to_llvm_fetch_i64_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] release
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_nand_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_max_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_min_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_release_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_add_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_add_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_add_vol_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_sub_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_sub_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_sub_vol_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_and_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_and_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_and_vol_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_or_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_or_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_or_vol_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_xor_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_xor_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_xor_vol_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_nand_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_max_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_min_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_acqrel_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_add_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_add_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_add_vol_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.add [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile add [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_sub_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_sub_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_sub_vol_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.sub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile sub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_and_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_and_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_and_vol_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.and [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_and_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _and [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 2 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_or_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_or_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_or_vol_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.or [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_or_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _or [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 3 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_xor_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_xor_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_xor_vol_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.xor [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_xor_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile _xor [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 4 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_nand_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_nand_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile nand [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 5 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_max_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile max [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_min_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_i64_seqcst_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_i64_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile min [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_add_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_add_ff_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_add_vol_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_sub_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_sub_ff_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_sub_vol_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_max_ff_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_min_ff_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_relaxed_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_add_
cir.func @test_arm_to_llvm_fetch_f32_acquire_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acquire
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_add_ff_
cir.func @test_arm_to_llvm_fetch_f32_acquire_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_add_vol_
cir.func @test_arm_to_llvm_fetch_f32_acquire_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acquire
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_sub_
cir.func @test_arm_to_llvm_fetch_f32_acquire_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_sub_ff_
cir.func @test_arm_to_llvm_fetch_f32_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_sub_vol_
cir.func @test_arm_to_llvm_fetch_f32_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_max_ff_
cir.func @test_arm_to_llvm_fetch_f32_acquire_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_min_ff_
cir.func @test_arm_to_llvm_fetch_f32_acquire_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acquire_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_add_
cir.func @test_arm_to_llvm_fetch_f32_release_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] release
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_add_ff_
cir.func @test_arm_to_llvm_fetch_f32_release_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_add_vol_
cir.func @test_arm_to_llvm_fetch_f32_release_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] release
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_sub_
cir.func @test_arm_to_llvm_fetch_f32_release_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] release
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_sub_ff_
cir.func @test_arm_to_llvm_fetch_f32_release_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_sub_vol_
cir.func @test_arm_to_llvm_fetch_f32_release_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] release
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_max_ff_
cir.func @test_arm_to_llvm_fetch_f32_release_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_min_ff_
cir.func @test_arm_to_llvm_fetch_f32_release_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_release_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_add_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_add_ff_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_add_vol_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_sub_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_sub_ff_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_sub_vol_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_max_ff_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_min_ff_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_acqrel_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_add_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_add_ff_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_add_vol_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_sub_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_sub_ff_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_sub_vol_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_max_ff_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_min_ff_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f32_seqcst_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f32_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_add_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_add_ff_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_add_vol_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_sub_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_sub_ff_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_sub_vol_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] monotonic
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_max_ff_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_min_ff_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_relaxed_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_add_
cir.func @test_arm_to_llvm_fetch_f64_acquire_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acquire
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_add_ff_
cir.func @test_arm_to_llvm_fetch_f64_acquire_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_add_vol_
cir.func @test_arm_to_llvm_fetch_f64_acquire_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acquire
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_sub_
cir.func @test_arm_to_llvm_fetch_f64_acquire_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_sub_ff_
cir.func @test_arm_to_llvm_fetch_f64_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_sub_vol_
cir.func @test_arm_to_llvm_fetch_f64_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acquire
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_max_ff_
cir.func @test_arm_to_llvm_fetch_f64_acquire_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_min_ff_
cir.func @test_arm_to_llvm_fetch_f64_acquire_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acquire_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_add_
cir.func @test_arm_to_llvm_fetch_f64_release_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] release
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_add_ff_
cir.func @test_arm_to_llvm_fetch_f64_release_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_add_vol_
cir.func @test_arm_to_llvm_fetch_f64_release_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] release
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_sub_
cir.func @test_arm_to_llvm_fetch_f64_release_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] release
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_sub_ff_
cir.func @test_arm_to_llvm_fetch_f64_release_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_sub_vol_
cir.func @test_arm_to_llvm_fetch_f64_release_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] release
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_max_ff_
cir.func @test_arm_to_llvm_fetch_f64_release_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_min_ff_
cir.func @test_arm_to_llvm_fetch_f64_release_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_release_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_add_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_add_ff_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_add_vol_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_sub_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_sub_ff_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_sub_vol_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_max_ff_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_min_ff_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_acqrel_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_add_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_add_ff_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fadd [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_add_vol_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fadd [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_add_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fadd [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 0 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_sub_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_sub_ff_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fsub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_sub_vol_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acq_rel
  // CHECK: llvm.fsub [[RES]], [[VAL]]
  %0 = arm_atomic.atomic_fetch volatile 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_sub_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fsub [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 1 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_max_ff_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmax [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_max_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmax [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 6 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_min_ff_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw fmin [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_fetch_f64_seqcst_min_vol_ff_
cir.func @test_arm_to_llvm_fetch_f64_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile fmin [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_fetch volatile fetch_first 7 : i32 %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// --- 6. ATOMIC XCHG ---
// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_relaxed_
cir.func @test_arm_to_llvm_xchg_i8_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_relaxed_vol_
cir.func @test_arm_to_llvm_xchg_i8_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_acquire_
cir.func @test_arm_to_llvm_xchg_i8_acquire_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_acquire_vol_
cir.func @test_arm_to_llvm_xchg_i8_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_release_
cir.func @test_arm_to_llvm_xchg_i8_release_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_release_vol_
cir.func @test_arm_to_llvm_xchg_i8_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_acqrel_
cir.func @test_arm_to_llvm_xchg_i8_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_acqrel_vol_
cir.func @test_arm_to_llvm_xchg_i8_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_seqcst_
cir.func @test_arm_to_llvm_xchg_i8_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i8_seqcst_vol_
cir.func @test_arm_to_llvm_xchg_i8_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_relaxed_
cir.func @test_arm_to_llvm_xchg_i16_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_relaxed_vol_
cir.func @test_arm_to_llvm_xchg_i16_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_acquire_
cir.func @test_arm_to_llvm_xchg_i16_acquire_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_acquire_vol_
cir.func @test_arm_to_llvm_xchg_i16_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_release_
cir.func @test_arm_to_llvm_xchg_i16_release_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_release_vol_
cir.func @test_arm_to_llvm_xchg_i16_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_acqrel_
cir.func @test_arm_to_llvm_xchg_i16_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_acqrel_vol_
cir.func @test_arm_to_llvm_xchg_i16_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_seqcst_
cir.func @test_arm_to_llvm_xchg_i16_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i16_seqcst_vol_
cir.func @test_arm_to_llvm_xchg_i16_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_relaxed_
cir.func @test_arm_to_llvm_xchg_i32_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_relaxed_vol_
cir.func @test_arm_to_llvm_xchg_i32_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_acquire_
cir.func @test_arm_to_llvm_xchg_i32_acquire_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_acquire_vol_
cir.func @test_arm_to_llvm_xchg_i32_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_release_
cir.func @test_arm_to_llvm_xchg_i32_release_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_release_vol_
cir.func @test_arm_to_llvm_xchg_i32_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_acqrel_
cir.func @test_arm_to_llvm_xchg_i32_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_acqrel_vol_
cir.func @test_arm_to_llvm_xchg_i32_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_seqcst_
cir.func @test_arm_to_llvm_xchg_i32_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i32_seqcst_vol_
cir.func @test_arm_to_llvm_xchg_i32_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_relaxed_
cir.func @test_arm_to_llvm_xchg_i64_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_relaxed_vol_
cir.func @test_arm_to_llvm_xchg_i64_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_acquire_
cir.func @test_arm_to_llvm_xchg_i64_acquire_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_acquire_vol_
cir.func @test_arm_to_llvm_xchg_i64_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_release_
cir.func @test_arm_to_llvm_xchg_i64_release_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_release_vol_
cir.func @test_arm_to_llvm_xchg_i64_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_acqrel_
cir.func @test_arm_to_llvm_xchg_i64_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_acqrel_vol_
cir.func @test_arm_to_llvm_xchg_i64_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_seqcst_
cir.func @test_arm_to_llvm_xchg_i64_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_i64_seqcst_vol_
cir.func @test_arm_to_llvm_xchg_i64_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_relaxed_
cir.func @test_arm_to_llvm_xchg_f32_relaxed_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_relaxed_vol_
cir.func @test_arm_to_llvm_xchg_f32_relaxed_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_acquire_
cir.func @test_arm_to_llvm_xchg_f32_acquire_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_acquire_vol_
cir.func @test_arm_to_llvm_xchg_f32_acquire_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_release_
cir.func @test_arm_to_llvm_xchg_f32_release_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_release_vol_
cir.func @test_arm_to_llvm_xchg_f32_release_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_acqrel_
cir.func @test_arm_to_llvm_xchg_f32_acqrel_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_acqrel_vol_
cir.func @test_arm_to_llvm_xchg_f32_acqrel_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_seqcst_
cir.func @test_arm_to_llvm_xchg_f32_seqcst_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f32_seqcst_vol_
cir.func @test_arm_to_llvm_xchg_f32_seqcst_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_relaxed_
cir.func @test_arm_to_llvm_xchg_f64_relaxed_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_relaxed_vol_
cir.func @test_arm_to_llvm_xchg_f64_relaxed_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] monotonic
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(0 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_acquire_
cir.func @test_arm_to_llvm_xchg_f64_acquire_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_acquire_vol_
cir.func @test_arm_to_llvm_xchg_f64_acquire_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acquire
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(1 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_release_
cir.func @test_arm_to_llvm_xchg_f64_release_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_release_vol_
cir.func @test_arm_to_llvm_xchg_f64_release_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] release
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(2 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_acqrel_
cir.func @test_arm_to_llvm_xchg_f64_acqrel_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_acqrel_vol_
cir.func @test_arm_to_llvm_xchg_f64_acqrel_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_seqcst_
cir.func @test_arm_to_llvm_xchg_f64_seqcst_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: cir.func @test_arm_to_llvm_xchg_f64_seqcst_vol_
cir.func @test_arm_to_llvm_xchg_f64_seqcst_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) {
  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0
  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1
  // CHECK: [[RES:%.*]] = llvm.atomicrmw volatile xchg [[PTR]], [[VAL]] acq_rel
  %0 = arm_atomic.atomic_xchg volatile %arg1, %arg0 memory_order(3 : i32) : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

