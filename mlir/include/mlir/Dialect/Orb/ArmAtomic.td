//===-- ArmAtomicOps.td - Arm Atomic dialect op definitions -*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the basic operations for the Arm Atomic dialect.
//
//===----------------------------------------------------------------------===//

#ifndef ARMATOMIC_OPS
#define ARMATOMIC_OPS

include "mlir/Dialect/LLVMIR/LLVMOpBase.td"
include "mlir/IR/OpBase.td"
include "mlir/IR/EnumAttr.td"
include "clang/CIR/Dialect/IR/CIRTypeConstraints.td"  // CIR type definitions

//===----------------------------------------------------------------------===//
// ArmAtomic dialect definition
//===----------------------------------------------------------------------===//

def ArmAtomic_Dialect : Dialect {
  let name = "arm_atomic";
  let cppNamespace = "::mlir::arm_atomic";

  // Note: this does not need to depend on LLVMDialect as long as functions in
  // this dialect (such as canonicalization) do not produce entities belonging
  // to the LLVMDialect (ops or types).
}

//===----------------------------------------------------------------------===//
// ArmAtomic Enum definition
//===----------------------------------------------------------------------===//

def ArmMemoryOrderRelaxed : I32EnumAttrCase<"Relaxed", 0, "relaxed">;
def ArmMemoryOrderAcquire : I32EnumAttrCase<"Acquire", 1, "acquire">;
def ArmMemoryOrderRelease : I32EnumAttrCase<"Release", 2, "release">;
def ArmMemoryOrderAcqRel  : I32EnumAttrCase<"AcqRel",  3, "acq_rel">;
// ARM does not have a native SeqCst instruction, so it is omitted here!

def ArmMemoryOrder : I32EnumAttr<
    "MemoryOrder", "ARM memory ordering for atomic operations", [
      ArmMemoryOrderRelaxed,
      ArmMemoryOrderAcquire,
      ArmMemoryOrderRelease,
      ArmMemoryOrderAcqRel
    ]> {
  let cppNamespace = "::mlir::arm_atomic";
}

def ArmMemoryOrderAttr : EnumAttr<ArmAtomic_Dialect, ArmMemoryOrder, "memory_order">;

//===----------------------------------------------------------------------===//
// ArmAtomic type definition
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// ArmAtomic op definitions
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// AtomicLoadOp
//===----------------------------------------------------------------------===//

def AtomicLoadOp : Op<ArmAtomic_Dialect, "atomic_load", [
      TypesMatchWith<"result type matches pointee type of 'addr'",
                     "addr", "result",
                     "::llvm::cast<cir::PointerType>($_self).getPointee()">
    ]> {
  let summary = "ARM atomic load operation (LDR/LDAR)";
  
  let arguments = (ins 
    CIR_AnyPtrType:$addr, 
    ArmMemoryOrderAttr:$memory_order,
    I64Attr:$alignment,
    UnitAttr:$isDeref,
    UnitAttr:$is_volatile
  );

  let results = (outs AnyType:$result);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$addr,
                   "::mlir::arm_atomic::MemoryOrder":$memory_order,
                   "uint64_t":$alignment,
                   "bool":$isDeref,
                   "bool":$is_volatile), [{
      
      auto ptrType = ::llvm::cast<cir::PointerType>(addr.getType());
      $_state.addTypes(ptrType.getPointee());

      $_state.addOperands(addr);
      
      auto orderAttr = ::mlir::arm_atomic::MemoryOrderAttr::get($_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);

      auto alignAttr = ::mlir::IntegerAttr::get(
          ::mlir::IntegerType::get($_builder.getContext(), 64), alignment);
      $_state.addAttribute("alignment", alignAttr);

      if (isDeref) {
        $_state.addAttribute("isDeref", $_builder.getUnitAttr());
      }
      if (is_volatile) {
        $_state.addAttribute("is_volatile", $_builder.getUnitAttr());
      }
    }]>
  ];

  let assemblyFormat = [{ 
    (`deref` $isDeref^)? 
    (`volatile` $is_volatile^)? 
    $addr `memory_order` `(` $memory_order `)` `align` `(` $alignment `)` 
    attr-dict `:` type($addr) 
  }];
}

//===----------------------------------------------------------------------===//
// AtomicStoreOp
//===----------------------------------------------------------------------===//

def AtomicStoreOp : Op<ArmAtomic_Dialect, "atomic_store", [
      TypesMatchWith<"value type matches pointee type of 'addr'",
                     "addr", "value",
                     "::llvm::cast<cir::PointerType>($_self).getPointee()">
    ]> {
  let summary = "ARM atomic store operation (STR/STLR)";

  let arguments = (ins AnyType:$value, 
                      CIR_AnyPtrType:$addr, 
                      ArmMemoryOrderAttr:$memory_order,
                      I64Attr:$alignment,
                      UnitAttr:$is_volatile
  );

  let results = (outs);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$value, 
                   "Value":$addr,
                   "::mlir::arm_atomic::MemoryOrder":$memory_order,
                   "uint64_t":$alignment,
                   "bool":$is_volatile), [{
                   
      $_state.addOperands(value);
      $_state.addOperands(addr);
      
      auto orderAttr = ::mlir::arm_atomic::MemoryOrderAttr::get($_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);

      auto alignAttr = ::mlir::IntegerAttr::get(
          ::mlir::IntegerType::get($_builder.getContext(), 64), alignment);
      $_state.addAttribute("alignment", alignAttr);

      if (is_volatile) {
        $_state.addAttribute("is_volatile", $_builder.getUnitAttr());
      }
    }]>
  ];

  let assemblyFormat = [{ 
    (`volatile` $is_volatile^)? 
    $value `,` $addr `memory_order` `(` $memory_order `)` `align` `(` $alignment `)` 
    attr-dict `:` type($value) `,` type($addr) 
  }];
}

