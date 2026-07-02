import os

# Configuration
cir_types_map = {
    "i8": "!s8i", "i16": "!s16i", "i32": "!s32i",
    "i64": "!s64i", "f32": "!cir.float", "f64": "!cir.double"
}

types_map = {
    "i8": "!cir.int<s, 8>", "i16": "!cir.int<s, 16>", "i32": "!cir.int<s, 32>",
    "i64": "!cir.int<s, 64>", "f32": "!cir.float", "f64": "!cir.double"
}

orders_map = {
    "relaxed": 0, "acquire": 1, "release": 2, "acq_rel": 3, "seq_cst": 4
}

alignment_map = {
    "i8": 1, "i16": 2, "i32": 4, "i64": 8, "f32": 4, "f64": 8
}

valid_cas_fails = ["relaxed", "acquire", "seq_cst"]

def get_arm_load_order(order):
    if order in ["release", "acq_rel", "seq_cst"]: return "acquire"
    return order

def get_arm_store_order(order):
    if order in ["acquire", "acq_rel", "seq_cst"]: return "release"
    return order

def get_arm_fence_order(order):
    if order == "seq_cst": return "acq_rel"
    return order

def get_arm_cas_orders(succ, fail):
    succ_int = orders_map[succ]
    fail_int = orders_map[fail]
    
    if succ_int == 4 or fail_int == 4 or succ_int == 3 or (succ_int == 2 and fail_int == 1):
        return "acq_rel", "relaxed"
    if succ_int == 1 or fail_int == 1:
        return "acquire", "relaxed"
    if succ_int == 2:
        return "release", "relaxed"
    
    return "relaxed", "relaxed"

def get_llvm_order(order):
    if order == "relaxed": return "monotonic"
    return order

def get_llvm_type(cir_type_name):
    if cir_type_name == "f32": return "float"
    if cir_type_name == "f64": return "double"
    return cir_type_name

# CmpXchg Syntax Helpers for INPUT lines (Includes strict types)
def fmt_cir_cmpxchg(align, succ, fail, t):
    return f"cir.atomic.cmpxchg success({succ}) failure({fail}) syncscope(system) %arg0, %arg1, %arg2 align({align}) : (!cir.ptr<{t}>, {t}, {t}) -> ({t}, !cir.bool)"

def fmt_cpp_cmpxchg(align, succ_int, fail_int, t):
    return f"cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order({succ_int} : i32) failure_order({fail_int} : i32) align({align}) : !cir.ptr<{t}>, !cir.bool"

def fmt_arm_cmpxchg(align, succ_int, fail_int, t):
    return f"arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order({succ_int} : i32) failure_order({fail_int} : i32) align({align}) : !cir.ptr<{t}>, !cir.bool"

# CmpXchg Syntax Helpers for CHECK lines (Ignores aliased trailing types)
def check_cpp_cmpxchg(align, succ_int, fail_int):
    return f"cpp_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order({succ_int} : i32) failure_order({fail_int} : i32) align({align})"

def check_arm_cmpxchg(align, succ_int, fail_int):
    return f"arm_atomic.atomic_cmpxchg %arg0, %arg1, %arg2 success_order({succ_int} : i32) failure_order({fail_int} : i32) align({align})"



