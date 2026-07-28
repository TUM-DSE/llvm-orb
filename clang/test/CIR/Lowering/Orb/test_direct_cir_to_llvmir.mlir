// === PHASE 7: Direct CIR -> LLVMIR === 

// RUN: ./../../../../../build/bin/cir-translate tests/test_direct_cir_to_llvmir.mlir -cir-to-llvmir --target x86_64-unknown-linux-gnu --disable-cc-lowering | ./../../../../../build/bin/FileCheck tests/test_direct_cir_to_llvmir.mlir


// CHECK-LABEL: define i8 @test_cir_to_llvm_load_i8_relaxed
// CHECK: %{{[0-9]+}} = load atomic volatile i8, ptr %{{[0-9]+}} monotonic, align 1
cir.func @test_cir_to_llvm_load_i8_relaxed(%arg0: !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  %0 = cir.load deref volatile align(1) atomic(relaxed) %arg0 : !cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_cir_to_llvm_load_i8_acquire
// CHECK: %{{[0-9]+}} = load atomic volatile i8, ptr %{{[0-9]+}} acquire, align 1
cir.func @test_cir_to_llvm_load_i8_acquire(%arg0: !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  %0 = cir.load deref volatile align(1) atomic(acquire) %arg0 : !cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_cir_to_llvm_load_i8_seq_cst
// CHECK: %{{[0-9]+}} = load atomic volatile i8, ptr %{{[0-9]+}} seq_cst, align 1
cir.func @test_cir_to_llvm_load_i8_seq_cst(%arg0: !cir.ptr<!cir.int<s, 8>>) -> !cir.int<s, 8> {
  %0 = cir.load deref volatile align(1) atomic(seq_cst) %arg0 : !cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i16 @test_cir_to_llvm_load_i16_relaxed
// CHECK: %{{[0-9]+}} = load atomic volatile i16, ptr %{{[0-9]+}} monotonic, align 2
cir.func @test_cir_to_llvm_load_i16_relaxed(%arg0: !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  %0 = cir.load deref volatile align(2) atomic(relaxed) %arg0 : !cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_cir_to_llvm_load_i16_acquire
// CHECK: %{{[0-9]+}} = load atomic volatile i16, ptr %{{[0-9]+}} acquire, align 2
cir.func @test_cir_to_llvm_load_i16_acquire(%arg0: !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  %0 = cir.load deref volatile align(2) atomic(acquire) %arg0 : !cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_cir_to_llvm_load_i16_seq_cst
// CHECK: %{{[0-9]+}} = load atomic volatile i16, ptr %{{[0-9]+}} seq_cst, align 2
cir.func @test_cir_to_llvm_load_i16_seq_cst(%arg0: !cir.ptr<!cir.int<s, 16>>) -> !cir.int<s, 16> {
  %0 = cir.load deref volatile align(2) atomic(seq_cst) %arg0 : !cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i32 @test_cir_to_llvm_load_i32_relaxed
// CHECK: %{{[0-9]+}} = load atomic volatile i32, ptr %{{[0-9]+}} monotonic, align 4
cir.func @test_cir_to_llvm_load_i32_relaxed(%arg0: !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  %0 = cir.load deref volatile align(4) atomic(relaxed) %arg0 : !cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_cir_to_llvm_load_i32_acquire
// CHECK: %{{[0-9]+}} = load atomic volatile i32, ptr %{{[0-9]+}} acquire, align 4
cir.func @test_cir_to_llvm_load_i32_acquire(%arg0: !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  %0 = cir.load deref volatile align(4) atomic(acquire) %arg0 : !cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_cir_to_llvm_load_i32_seq_cst
// CHECK: %{{[0-9]+}} = load atomic volatile i32, ptr %{{[0-9]+}} seq_cst, align 4
cir.func @test_cir_to_llvm_load_i32_seq_cst(%arg0: !cir.ptr<!cir.int<s, 32>>) -> !cir.int<s, 32> {
  %0 = cir.load deref volatile align(4) atomic(seq_cst) %arg0 : !cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i64 @test_cir_to_llvm_load_i64_relaxed
// CHECK: %{{[0-9]+}} = load atomic volatile i64, ptr %{{[0-9]+}} monotonic, align 8
cir.func @test_cir_to_llvm_load_i64_relaxed(%arg0: !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  %0 = cir.load deref volatile align(8) atomic(relaxed) %arg0 : !cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_cir_to_llvm_load_i64_acquire
// CHECK: %{{[0-9]+}} = load atomic volatile i64, ptr %{{[0-9]+}} acquire, align 8
cir.func @test_cir_to_llvm_load_i64_acquire(%arg0: !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  %0 = cir.load deref volatile align(8) atomic(acquire) %arg0 : !cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_cir_to_llvm_load_i64_seq_cst
// CHECK: %{{[0-9]+}} = load atomic volatile i64, ptr %{{[0-9]+}} seq_cst, align 8
cir.func @test_cir_to_llvm_load_i64_seq_cst(%arg0: !cir.ptr<!cir.int<s, 64>>) -> !cir.int<s, 64> {
  %0 = cir.load deref volatile align(8) atomic(seq_cst) %arg0 : !cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define float @test_cir_to_llvm_load_f32_relaxed
// CHECK: %{{[0-9]+}} = load atomic volatile float, ptr %{{[0-9]+}} monotonic, align 4
cir.func @test_cir_to_llvm_load_f32_relaxed(%arg0: !cir.ptr<!cir.float>) -> !cir.float {
  %0 = cir.load deref volatile align(4) atomic(relaxed) %arg0 : !cir.ptr<!cir.float>, !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_cir_to_llvm_load_f32_acquire
// CHECK: %{{[0-9]+}} = load atomic volatile float, ptr %{{[0-9]+}} acquire, align 4
cir.func @test_cir_to_llvm_load_f32_acquire(%arg0: !cir.ptr<!cir.float>) -> !cir.float {
  %0 = cir.load deref volatile align(4) atomic(acquire) %arg0 : !cir.ptr<!cir.float>, !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_cir_to_llvm_load_f32_seq_cst
// CHECK: %{{[0-9]+}} = load atomic volatile float, ptr %{{[0-9]+}} seq_cst, align 4
cir.func @test_cir_to_llvm_load_f32_seq_cst(%arg0: !cir.ptr<!cir.float>) -> !cir.float {
  %0 = cir.load deref volatile align(4) atomic(seq_cst) %arg0 : !cir.ptr<!cir.float>, !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define double @test_cir_to_llvm_load_f64_relaxed
// CHECK: %{{[0-9]+}} = load atomic volatile double, ptr %{{[0-9]+}} monotonic, align 8
cir.func @test_cir_to_llvm_load_f64_relaxed(%arg0: !cir.ptr<!cir.double>) -> !cir.double {
  %0 = cir.load deref volatile align(8) atomic(relaxed) %arg0 : !cir.ptr<!cir.double>, !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_cir_to_llvm_load_f64_acquire
// CHECK: %{{[0-9]+}} = load atomic volatile double, ptr %{{[0-9]+}} acquire, align 8
cir.func @test_cir_to_llvm_load_f64_acquire(%arg0: !cir.ptr<!cir.double>) -> !cir.double {
  %0 = cir.load deref volatile align(8) atomic(acquire) %arg0 : !cir.ptr<!cir.double>, !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_cir_to_llvm_load_f64_seq_cst
// CHECK: %{{[0-9]+}} = load atomic volatile double, ptr %{{[0-9]+}} seq_cst, align 8
cir.func @test_cir_to_llvm_load_f64_seq_cst(%arg0: !cir.ptr<!cir.double>) -> !cir.double {
  %0 = cir.load deref volatile align(8) atomic(seq_cst) %arg0 : !cir.ptr<!cir.double>, !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i8_relaxed
// CHECK: store atomic volatile i8 %{{[0-9]+}}, ptr %{{[0-9]+}} monotonic, align 1
cir.func @test_cir_to_llvm_store_i8_relaxed(%arg0: !cir.int<s, 8>, %arg1: !cir.ptr<!cir.int<s, 8>>) {
  cir.store volatile align(1) atomic(relaxed) %arg0, %arg1 : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i8_release
// CHECK: store atomic volatile i8 %{{[0-9]+}}, ptr %{{[0-9]+}} release, align 1
cir.func @test_cir_to_llvm_store_i8_release(%arg0: !cir.int<s, 8>, %arg1: !cir.ptr<!cir.int<s, 8>>) {
  cir.store volatile align(1) atomic(release) %arg0, %arg1 : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i8_seq_cst
// CHECK: store atomic volatile i8 %{{[0-9]+}}, ptr %{{[0-9]+}} seq_cst, align 1
cir.func @test_cir_to_llvm_store_i8_seq_cst(%arg0: !cir.int<s, 8>, %arg1: !cir.ptr<!cir.int<s, 8>>) {
  cir.store volatile align(1) atomic(seq_cst) %arg0, %arg1 : !cir.int<s, 8>, !cir.ptr<!cir.int<s, 8>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i16_relaxed
// CHECK: store atomic volatile i16 %{{[0-9]+}}, ptr %{{[0-9]+}} monotonic, align 2
cir.func @test_cir_to_llvm_store_i16_relaxed(%arg0: !cir.int<s, 16>, %arg1: !cir.ptr<!cir.int<s, 16>>) {
  cir.store volatile align(2) atomic(relaxed) %arg0, %arg1 : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i16_release
// CHECK: store atomic volatile i16 %{{[0-9]+}}, ptr %{{[0-9]+}} release, align 2
cir.func @test_cir_to_llvm_store_i16_release(%arg0: !cir.int<s, 16>, %arg1: !cir.ptr<!cir.int<s, 16>>) {
  cir.store volatile align(2) atomic(release) %arg0, %arg1 : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i16_seq_cst
// CHECK: store atomic volatile i16 %{{[0-9]+}}, ptr %{{[0-9]+}} seq_cst, align 2
cir.func @test_cir_to_llvm_store_i16_seq_cst(%arg0: !cir.int<s, 16>, %arg1: !cir.ptr<!cir.int<s, 16>>) {
  cir.store volatile align(2) atomic(seq_cst) %arg0, %arg1 : !cir.int<s, 16>, !cir.ptr<!cir.int<s, 16>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i32_relaxed
// CHECK: store atomic volatile i32 %{{[0-9]+}}, ptr %{{[0-9]+}} monotonic, align 4
cir.func @test_cir_to_llvm_store_i32_relaxed(%arg0: !cir.int<s, 32>, %arg1: !cir.ptr<!cir.int<s, 32>>) {
  cir.store volatile align(4) atomic(relaxed) %arg0, %arg1 : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i32_release
// CHECK: store atomic volatile i32 %{{[0-9]+}}, ptr %{{[0-9]+}} release, align 4
cir.func @test_cir_to_llvm_store_i32_release(%arg0: !cir.int<s, 32>, %arg1: !cir.ptr<!cir.int<s, 32>>) {
  cir.store volatile align(4) atomic(release) %arg0, %arg1 : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i32_seq_cst
// CHECK: store atomic volatile i32 %{{[0-9]+}}, ptr %{{[0-9]+}} seq_cst, align 4
cir.func @test_cir_to_llvm_store_i32_seq_cst(%arg0: !cir.int<s, 32>, %arg1: !cir.ptr<!cir.int<s, 32>>) {
  cir.store volatile align(4) atomic(seq_cst) %arg0, %arg1 : !cir.int<s, 32>, !cir.ptr<!cir.int<s, 32>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i64_relaxed
// CHECK: store atomic volatile i64 %{{[0-9]+}}, ptr %{{[0-9]+}} monotonic, align 8
cir.func @test_cir_to_llvm_store_i64_relaxed(%arg0: !cir.int<s, 64>, %arg1: !cir.ptr<!cir.int<s, 64>>) {
  cir.store volatile align(8) atomic(relaxed) %arg0, %arg1 : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i64_release
// CHECK: store atomic volatile i64 %{{[0-9]+}}, ptr %{{[0-9]+}} release, align 8
cir.func @test_cir_to_llvm_store_i64_release(%arg0: !cir.int<s, 64>, %arg1: !cir.ptr<!cir.int<s, 64>>) {
  cir.store volatile align(8) atomic(release) %arg0, %arg1 : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_i64_seq_cst
// CHECK: store atomic volatile i64 %{{[0-9]+}}, ptr %{{[0-9]+}} seq_cst, align 8
cir.func @test_cir_to_llvm_store_i64_seq_cst(%arg0: !cir.int<s, 64>, %arg1: !cir.ptr<!cir.int<s, 64>>) {
  cir.store volatile align(8) atomic(seq_cst) %arg0, %arg1 : !cir.int<s, 64>, !cir.ptr<!cir.int<s, 64>>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_f32_relaxed
// CHECK: store atomic volatile float %{{[0-9]+}}, ptr %{{[0-9]+}} monotonic, align 4
cir.func @test_cir_to_llvm_store_f32_relaxed(%arg0: !cir.float, %arg1: !cir.ptr<!cir.float>) {
  cir.store volatile align(4) atomic(relaxed) %arg0, %arg1 : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_f32_release
// CHECK: store atomic volatile float %{{[0-9]+}}, ptr %{{[0-9]+}} release, align 4
cir.func @test_cir_to_llvm_store_f32_release(%arg0: !cir.float, %arg1: !cir.ptr<!cir.float>) {
  cir.store volatile align(4) atomic(release) %arg0, %arg1 : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_f32_seq_cst
// CHECK: store atomic volatile float %{{[0-9]+}}, ptr %{{[0-9]+}} seq_cst, align 4
cir.func @test_cir_to_llvm_store_f32_seq_cst(%arg0: !cir.float, %arg1: !cir.ptr<!cir.float>) {
  cir.store volatile align(4) atomic(seq_cst) %arg0, %arg1 : !cir.float, !cir.ptr<!cir.float>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_f64_relaxed
// CHECK: store atomic volatile double %{{[0-9]+}}, ptr %{{[0-9]+}} monotonic, align 8
cir.func @test_cir_to_llvm_store_f64_relaxed(%arg0: !cir.double, %arg1: !cir.ptr<!cir.double>) {
  cir.store volatile align(8) atomic(relaxed) %arg0, %arg1 : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_f64_release
// CHECK: store atomic volatile double %{{[0-9]+}}, ptr %{{[0-9]+}} release, align 8
cir.func @test_cir_to_llvm_store_f64_release(%arg0: !cir.double, %arg1: !cir.ptr<!cir.double>) {
  cir.store volatile align(8) atomic(release) %arg0, %arg1 : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_store_f64_seq_cst
// CHECK: store atomic volatile double %{{[0-9]+}}, ptr %{{[0-9]+}} seq_cst, align 8
cir.func @test_cir_to_llvm_store_f64_seq_cst(%arg0: !cir.double, %arg1: !cir.ptr<!cir.double>) {
  cir.store volatile align(8) atomic(seq_cst) %arg0, %arg1 : !cir.double, !cir.ptr<!cir.double>
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_fence_acquire
// CHECK: fence acquire
cir.func @test_cir_to_llvm_fence_acquire() {
  cir.atomic.fence syncscope(system) acquire
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_fence_release
// CHECK: fence release
cir.func @test_cir_to_llvm_fence_release() {
  cir.atomic.fence syncscope(system) release
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_fence_acq_rel
// CHECK: fence acq_rel
cir.func @test_cir_to_llvm_fence_acq_rel() {
  cir.atomic.fence syncscope(system) acq_rel
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_fence_seq_cst
// CHECK: fence seq_cst
cir.func @test_cir_to_llvm_fence_seq_cst() {
  cir.atomic.fence syncscope(system) seq_cst
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_relaxed_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic monotonic, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_relaxed_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic acquire, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_relaxed_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic seq_cst, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_acquire_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} acquire monotonic, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_acquire_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} acquire acquire, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_acquire_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} acquire seq_cst, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_release_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} release monotonic, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_release_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} release acquire, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_release_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} release seq_cst, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_acqrel_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel monotonic, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_acqrel_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel acquire, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_acqrel_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel seq_cst, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_seqcst_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst monotonic, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_seqcst_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst acquire, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i8_seqcst_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst seq_cst, align 1
cir.func @test_cir_to_llvm_cmpxchg_i8_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>, %arg2 : !cir.int<s, 8>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(1) : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>, !cir.int<s, 8>) -> (!cir.int<s, 8>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_relaxed_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic monotonic, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_relaxed_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic acquire, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_relaxed_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic seq_cst, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_acquire_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} acquire monotonic, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_acquire_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} acquire acquire, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_acquire_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} acquire seq_cst, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_release_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} release monotonic, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_release_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} release acquire, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_release_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} release seq_cst, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_acqrel_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel monotonic, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_acqrel_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel acquire, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_acqrel_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel seq_cst, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_seqcst_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst monotonic, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_seqcst_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst acquire, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i16_seqcst_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst seq_cst, align 2
cir.func @test_cir_to_llvm_cmpxchg_i16_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>, %arg2 : !cir.int<s, 16>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(2) : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>, !cir.int<s, 16>) -> (!cir.int<s, 16>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_relaxed_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic monotonic, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_relaxed_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic acquire, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_relaxed_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic seq_cst, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_acquire_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} acquire monotonic, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_acquire_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} acquire acquire, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_acquire_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} acquire seq_cst, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_release_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} release monotonic, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_release_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} release acquire, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_release_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} release seq_cst, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_acqrel_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel monotonic, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_acqrel_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel acquire, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_acqrel_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel seq_cst, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_seqcst_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst monotonic, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_seqcst_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst acquire, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i32_seqcst_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst seq_cst, align 4
cir.func @test_cir_to_llvm_cmpxchg_i32_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>, %arg2 : !cir.int<s, 32>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(4) : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>, !cir.int<s, 32>) -> (!cir.int<s, 32>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_relaxed_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic monotonic, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_relaxed_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_relaxed_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic acquire, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_relaxed_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_relaxed_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic seq_cst, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_relaxed_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(relaxed) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_acquire_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} acquire monotonic, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_acquire_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_acquire_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} acquire acquire, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_acquire_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_acquire_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} acquire seq_cst, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_acquire_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(acquire) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_release_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} release monotonic, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_release_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_release_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} release acquire, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_release_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_release_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} release seq_cst, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_release_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(release) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_acqrel_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel monotonic, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_acqrel_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_acqrel_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel acquire, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_acqrel_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_acqrel_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel seq_cst, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_acqrel_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(acq_rel) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_seqcst_relaxed
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst monotonic, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_seqcst_relaxed(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(relaxed) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_seqcst_acquire
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst acquire, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_seqcst_acquire(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(acquire) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define void @test_cir_to_llvm_cmpxchg_i64_seqcst_seqcst
// CHECK: %{{[0-9]+}} = cmpxchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst seq_cst, align 8
cir.func @test_cir_to_llvm_cmpxchg_i64_seqcst_seqcst(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>, %arg2 : !cir.int<s, 64>) {
  %0:2 = cir.atomic.cmpxchg success(seq_cst) failure(seq_cst) syncscope(system) %arg0, %arg1, %arg2 align(8) : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>, !cir.int<s, 64>) -> (!cir.int<s, 64>, !cir.bool)
  cir.return
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_relaxed_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_fetch_i8_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acquire_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_fetch_i8_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_release_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_fetch_i8_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_acqrel_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_fetch_i8_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch nand seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_fetch_i8_seqcst_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_fetch_i8_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_relaxed_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_fetch_i16_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acquire_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_fetch_i16_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_release_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_fetch_i16_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_acqrel_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_fetch_i16_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch nand seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_fetch_i16_seqcst_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_fetch_i16_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_relaxed_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_i32_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acquire_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_i32_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_release_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_i32_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_acqrel_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_i32_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch nand seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_fetch_i32_seqcst_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_i32_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_relaxed_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_i64_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acquire_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_i64_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_release_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_i64_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_acqrel_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_i64_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_add_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_add_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw add ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_sub_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_sub_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw sub ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_and_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_and_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_and_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_and_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_and_vol_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_and_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_and_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw and ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_and_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch and seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_or_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_or_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_or_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_or_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_or_vol_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_or_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_or_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw or ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_or_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch or seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_xor_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_xor_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_xor_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_xor_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_xor_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_xor_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_xor_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw xor ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_xor_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch xor seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_nand_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_nand_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_nand_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw nand ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_nand_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch nand seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw max ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_fetch_i64_seqcst_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw min ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_i64_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_relaxed_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_fetch_f32_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acquire_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_fetch_f32_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_release_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_fetch_f32_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_acqrel_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_fetch_f32_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_add_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_sub_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_fetch_f32_seqcst_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_fetch_f32_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_relaxed_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_fetch_f64_relaxed_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min relaxed syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub acquire syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acquire_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_fetch_f64_acquire_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min acquire syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub release syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_release_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_fetch_f64_release_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min release syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_acqrel_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_fetch_f64_acqrel_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min acq_rel syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_add_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_add_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_add_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_add_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_add_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_add_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_add_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fadd ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_add_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch add seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_sub_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_sub_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_sub_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_sub_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_sub_vol_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_sub_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_sub_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fsub ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_sub_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch sub seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_max_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_max_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_max_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmax ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_max_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch max seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_min_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_min_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_fetch_f64_seqcst_min_vol_ff_
// CHECK: %{{[0-9]+}} = atomicrmw fmin ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_fetch_f64_seqcst_min_vol_ff_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.fetch min seq_cst syncscope(system) fetch_first %arg0, %arg1 volatile : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_relaxed_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_xchg_i8_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_relaxed_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} monotonic, align 1
cir.func @test_direct_llvm_xchg_i8_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg relaxed syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_acquire_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_xchg_i8_acquire_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_acquire_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acquire, align 1
cir.func @test_direct_llvm_xchg_i8_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg acquire syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_release_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_xchg_i8_release_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_release_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} release, align 1
cir.func @test_direct_llvm_xchg_i8_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg release syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_acqrel_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_xchg_i8_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_acqrel_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} acq_rel, align 1
cir.func @test_direct_llvm_xchg_i8_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg acq_rel syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_seqcst_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_xchg_i8_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i8 @test_direct_llvm_xchg_i8_seqcst_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i8 %{{[0-9]+}} seq_cst, align 1
cir.func @test_direct_llvm_xchg_i8_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 8>>, %arg1 : !cir.int<s, 8>) -> !cir.int<s, 8> {
  %0 = cir.atomic.xchg seq_cst syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 8>>, !cir.int<s, 8>) -> !cir.int<s, 8>
  cir.return %0 : !cir.int<s, 8>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_relaxed_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_xchg_i16_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_relaxed_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} monotonic, align 2
cir.func @test_direct_llvm_xchg_i16_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg relaxed syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_acquire_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_xchg_i16_acquire_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_acquire_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acquire, align 2
cir.func @test_direct_llvm_xchg_i16_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg acquire syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_release_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_xchg_i16_release_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_release_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} release, align 2
cir.func @test_direct_llvm_xchg_i16_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg release syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_acqrel_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_xchg_i16_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_acqrel_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} acq_rel, align 2
cir.func @test_direct_llvm_xchg_i16_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg acq_rel syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_seqcst_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_xchg_i16_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i16 @test_direct_llvm_xchg_i16_seqcst_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i16 %{{[0-9]+}} seq_cst, align 2
cir.func @test_direct_llvm_xchg_i16_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 16>>, %arg1 : !cir.int<s, 16>) -> !cir.int<s, 16> {
  %0 = cir.atomic.xchg seq_cst syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 16>>, !cir.int<s, 16>) -> !cir.int<s, 16>
  cir.return %0 : !cir.int<s, 16>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_relaxed_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_xchg_i32_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_relaxed_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_xchg_i32_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg relaxed syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_acquire_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_xchg_i32_acquire_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_acquire_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_xchg_i32_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg acquire syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_release_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_xchg_i32_release_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_release_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_xchg_i32_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg release syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_acqrel_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_xchg_i32_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_acqrel_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_xchg_i32_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg acq_rel syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_seqcst_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_xchg_i32_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i32 @test_direct_llvm_xchg_i32_seqcst_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i32 %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_xchg_i32_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 32>>, %arg1 : !cir.int<s, 32>) -> !cir.int<s, 32> {
  %0 = cir.atomic.xchg seq_cst syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 32>>, !cir.int<s, 32>) -> !cir.int<s, 32>
  cir.return %0 : !cir.int<s, 32>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_relaxed_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_xchg_i64_relaxed_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_relaxed_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_xchg_i64_relaxed_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg relaxed syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_acquire_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_xchg_i64_acquire_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_acquire_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_xchg_i64_acquire_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg acquire syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_release_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_xchg_i64_release_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_release_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_xchg_i64_release_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg release syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_acqrel_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_xchg_i64_acqrel_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_acqrel_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_xchg_i64_acqrel_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg acq_rel syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_seqcst_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_xchg_i64_seqcst_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define i64 @test_direct_llvm_xchg_i64_seqcst_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, i64 %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_xchg_i64_seqcst_vol_(%arg0 : !cir.ptr<!cir.int<s, 64>>, %arg1 : !cir.int<s, 64>) -> !cir.int<s, 64> {
  %0 = cir.atomic.xchg seq_cst syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.int<s, 64>>, !cir.int<s, 64>) -> !cir.int<s, 64>
  cir.return %0 : !cir.int<s, 64>
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_relaxed_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_xchg_f32_relaxed_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_relaxed_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} monotonic, align 4
cir.func @test_direct_llvm_xchg_f32_relaxed_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg relaxed syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_acquire_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_xchg_f32_acquire_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_acquire_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} acquire, align 4
cir.func @test_direct_llvm_xchg_f32_acquire_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg acquire syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_release_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_xchg_f32_release_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_release_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} release, align 4
cir.func @test_direct_llvm_xchg_f32_release_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg release syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_acqrel_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_xchg_f32_acqrel_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_acqrel_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} acq_rel, align 4
cir.func @test_direct_llvm_xchg_f32_acqrel_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg acq_rel syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_seqcst_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_xchg_f32_seqcst_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define float @test_direct_llvm_xchg_f32_seqcst_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, float %{{[0-9]+}} seq_cst, align 4
cir.func @test_direct_llvm_xchg_f32_seqcst_vol_(%arg0 : !cir.ptr<!cir.float>, %arg1 : !cir.float) -> !cir.float {
  %0 = cir.atomic.xchg seq_cst syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.float>, !cir.float) -> !cir.float
  cir.return %0 : !cir.float
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_relaxed_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_xchg_f64_relaxed_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg relaxed syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_relaxed_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} monotonic, align 8
cir.func @test_direct_llvm_xchg_f64_relaxed_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg relaxed syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_acquire_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_xchg_f64_acquire_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg acquire syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_acquire_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} acquire, align 8
cir.func @test_direct_llvm_xchg_f64_acquire_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg acquire syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_release_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_xchg_f64_release_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg release syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_release_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} release, align 8
cir.func @test_direct_llvm_xchg_f64_release_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg release syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_acqrel_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_xchg_f64_acqrel_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg acq_rel syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_acqrel_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} acq_rel, align 8
cir.func @test_direct_llvm_xchg_f64_acqrel_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg acq_rel syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_seqcst_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_xchg_f64_seqcst_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg seq_cst syncscope(system) %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

// CHECK-LABEL: define double @test_direct_llvm_xchg_f64_seqcst_vol_
// CHECK: %{{[0-9]+}} = atomicrmw xchg ptr %{{[0-9]+}}, double %{{[0-9]+}} seq_cst, align 8
cir.func @test_direct_llvm_xchg_f64_seqcst_vol_(%arg0 : !cir.ptr<!cir.double>, %arg1 : !cir.double) -> !cir.double {
  %0 = cir.atomic.xchg seq_cst syncscope(system) volatile %arg0, %arg1 : (!cir.ptr<!cir.double>, !cir.double) -> !cir.double
  cir.return %0 : !cir.double
}

