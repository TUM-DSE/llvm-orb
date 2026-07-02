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