//===----------------------------------------------------------------------===//
// AtomicFenceOp
//===----------------------------------------------------------------------===//

def AtomicFenceOp : Op<ArmAtomic_Dialect, "atomic_fence"> {
  let summary = "ARM atomic fence operation (DMB)";

  let description = [{
    Represents an ARM atomic fence. It establishes memory synchronization 
    ordering without an associated atomic variable.
  }];

  let arguments = (ins ArmMemoryOrderAttr:$memory_order);
  let results = (outs);
  
  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "::mlir::arm_atomic::MemoryOrder":$memory_order), [{
      
      auto orderAttr = ::mlir::arm_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
          
      $_state.addAttribute("memory_order", orderAttr);
    }]>
  ];

  let assemblyFormat = [{
    `memory_order` `(` $memory_order `)` attr-dict
  }];
}

//===----------------------------------------------------------------------===//
// AtomicCmpXchgOp
//===----------------------------------------------------------------------===//

def AtomicCmpXchgOp : Op<ArmAtomic_Dialect, "atomic_cmpxchg", [
    TypesMatchWith<"expected type matches pointee type of 'addr'", 
                   "addr", "expected", 
                   "::llvm::cast<cir::PointerType>($_self).getPointee()">,
                   
    TypesMatchWith<"desired type matches pointee type of 'addr'", 
                   "addr", "desired", 
                   "::llvm::cast<cir::PointerType>($_self).getPointee()">,

    TypesMatchWith<"loaded type matches pointee type of 'addr'", 
                   "addr", "loaded", 
                   "::llvm::cast<cir::PointerType>($_self).getPointee()">
  ]> {
  let summary = "ARM-specific atomic compare-and-exchange operation";
  let description = [{
    The `atomic_cmpxchg` op in the ArmAtomic dialect atomically compares the value
    at the pointer address with the `expected` value. If they are equal, it 
    replaces the memory with the `desired` value, mapped to ARM memory semantics. 

    It returns two values:
    1. The value that was actually loaded from memory.
    2. A boolean (i1) indicating if the exchange was successful.

    Example:
    ```mlir
    %loaded, %success = arm_atomic.atomic_cmpxchg %ptr, %expected, %desired 
        success_order(seq_cst) failure_order(acquire) align(4) : !cir.ptr<i32>, i1
    ```
  }];

  let arguments = (ins CIR_AnyPtrType:$addr,
                       AnyType:$expected,
                       AnyType:$desired,
                       ArmMemoryOrderAttr:$success_order,
                       ArmMemoryOrderAttr:$failure_order,
                       I64Attr:$alignment,
                       UnitAttr:$weak,
                       UnitAttr:$is_volatile);

  let results = (outs AnyType:$loaded, AnyType:$success);                  
  
  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$addr,
                   "Value":$expected,
                   "Value":$desired,
                   "::mlir::arm_atomic::MemoryOrder":$success_order,
                   "::mlir::arm_atomic::MemoryOrder":$failure_order,
                   "uint64_t":$alignment,
                   "bool":$weak,
                   "bool":$is_volatile), [{
                   
      $_state.addOperands(addr);
      $_state.addOperands(expected);
      $_state.addOperands(desired);
      
      auto successAttr = ::mlir::arm_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), success_order);
      $_state.addAttribute("success_order", successAttr);

      auto failureAttr = ::mlir::arm_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), failure_order);
      $_state.addAttribute("failure_order", failureAttr);
      
      auto alignAttr = ::mlir::IntegerAttr::get(
          ::mlir::IntegerType::get($_builder.getContext(), 64), alignment);
      $_state.addAttribute("alignment", alignAttr);

      if (weak) {
        $_state.addAttribute("weak", $_builder.getUnitAttr());
      }
      if (is_volatile) {
        $_state.addAttribute("is_volatile", $_builder.getUnitAttr());
      }

      auto ptrType = ::llvm::cast<cir::PointerType>(addr.getType());
      $_state.addTypes(ptrType.getPointee()); 

      $_state.addTypes(cir::BoolType::get($_builder.getContext()));
    }]>
  ];

  let assemblyFormat = [{ 
    (`weak` $weak^)? 
    (`volatile` $is_volatile^)? 
    $addr `,` $expected `,` $desired 
    `success_order` `(` $success_order `)` 
    `failure_order` `(` $failure_order `)` 
    `align` `(` $alignment `)` 
    attr-dict `:` type($addr) `,` type($success)
  }];
}

#endif // ARMATOMIC_OPS
