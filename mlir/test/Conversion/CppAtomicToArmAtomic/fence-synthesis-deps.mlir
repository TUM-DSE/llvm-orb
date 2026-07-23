// RUN: cir-opt --pass-pipeline="builtin.module(order-analysis,cpp-atomic-to-arm-atomic,fence-synthesis)" -split-input-file %s | FileCheck %s

// -----
// Test: ctrl dependency — store is only reachable via a branch on the load
// result.  The ARM ctrl dep (load→branch→store) provides ordering for free;
// both ops must stay relaxed and no fence may be inserted.
//
// Source RC11 ordering: load(acquire) →ppo→ store(release)
// Target ARM ordering:  ctrl dep (dob) covers the pair — no sync needed.
//
// CHECK-LABEL: func @ctrl_dep
// CHECK:     arm_atomic.atomic_load {{.*}} memory_order(0 : i32)
// CHECK-NOT: arm_atomic.atomic_fence
// CHECK:     arm_atomic.atomic_store {{.*}} memory_order(0 : i32)

module {
  func.func @ctrl_dep(%ptr1 : !ptr.ptr<#ptr.generic_space>,
                      %ptr2 : !ptr.ptr<#ptr.generic_space>,
                      %zero : i32, %val : i32) {
    %a = cpp_atomic.atomic_load %ptr1 memory_order(#cpp_atomic.memory_order<acquire>)
             : !ptr.ptr<#ptr.generic_space> -> i32
    %c = arith.cmpi eq, %a, %zero : i32
    cf.cond_br %c, ^store_bb, ^exit_bb
  ^store_bb:
    cpp_atomic.atomic_store %val, %ptr2 memory_order(#cpp_atomic.memory_order<release>)
             : i32, !ptr.ptr<#ptr.generic_space>
    cf.br ^exit_bb
  ^exit_bb:
    return
  }
}

// -----
// Test: addr dependency — the value loaded by the first op is used directly
// as the address operand of the second load.  ARM addr dep orders them; no
// synchronization is inserted.
//
// CHECK-LABEL: func @addr_dep
// CHECK:     arm_atomic.atomic_load {{.*}} memory_order(0 : i32)
// CHECK-NOT: arm_atomic.atomic_fence
// CHECK:     arm_atomic.atomic_load {{.*}} memory_order(0 : i32)

module {
  func.func @addr_dep(%ptr1 : !ptr.ptr<#ptr.generic_space>) -> i32 {
    // Load a pointer value from ptr1.
    %addr = cpp_atomic.atomic_load %ptr1 memory_order(#cpp_atomic.memory_order<acquire>)
                : !ptr.ptr<#ptr.generic_space> -> !ptr.ptr<#ptr.generic_space>
    // Use the loaded pointer as the address for the next load (addr dep).
    %val = cpp_atomic.atomic_load %addr memory_order(#cpp_atomic.memory_order<acquire>)
               : !ptr.ptr<#ptr.generic_space> -> i32
    return %val : i32
  }
}

// -----
// Test: data dependency — the value loaded by the first op is stored by the
// second op.  ARM data dep orders the load→store pair; no sync needed.
//
// CHECK-LABEL: func @data_dep
// CHECK:     arm_atomic.atomic_load {{.*}} memory_order(0 : i32)
// CHECK-NOT: arm_atomic.atomic_fence
// CHECK:     arm_atomic.atomic_store {{.*}} memory_order(0 : i32)

module {
  func.func @data_dep(%ptr1 : !ptr.ptr<#ptr.generic_space>,
                      %ptr2 : !ptr.ptr<#ptr.generic_space>) {
    %val = cpp_atomic.atomic_load %ptr1 memory_order(#cpp_atomic.memory_order<acquire>)
               : !ptr.ptr<#ptr.generic_space> -> i32
    // Stored value is the loaded result — data dep.
    cpp_atomic.atomic_store %val, %ptr2 memory_order(#cpp_atomic.memory_order<release>)
               : i32, !ptr.ptr<#ptr.generic_space>
    return
  }
}

// -----
// Test: no dependency — load and store operate on independent values and
// addresses.  The synthesis must insert ordering; the cheapest option is
// upgrading the load to acquire (cost 1 < fence cost 2).
//
// CHECK-LABEL: func @no_dep
// CHECK:     arm_atomic.atomic_load {{.*}} memory_order(2 : i32)
// CHECK-NOT: arm_atomic.atomic_fence
// CHECK:     arm_atomic.atomic_store {{.*}} memory_order(0 : i32)

module {
  func.func @no_dep(%ptr1 : !ptr.ptr<#ptr.generic_space>,
                    %ptr2 : !ptr.ptr<#ptr.generic_space>) {
    %unrelated = arith.constant 42 : i32
    %a = cpp_atomic.atomic_load %ptr1 memory_order(#cpp_atomic.memory_order<acquire>)
             : !ptr.ptr<#ptr.generic_space> -> i32
    // Stored value and address are independent of %a — no dep.
    cpp_atomic.atomic_store %unrelated, %ptr2 memory_order(#cpp_atomic.memory_order<release>)
             : i32, !ptr.ptr<#ptr.generic_space>
    return
  }
}