# PHASE 1: CIR -> CppAtomic
def generate_cir_to_cpp():
    filename = "test_cir_to_cpp_atomic.mlir"
    with open(filename, "w") as f:
        f.write("// === PHASE 1: CIR -> CppAtomic === \n\n")
        f.write(f"// RUN: ./../../../../../build/bin/cir-opt tests/{filename} --cir-to-cpp-atomic | ./../../../../../build/bin/FileCheck tests/{filename}\n\n\n")
        
        f.write("// --- 1. NON-ATOMIC LOADS/STORES ---\n")
        for name, cir_type in types_map.items():
            check_type = cir_types_map[name]
            func_name = f"test_non_atomic_load_{name}"
            f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
            f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>) -> {cir_type} {{\n")
            f.write(f"  // CHECK: cir.load deref volatile %arg0 : !cir.ptr<{check_type}>, {check_type}\n")
            f.write(f"  %0 = cir.load deref volatile %arg0 : !cir.ptr<{cir_type}>, {cir_type}\n")
            f.write(f"  cir.return %0 : {cir_type}\n}}\n\n")

            func_name = f"test_non_atomic_store_{name}"
            f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
            f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}) {{\n")
            f.write(f"  // CHECK: cir.store volatile %arg1, %arg0 : {check_type}, !cir.ptr<{check_type}>\n")
            f.write(f"  cir.store volatile %arg1, %arg0 : {cir_type}, !cir.ptr<{cir_type}>\n  cir.return\n}}\n\n")

        f.write("// --- 2. ATOMIC LOADS ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["release", "acq_rel"]: continue
                func_name = f"test_load_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>) -> {cir_type} {{\n")
                f.write(f"  // CHECK: cpp_atomic.atomic_load deref volatile %arg0 memory_order({order_int} : i32) align({align_val})\n")
                f.write(f"  %0 = cir.load deref volatile align({align_val}) atomic({order_name}) %arg0 : !cir.ptr<{cir_type}>, {cir_type}\n")
                f.write(f"  cir.return %0 : {cir_type}\n}}\n\n")

        f.write("// --- 3. ATOMIC STORES ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["acquire", "acq_rel"]: continue
                func_name = f"test_store_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}) {{\n")
                f.write(f"  // CHECK: cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order({order_int} : i32) align({align_val})\n")
                f.write(f"  cir.store volatile align({align_val}) atomic({order_name}) %arg1, %arg0 : {cir_type}, !cir.ptr<{cir_type}>\n  cir.return\n}}\n\n")

        f.write("// --- 4. ATOMIC FENCES ---\n")
        for order_name, order_int in orders_map.items():
            if order_name == "relaxed": continue
            func_name = f"test_fence_{order_name.replace('_', '')}"
            f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
            f.write(f"cir.func @{func_name}() {{\n")
            f.write(f"  // CHECK: cpp_atomic.atomic_fence memory_order({order_int} : i32)\n")
            f.write(f"  cir.atomic.fence syncscope(system) {order_name}\n  cir.return\n}}\n\n")

        f.write("// --- 5. ATOMIC CMPXCHG ---\n")
        for name, cir_type in types_map.items():
            if name in ["f32", "f64"]: continue
            align_val = alignment_map[name]
            for succ_name, succ_int in orders_map.items():
                for fail_name in valid_cas_fails:
                    fail_int = orders_map[fail_name]
                    func_name = f"test_cmpxchg_{name}_{succ_name.replace('_', '')}_{fail_name.replace('_', '')}"
                    f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                    f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}, %arg2 : {cir_type}) {{\n")
                    f.write(f"  // CHECK: {check_cpp_cmpxchg(align_val, succ_int, fail_int)}\n")
                    f.write(f"  %0:2 = {fmt_cir_cmpxchg(align_val, succ_name, fail_name, cir_type)}\n  cir.return\n}}\n\n")

    print(f"Generated {len(types_map) * 2 + len(types_map) * (len(orders_map) - 2) * 2 + len(orders_map) - 1 + (len(types_map) - 2) * len(orders_map) * len(orders_map)} tests in Phase 1: {filename}")



# PHASE 2: CppAtomic -> ArmAtomic
def generate_cpp_to_arm():
    filename = "test_cpp_atomic_to_arm_atomic.mlir"
    with open(filename, "w") as f:
        f.write("// === PHASE 2: CppAtomic -> ArmAtomic === \n\n")
        f.write(f"// RUN: ./../../../../../build/bin/cir-opt tests/{filename} --cpp-atomic-to-arm-atomic | ./../../../../../build/bin/FileCheck tests/{filename}\n\n\n")

        f.write("// --- 1. LOADS ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["release", "acq_rel"]: continue
                arm_order_int = orders_map[get_arm_load_order(order_name)]
                func_name = f"test_arm_load_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>) -> {cir_type} {{\n")
                f.write(f"  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order({arm_order_int} : i32) align({align_val})\n")
                f.write(f"  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order({order_int} : i32) align({align_val}) : !cir.ptr<{cir_type}>\n")
                f.write(f"  cir.return %0 : {cir_type}\n}}\n\n")

        f.write("// --- 2. STORES ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["acquire", "acq_rel"]: continue
                arm_order_int = orders_map[get_arm_store_order(order_name)]
                func_name = f"test_arm_store_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}) {{\n")
                f.write(f"  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order({arm_order_int} : i32) align({align_val})\n")
                f.write(f"  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order({order_int} : i32) align({align_val}) : {cir_type}, !cir.ptr<{cir_type}>\n  cir.return\n}}\n\n")

        f.write("// --- 3. FENCES ---\n")
        for order_name, order_int in orders_map.items():
            if order_name == "relaxed": continue
            arm_order_int = orders_map[get_arm_fence_order(order_name)]
            func_name = f"test_arm_fence_{order_name.replace('_', '')}"
            f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
            f.write(f"cir.func @{func_name}() {{\n")
            f.write(f"  // CHECK: arm_atomic.atomic_fence memory_order({arm_order_int} : i32)\n")
            f.write(f"  cpp_atomic.atomic_fence memory_order({order_int} : i32)\n  cir.return\n}}\n\n")

        f.write("// --- 4. CMPXCHG ---\n")
        for name, cir_type in types_map.items():
            if name in ["f32", "f64"]: continue
            align_val = alignment_map[name]
            for succ_name, succ_int in orders_map.items():
                for fail_name in valid_cas_fails:
                    fail_int = orders_map[fail_name]
                    arm_succ, arm_fail = get_arm_cas_orders(succ_name, fail_name)
                    func_name = f"test_arm_cmpxchg_{name}_{succ_name.replace('_', '')}_{fail_name.replace('_', '')}"
                    f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                    f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}, %arg2 : {cir_type}) {{\n")
                    f.write(f"  // CHECK: {check_arm_cmpxchg(align_val, orders_map[arm_succ], orders_map[arm_fail])}\n")
                    f.write(f"  %0:2 = {fmt_cpp_cmpxchg(align_val, succ_int, fail_int, cir_type)}\n  cir.return\n}}\n\n")

    print(f"Generated {len(types_map) * (len(orders_map) - 2) * 2 + len(orders_map) - 1 + (len(types_map) - 2) * len(orders_map) * len(orders_map)} tests in Phase 2: {filename}")



# PHASE 3: CIR -> ArmAtomic
def generate_cir_to_arm():
    filename = "test_cir_to_arm_atomic.mlir"
    with open(filename, "w") as f:
        f.write("// === PHASE 3: CIR -> ArmAtomic === \n\n")
        f.write(f"// RUN: ./../../../../../build/bin/cir-opt tests/{filename} --cir-to-cpp-atomic --cpp-atomic-to-arm-atomic | ./../../../../../build/bin/FileCheck tests/{filename}\n\n\n")

        f.write("// --- 1. LOADS ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["release", "acq_rel"]: continue
                arm_order_int = orders_map[get_arm_load_order(order_name)]
                func_name = f"test_arm_load_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>) -> {cir_type} {{\n")
                f.write(f"  // CHECK: arm_atomic.atomic_load deref volatile %arg0 memory_order({arm_order_int} : i32) align({align_val})\n")
                f.write(f"  %0 = cir.load deref volatile align({align_val}) atomic({order_name}) %arg0 : !cir.ptr<{cir_type}>, {cir_type}\n")
                f.write(f"  cir.return %0 : {cir_type}\n}}\n\n")

        f.write("// --- 2. STORES ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["acquire", "acq_rel"]: continue
                arm_order_int = orders_map[get_arm_store_order(order_name)]
                func_name = f"test_arm_store_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}) {{\n")
                f.write(f"  // CHECK: arm_atomic.atomic_store volatile %arg1, %arg0 memory_order({arm_order_int} : i32) align({align_val})\n")
                f.write(f"  cir.store volatile align({align_val}) atomic({order_name}) %arg1, %arg0 : {cir_type}, !cir.ptr<{cir_type}>\n  cir.return\n}}\n\n")

        f.write("// --- 3. FENCES ---\n")
        for order_name, order_int in orders_map.items():
            if order_name == "relaxed": continue
            arm_order_int = orders_map[get_arm_fence_order(order_name)]
            func_name = f"test_arm_fence_{order_name.replace('_', '')}"
            f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
            f.write(f"cir.func @{func_name}() {{\n")
            f.write(f"  // CHECK: arm_atomic.atomic_fence memory_order({arm_order_int} : i32)\n")
            f.write(f"  cir.atomic.fence syncscope(system) {order_name}\n  cir.return\n}}\n\n")

        f.write("// --- 4. CMPXCHG ---\n")
        for name, cir_type in types_map.items():
            if name in ["f32", "f64"]: continue
            align_val = alignment_map[name]
            for succ_name, succ_int in orders_map.items():
                for fail_name in valid_cas_fails:
                    arm_succ, arm_fail = get_arm_cas_orders(succ_name, fail_name)
                    func_name = f"test_arm_cmpxchg_{name}_{succ_name.replace('_', '')}_{fail_name.replace('_', '')}"
                    f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                    f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}, %arg2 : {cir_type}) {{\n")
                    f.write(f"  // CHECK: {check_arm_cmpxchg(align_val, orders_map[arm_succ], orders_map[arm_fail])}\n")
                    f.write(f"  %0:2 = {fmt_cir_cmpxchg(align_val, succ_name, fail_name, cir_type)}\n  cir.return\n}}\n\n")

    print(f"Generated {len(types_map) * (len(orders_map) - 2) * 2 + len(orders_map) - 1 + (len(types_map) - 2) * len(orders_map) * len(orders_map)} tests in Phase 3: {filename}")



# PHASE 4: ArmAtomic -> LLVMIR
def generate_arm_to_llvm():
    filename = "test_arm_atomic_to_llvm.mlir"
    with open(filename, "w") as f:
        f.write("// === PHASE 4: ArmAtomic -> LLVMIR === \n\n")
        f.write(f"// RUN: ./../../../../../build/bin/cir-opt tests/{filename} --arm-atomic-to-llvm | ./../../../../../build/bin/FileCheck tests/{filename}\n\n\n")

        f.write("// --- 1. LOADS ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["release", "acq_rel"]: continue
                arm_order_name = get_arm_load_order(order_name)
                arm_order_int = orders_map[arm_order_name]
                llvm_order = get_llvm_order(arm_order_name)
                func_name = f"test_arm_to_llvm_load_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>) -> {cir_type} {{\n")
                f.write(f"  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0\n")
                f.write(f"  // CHECK: llvm.load volatile [[PTR]] atomic {llvm_order} {{alignment = {align_val} : i64}}\n")
                f.write(f"  %0 = arm_atomic.atomic_load deref volatile %arg0 memory_order({arm_order_int} : i32) align({align_val}) : !cir.ptr<{cir_type}>\n")
                f.write(f"  cir.return %0 : {cir_type}\n}}\n\n")

        f.write("// --- 2. STORES ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["acquire", "acq_rel"]: continue
                arm_order_name = get_arm_store_order(order_name)
                arm_order_int = orders_map[arm_order_name]
                llvm_order = get_llvm_order(arm_order_name)
                func_name = f"test_arm_to_llvm_store_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}) {{\n")
                f.write(f"  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0\n")
                f.write(f"  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1\n")
                f.write(f"  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic {llvm_order} {{alignment = {align_val} : i64}}\n")
                f.write(f"  arm_atomic.atomic_store volatile %arg1, %arg0 memory_order({arm_order_int} : i32) align({align_val}) : {cir_type}, !cir.ptr<{cir_type}>\n  cir.return\n}}\n\n")

        f.write("// --- 3. FENCES ---\n")
        for order_name, order_int in orders_map.items():
            arm_order_name = get_arm_fence_order(order_name)
            arm_order_int = orders_map[arm_order_name]
            llvm_order = get_llvm_order(arm_order_name)
            func_name = f"test_arm_to_llvm_fence_{order_name.replace('_', '')}"
            f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
            f.write(f"cir.func @{func_name}() {{\n")
            if order_name == "relaxed":
                f.write("  // CHECK-NOT: llvm.fence\n  // CHECK: cir.return\n")
            else:
                f.write(f"  // CHECK: llvm.fence {llvm_order}\n")
            f.write(f"  arm_atomic.atomic_fence memory_order({arm_order_int} : i32)\n  cir.return\n}}\n\n")

        f.write("// --- 4. CMPXCHG ---\n")
        for name, cir_type in types_map.items():
            if name in ["f32", "f64"]: continue
            align_val = alignment_map[name]
            for succ_name, succ_int in orders_map.items():
                for fail_name in valid_cas_fails:
                    arm_succ, arm_fail = get_arm_cas_orders(succ_name, fail_name)
                    fail_int = orders_map[fail_name]
                    llvm_succ = get_llvm_order(arm_succ)
                    llvm_fail = get_llvm_order(arm_fail)
                    func_name = f"test_arm_to_llvm_cmpxchg_{name}_{succ_name.replace('_', '')}_{fail_name.replace('_', '')}"
                    f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                    f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}, %arg2 : {cir_type}) {{\n")
                    f.write(f"  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0\n")
                    f.write(f"  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1\n")
                    f.write(f"  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2\n")
                    f.write(f"  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] {llvm_succ} {llvm_fail} {{alignment = {align_val} : i64}}\n")
                    f.write(f"  // CHECK-DAG: llvm.extractvalue [[RES]][0]\n")
                    f.write(f"  // CHECK-DAG: llvm.extractvalue [[RES]][1]\n")
                    f.write(f"  %0:2 = {fmt_arm_cmpxchg(align_val, orders_map[arm_succ], orders_map[arm_fail], cir_type)}\n  cir.return\n}}\n\n")

    print(f"Generated {len(types_map) * (len(orders_map) - 2) * 2 + (len(orders_map) - 2) + (len(types_map) - 2) * len(orders_map) * len(orders_map)} tests in Phase 4: {filename}")



# PHASE 5: CppAtomic -> LLVMIR
def generate_cpp_to_llvm():
    filename = "test_cpp_atomic_to_llvm.mlir"
    with open(filename, "w") as f:
        f.write("// === PHASE 5: CppAtomic -> LLVMIR === \n\n")
        f.write(f"// RUN: ./../../../../../build/bin/cir-opt tests/{filename} --cpp-atomic-to-arm-atomic --arm-atomic-to-llvm | ./../../../../../build/bin/FileCheck tests/{filename}\n\n\n")

        f.write("// --- 1. LOADS ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["release", "acq_rel"]: continue
                arm_order_name = get_arm_load_order(order_name)
                llvm_order = get_llvm_order(arm_order_name)
                func_name = f"test_cpp_to_llvm_load_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>) -> {cir_type} {{\n")
                f.write(f"  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0\n")
                f.write(f"  // CHECK: llvm.load volatile [[PTR]] atomic {llvm_order} {{alignment = {align_val} : i64}}\n")
                f.write(f"  %0 = cpp_atomic.atomic_load deref volatile %arg0 memory_order({order_int} : i32) align({align_val}) : !cir.ptr<{cir_type}>\n")
                f.write(f"  cir.return %0 : {cir_type}\n}}\n\n")

        f.write("// --- 2. STORES ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["acquire", "acq_rel"]: continue
                arm_order_name = get_arm_store_order(order_name)
                llvm_order = get_llvm_order(arm_order_name)
                func_name = f"test_cpp_to_llvm_store_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}) {{\n")
                f.write(f"  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0\n")
                f.write(f"  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1\n")
                f.write(f"  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic {llvm_order} {{alignment = {align_val} : i64}}\n")
                f.write(f"  cpp_atomic.atomic_store volatile %arg1, %arg0 memory_order({order_int} : i32) align({align_val}) : {cir_type}, !cir.ptr<{cir_type}>\n  cir.return\n}}\n\n")

        f.write("// --- 3. FENCES ---\n")
        for order_name, order_int in orders_map.items():
            arm_order_name = get_arm_fence_order(order_name)
            llvm_order = get_llvm_order(arm_order_name)
            func_name = f"test_cpp_to_llvm_fence_{order_name.replace('_', '')}"
            f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
            f.write(f"cir.func @{func_name}() {{\n")
            if order_name == "relaxed":
                f.write("  // CHECK-NOT: llvm.fence\n  // CHECK: cir.return\n")
            else:
                f.write(f"  // CHECK: llvm.fence {llvm_order}\n")
            f.write(f"  cpp_atomic.atomic_fence memory_order({order_int} : i32)\n  cir.return\n}}\n\n")

        f.write("// --- 4. CMPXCHG ---\n")
        for name, cir_type in types_map.items():
            if name in ["f32", "f64"]: continue
            align_val = alignment_map[name]
            for succ_name, succ_int in orders_map.items():
                for fail_name in valid_cas_fails:
                    fail_int = orders_map[fail_name]
                    arm_succ, arm_fail = get_arm_cas_orders(succ_name, fail_name)
                    llvm_succ = get_llvm_order(arm_succ)
                    llvm_fail = get_llvm_order(arm_fail)
                    func_name = f"test_cpp_to_llvm_cmpxchg_{name}_{succ_name.replace('_', '')}_{fail_name.replace('_', '')}"
                    f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                    f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}, %arg2 : {cir_type}) {{\n")
                    f.write(f"  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0\n")
                    f.write(f"  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1\n")
                    f.write(f"  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2\n")
                    f.write(f"  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] {llvm_succ} {llvm_fail} {{alignment = {align_val} : i64}}\n")
                    f.write(f"  // CHECK-DAG: llvm.extractvalue [[RES]][0]\n")
                    f.write(f"  // CHECK-DAG: llvm.extractvalue [[RES]][1]\n")
                    f.write(f"  %0:2 = {fmt_cpp_cmpxchg(align_val, succ_int, fail_int, cir_type)}\n  cir.return\n}}\n\n")

    print(f"Generated {len(types_map) * (len(orders_map) - 2) * 2 + len(orders_map) + (len(types_map) - 2) * len(orders_map) * len(orders_map)} tests in Phase 5: {filename}")



# PHASE 6: CIR -> LLVMIR
def generate_cir_to_llvm():
    filename = "test_cir_to_llvm.mlir"
    with open(filename, "w") as f:
        f.write("// === PHASE 6: CIR -> LLVMIR === \n\n")
        f.write(f"// RUN: ./../../../../../build/bin/cir-opt tests/{filename} --cir-to-cpp-atomic --cpp-atomic-to-arm-atomic --arm-atomic-to-llvm | ./../../../../../build/bin/FileCheck tests/{filename}\n\n\n")

        f.write("// --- 1. LOADS ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["release", "acq_rel"]: continue
                arm_order_name = get_arm_load_order(order_name)
                llvm_order = get_llvm_order(arm_order_name)
                func_name = f"test_cir_to_llvm_load_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>) -> {cir_type} {{\n")
                f.write(f"  // CHECK: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0\n")
                f.write(f"  // CHECK: llvm.load volatile [[PTR]] atomic {llvm_order} {{alignment = {align_val} : i64}}\n")
                f.write(f"  %0 = cir.load deref volatile align({align_val}) atomic({order_name}) %arg0 : !cir.ptr<{cir_type}>, {cir_type}\n")
                f.write(f"  cir.return %0 : {cir_type}\n}}\n\n")

        f.write("// --- 2. STORES ---\n")
        for name, cir_type in types_map.items():
            align_val = alignment_map[name]
            for order_name, order_int in orders_map.items():
                if order_name in ["acquire", "acq_rel"]: continue
                arm_order_name = get_arm_store_order(order_name)
                llvm_order = get_llvm_order(arm_order_name)
                func_name = f"test_cir_to_llvm_store_{name}_{order_name.replace('_', '')}"
                f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}) {{\n")
                f.write(f"  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0\n")
                f.write(f"  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg1\n")
                f.write(f"  // CHECK: llvm.store volatile [[VAL]], [[PTR]] atomic {llvm_order} {{alignment = {align_val} : i64}}\n")
                f.write(f"  cir.store volatile align({align_val}) atomic({order_name}) %arg1, %arg0 : {cir_type}, !cir.ptr<{cir_type}>\n  cir.return\n}}\n\n")

        f.write("// --- 3. FENCES ---\n")
        for order_name, order_int in orders_map.items():
            arm_order_name = get_arm_fence_order(order_name)
            llvm_order = get_llvm_order(arm_order_name)
            func_name = f"test_cir_to_llvm_fence_{order_name.replace('_', '')}"
            f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
            f.write(f"cir.func @{func_name}() {{\n")
            if order_name == "relaxed":
                f.write("  // CHECK-NOT: llvm.fence\n  // CHECK: cir.return\n")
            else:
                f.write(f"  // CHECK: llvm.fence {llvm_order}\n")
            f.write(f"  cir.atomic.fence syncscope(system) {order_name}\n  cir.return\n}}\n\n")

        f.write("// --- 4. CMPXCHG ---\n")
        for name, cir_type in types_map.items():
            if name in ["f32", "f64"]: continue
            align_val = alignment_map[name]
            for succ_name, succ_int in orders_map.items():
                for fail_name in valid_cas_fails:
                    arm_succ, arm_fail = get_arm_cas_orders(succ_name, fail_name)
                    llvm_succ = get_llvm_order(arm_succ)
                    llvm_fail = get_llvm_order(arm_fail)
                    func_name = f"test_cir_to_llvm_cmpxchg_{name}_{succ_name.replace('_', '')}_{fail_name.replace('_', '')}"
                    f.write(f"// CHECK-LABEL: cir.func @{func_name}\n")
                    f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}, %arg2 : {cir_type}) {{\n")
                    f.write(f"  // CHECK-DAG: [[PTR:%.*]] = builtin.unrealized_conversion_cast %arg0\n")
                    f.write(f"  // CHECK-DAG: [[CMP:%.*]] = builtin.unrealized_conversion_cast %arg1\n")
                    f.write(f"  // CHECK-DAG: [[VAL:%.*]] = builtin.unrealized_conversion_cast %arg2\n")
                    f.write(f"  // CHECK: [[RES:%.*]] = llvm.cmpxchg [[PTR]], [[CMP]], [[VAL]] {llvm_succ} {llvm_fail} {{alignment = {align_val} : i64}}\n")
                    f.write(f"  // CHECK-DAG: llvm.extractvalue [[RES]][0]\n")
                    f.write(f"  // CHECK-DAG: llvm.extractvalue [[RES]][1]\n")
                    f.write(f"  %0:2 = {fmt_cir_cmpxchg(align_val, succ_name, fail_name, cir_type)}\n  cir.return\n}}\n\n")

    print(f"Generated {len(types_map) * (len(orders_map) - 2) * 2 + len(orders_map) + (len(types_map) - 2) * len(orders_map) * len(orders_map)} tests in Phase 6: {filename}")


# PHASE 7: Standard Direct CIR -> LLVMIR 
def generate_direct_cir_to_llvmir():
    filename = "test_direct_cir_to_llvmir.mlir"
    with open(filename, "w") as f:
        f.write("// === PHASE 7: Direct CIR -> LLVMIR === \n\n")
        f.write(f"// RUN: ./../../../../../build/bin/cir-translate tests/{filename} -cir-to-llvmir --target x86_64-unknown-linux-gnu --disable-cc-lowering | ./../../../../../build/bin/FileCheck tests/{filename}\n\n\n")

        # 1. LOADS
        for name, cir_type in types_map.items():
            llvm_type = get_llvm_type(name) 
            for order_name, order_int in orders_map.items():
                if order_name in ["release", "acq_rel"]: continue
                align_val = alignment_map[name]
                llvm_order = get_llvm_order(order_name) 
                func_name = f"test_cir_to_llvm_load_{name}_{order_name}"
                f.write(f"// CHECK-LABEL: define {llvm_type} @{func_name}\n")
                f.write(f"// CHECK: %{{{{[0-9]+}}}} = load atomic volatile {llvm_type}, ptr %{{{{[0-9]+}}}} {llvm_order}, align {align_val}\n")
                f.write(f"cir.func @{func_name}(%arg0: !cir.ptr<{cir_type}>) -> {cir_type} {{\n")
                f.write(f"  %0 = cir.load deref volatile align({align_val}) atomic({order_name}) %arg0 : !cir.ptr<{cir_type}>, {cir_type}\n")
                f.write(f"  cir.return %0 : {cir_type}\n}}\n\n")

        # 2. STORES
        for name, cir_type in types_map.items():
            llvm_type = get_llvm_type(name)
            for order_name, order_int in orders_map.items():
                if order_name in ["consume", "acquire", "acq_rel"]: continue
                align_val = alignment_map[name]
                llvm_order = get_llvm_order(order_name)
                func_name = f"test_cir_to_llvm_store_{name}_{order_name}"
                f.write(f"// CHECK-LABEL: define void @{func_name}\n")
                f.write(f"// CHECK: store atomic volatile {llvm_type} %{{{{[0-9]+}}}}, ptr %{{{{[0-9]+}}}} {llvm_order}, align {align_val}\n")
                f.write(f"cir.func @{func_name}(%arg0: {cir_type}, %arg1: !cir.ptr<{cir_type}>) {{\n")
                f.write(f"  cir.store volatile align({align_val}) atomic({order_name}) %arg0, %arg1 : {cir_type}, !cir.ptr<{cir_type}>\n")
                f.write("  cir.return\n}\n\n")

        # 3. FENCES
        for order_name, order_int in orders_map.items():
            if order_name == "relaxed": continue
            llvm_order = get_llvm_order(order_name)
            func_name = f"test_cir_to_llvm_fence_{order_name}"
            f.write(f"// CHECK-LABEL: define void @{func_name}\n")
            f.write(f"// CHECK: fence {llvm_order}\n")
            f.write(f"cir.func @{func_name}() {{\n")
            f.write(f"  cir.atomic.fence syncscope(system) {order_name}\n  cir.return\n}}\n\n")

        # 4. CMPXCHG
        for name, cir_type in types_map.items():
            if name in ["f32", "f64"]: continue
            llvm_type = get_llvm_type(name)
            align_val = alignment_map[name]
            for succ_name, succ_int in orders_map.items():
                for fail_name in valid_cas_fails:
                    llvm_succ = get_llvm_order(succ_name)
                    llvm_fail = get_llvm_order(fail_name)
                    func_name = f"test_cir_to_llvm_cmpxchg_{name}_{succ_name.replace('_', '')}_{fail_name.replace('_', '')}"
                    f.write(f"// CHECK-LABEL: define void @{func_name}\n")
                    f.write(f"// CHECK: %{{{{[0-9]+}}}} = cmpxchg ptr %{{{{[0-9]+}}}}, {llvm_type} %{{{{[0-9]+}}}}, {llvm_type} %{{{{[0-9]+}}}} {llvm_succ} {llvm_fail}, align {align_val}\n")
                    f.write(f"cir.func @{func_name}(%arg0 : !cir.ptr<{cir_type}>, %arg1 : {cir_type}, %arg2 : {cir_type}) {{\n")
                    f.write(f"  %0:2 = {fmt_cir_cmpxchg(align_val, succ_name, fail_name, cir_type)}\n  cir.return\n}}\n\n")

    print(f"Generated {len(types_map) * (len(orders_map) - 2) * 2 + len(orders_map) - 1 + (len(types_map) - 2) * len(orders_map) * len(orders_map)} tests in Phase 7: {filename}")

if __name__ == "__main__":
    generate_cir_to_cpp()
    generate_cpp_to_arm()
    generate_cir_to_arm()
    generate_arm_to_llvm()
    generate_cpp_to_llvm()
    generate_cir_to_llvm()
    generate_direct_cir_to_llvmir()

    print("All testing scripts generated successfully!\n")