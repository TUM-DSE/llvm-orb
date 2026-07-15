//===-- CppAtomic.td - Cpp Atomic dialect op definitions ---*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the basic operations for the Cpp Atomic dialect.
//
//===----------------------------------------------------------------------===//

#ifndef CPPATOMIC_OPS
#define CPPATOMIC_OPS

include "mlir/Dialect/LLVMIR/LLVMOpBase.td"
include "mlir/IR/OpBase.td"
include "mlir/IR/EnumAttr.td"
include "clang/CIR/Dialect/IR/CIRTypeConstraints.td"  // CIR type definitions

//===----------------------------------------------------------------------===//
// CppAtomic dialect definition
//===----------------------------------------------------------------------===//

def CppAtomic_Dialect : Dialect {
  let name = "cpp_atomic";
  let cppNamespace = "::mlir::cpp_atomic";

  let summary = "A high-level dialect for analyzing atomics under the RC11 memory model";


  // Note: this does not need to depend on LLVMDialect as long as functions in
  // this dialect (such as canonicalization) do not produce entities belonging
  // to the LLVMDialect (ops or types).
}

//===----------------------------------------------------------------------===//
// CppAtomic enum definitions
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Memory Order Enum
//===----------------------------------------------------------------------===//

def MemoryOrderRelaxed   : I32EnumAttrCase<"Relaxed", 0, "relaxed">;
def MemoryOrderAcquire   : I32EnumAttrCase<"Acquire", 1, "acquire">;
def MemoryOrderRelease   : I32EnumAttrCase<"Release", 2, "release">;
def MemoryOrderAcqRel    : I32EnumAttrCase<"AcqRel", 3, "acq_rel">;
def MemoryOrderSeqCst    : I32EnumAttrCase<"SeqCst", 4, "seq_cst">;

def MemoryOrder : I32EnumAttr<
    "MemoryOrder", "memory ordering for atomic operations", [
      MemoryOrderRelaxed,
      MemoryOrderAcquire,
      MemoryOrderRelease,
      MemoryOrderAcqRel,
      MemoryOrderSeqCst
    ]> {
      let cppNamespace = "mlir::cpp_atomic";
    }

def MemoryOrderAttr : EnumAttr<CppAtomic_Dialect, MemoryOrder, "memory_order">;

//===----------------------------------------------------------------------===//
// Atomic Fetch Binary Operations Enum
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Atomic Fetch Binary Operations Enum
//===----------------------------------------------------------------------===//

def BinOpAdd  : I32EnumAttrCase<"Add",  0, "add">;
def BinOpSub  : I32EnumAttrCase<"Sub",  1, "sub">;
def BinOpAnd  : I32EnumAttrCase<"And",  2, "and">;
def BinOpOr   : I32EnumAttrCase<"Or",   3, "or">;
def BinOpXor  : I32EnumAttrCase<"Xor",  4, "xor">;
def BinOpNand : I32EnumAttrCase<"Nand", 5, "nand">;
def BinOpMax  : I32EnumAttrCase<"Max",  6, "max">;
def BinOpMin  : I32EnumAttrCase<"Min",  7, "min">;

def BinOp : I32EnumAttr<
    "BinOp", "C++ atomic fetch binary operations", [
      BinOpAdd,
      BinOpSub,
      BinOpAnd,
      BinOpOr,
      BinOpXor,
      BinOpNand,
      BinOpMax,
      BinOpMin
    ]> {
      let cppNamespace = "mlir::cpp_atomic";
    }

def BinOpAttr : EnumAttr<CppAtomic_Dialect, BinOp, "binop">;

//===----------------------------------------------------------------------===//
// CppAtomic type definition
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// CppAtomic op definitions
//===----------------------------------------------------------------------===//
class CppAtomic_Op<string mnemonic, list<Trait> traits = []>
    : Op<CppAtomic_Dialect, mnemonic, traits>;


//===----------------------------------------------------------------------===//
// AtomicLoadOp
//===----------------------------------------------------------------------===//

def AtomicLoadOp : Op<CppAtomic_Dialect, "atomic_load", [
        TypesMatchWith<"result type matches pointee type of 'addr'", "addr", "result",
         "::llvm::cast<cir::PointerType>($_self).getPointee()">
    ]> {
  let summary = "atomic load operation";
  let description = [{
    The `atomic_load` op reads an element from a ClangIR pointer using the provided memory ordering.

    The single result of `cpp_atomic.atomic_load` is a value with the same type
    as the element type of the memref.

    The `memory_order` attribute specifies the atomic ordering semantics for
    the load.

    An optional `alignment` attribute allows to specify the byte alignment of the
    load operation. It must be a positive power of 2. The operation must access
    memory at an address aligned to this boundary. Violations may lead to
    architecture-specific faults or performance penalties.
    A value of 0 indicates no specific alignment requirement.
    Example:

    ```mlir
    %0 = cpp_atomic.atomic_load %ptr memory_order(acquire) : !cir.ptr<i32> -> i32
    ```
  }];

  let arguments = (ins CIR_AnyPtrType:$addr, 
                      MemoryOrderAttr:$memory_order,
                      I64Attr:$alignment,
                      UnitAttr:$isDeref,
                      UnitAttr:$is_volatile);

  let results = (outs AnyType:$result);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$addr,
                   "::mlir::cpp_atomic::MemoryOrder":$memory_order,
                   "uint64_t":$alignment,
                   "bool":$isDeref,
                   "bool":$is_volatile), [{

      auto ptrType = ::llvm::cast<cir::PointerType>(addr.getType());
      $_state.addTypes(ptrType.getPointee());

      $_state.addOperands(addr);
      
      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
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

def AtomicStoreOp : Op<CppAtomic_Dialect, "atomic_store", [
            TypesMatchWith<"value type matches pointee type of 'addr'", 
            "addr", "value", 
            "::llvm::cast<cir::PointerType>($_self).getPointee()">
  ]> {
  let summary = "atomic store operation";
  let description = [{
    The `atomic_store` op writes a value to a pointer address (like `!cir.ptr`) 
    using the provided memory ordering.

    The `memory_order` attribute specifies the atomic ordering semantics.
    An optional `alignment` attribute specifies the byte alignment.

    An optional `alignment` attribute allows to specify the byte alignment of the
    store operation. It must be a positive power of 2. The operation must access
    memory at an address aligned to this boundary. Violations may lead to
    architecture-specific faults or performance penalties.
    A value of 0 indicates no specific alignment requirement.
    Example:

    ```mlir
    cpp_atomic.atomic_store %val, %ptr memory_order(release) : i32, !cir.ptr<i32>
    ```
  }];

  let arguments = (ins AnyType:$value,
                      CIR_AnyPtrType:$addr, 
                      MemoryOrderAttr:$memory_order,
                      I64Attr:$alignment,
                      UnitAttr:$is_volatile);

  let results = (outs);                    
  
  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$value,
                   "Value":$addr,
                   "::mlir::cpp_atomic::MemoryOrder":$memory_order,
                   "uint64_t":$alignment,
                   "bool":$is_volatile), [{
                   
      $_state.addOperands(value);
      $_state.addOperands(addr);
      
      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
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

def AtomicFenceOp : Op<CppAtomic_Dialect, "atomic_fence"> {
  let summary = "C++ atomic fence operation";
  let description = [{
    Represents a std::atomic_thread_fence. It establishes memory synchronization 
    ordering without an associated atomic variable.
  }];

  let arguments = (ins MemoryOrderAttr:$memory_order);
  let results = (outs);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "::mlir::cpp_atomic::MemoryOrder":$memory_order), [{
      
      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
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

def AtomicCmpXchgOp : Op<CppAtomic_Dialect, "atomic_cmpxchg", [
    TypesMatchWith<"expected type matches pointee type of 'addr'", 
                   "addr", "expected", 
                   "::llvm::cast<cir::PointerType>($_self).getPointee()">,
    TypesMatchWith<"desired type matches pointee type of 'addr'", 
                   "addr", "desired", 
                   "::llvm::cast<cir::PointerType>($_self).getPointee()">,
    TypesMatchWith<"loaded type matches pointee type of 'addr'", 
                   "addr", "loaded", 
                   "::llvm::cast<cir::PointerType>($_self).getPointee()">,
  ]> {
  let summary = "atomic compare-and-exchange operation";
  let description = [{
    The `atomic_cmpxchg` op atomically compares the value at the pointer address 
    with the `expected` value. If they are equal, it replaces the memory with the 
    `desired` value. 

    It returns two values:
    1. The value that was actually loaded from memory.
    2. A boolean (i1) indicating if the exchange was successful.

    Example:
    ```mlir
    %loaded, %success = cpp_atomic.atomic_cmpxchg %ptr, %expected, %desired 
        success_order(seq_cst) failure_order(acquire) align(4) : !cir.ptr<i32>, i1
    ```
  }];

  let arguments = (ins CIR_AnyPtrType:$addr,
                       AnyType:$expected,
                       AnyType:$desired,
                       MemoryOrderAttr:$success_order,
                       MemoryOrderAttr:$failure_order,
                       I64Attr:$alignment,
                       UnitAttr:$weak,
                       UnitAttr:$is_volatile);

  let results = (outs AnyType:$loaded, AnyType:$success);                  
  
  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$addr,
                   "Value":$expected,
                   "Value":$desired,
                   "::mlir::cpp_atomic::MemoryOrder":$success_order,
                   "::mlir::cpp_atomic::MemoryOrder":$failure_order,
                   "uint64_t":$alignment,
                   "bool":$weak,
                   "bool":$is_volatile), [{
                   
      $_state.addOperands(addr);
      $_state.addOperands(expected);
      $_state.addOperands(desired);
      
      auto successAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), success_order);
      $_state.addAttribute("success_order", successAttr);

      auto failureAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
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

//===----------------------------------------------------------------------===//
// AtomicFetchOp
//===----------------------------------------------------------------------===//

def AtomicFetchOp : Op<CppAtomic_Dialect, "atomic_fetch", [
        TypesMatchWith<"result type matches pointee type of 'addr'", "addr", "result",
                       "::llvm::cast<cir::PointerType>($_self).getPointee()">,
        AllTypesMatch<["value", "result"]>
    ]> {
  let summary = "atomic fetch-and-modify operation";
  let description = [{
    The `atomic_fetch` op atomically reads a value, performs a binary operation, 
    and stores it back. 

    If `fetch_first` is true, it returns the old value that was loaded. If false, 
    it returns the value that resulted from the binary operation.
  }];

  let arguments = (ins AnyType:$value,
                       CIR_AnyPtrType:$addr,
                       BinOpAttr:$binop,
                       MemoryOrderAttr:$memory_order,
                       UnitAttr:$is_volatile,
                       UnitAttr:$fetch_first);

  let results = (outs AnyType:$result);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$value,
                   "Value":$addr,
                   "::mlir::cpp_atomic::BinOp":$binop,
                   "::mlir::cpp_atomic::MemoryOrder":$memory_order,
                   "bool":$is_volatile,
                   "bool":$fetch_first), [{
      
      $_state.addOperands(value);
      $_state.addOperands(addr);
      $_state.addTypes(value.getType());
      
      auto binopAttr = ::mlir::cpp_atomic::BinOpAttr::get(
          $_builder.getContext(), binop);
      $_state.addAttribute("binop", binopAttr);

      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);

      if (is_volatile) $_state.addAttribute("is_volatile", $_builder.getUnitAttr());
      if (fetch_first) $_state.addAttribute("fetch_first", $_builder.getUnitAttr());
    }]>
  ];

  let assemblyFormat = [{ 
    (`volatile` $is_volatile^)? (`fetch_first` $fetch_first^)?
    $binop $value `,` $addr `memory_order` `(` $memory_order `)` 
    attr-dict `:` type($value) `,` type($addr) 
  }];
}

//===----------------------------------------------------------------------===//
// AtomicXchgOp
//===----------------------------------------------------------------------===//

def AtomicXchgOp : Op<CppAtomic_Dialect, "atomic_xchg", [
    AllTypesMatch<["result", "value"]>,
    TypesMatchWith<"value type matches pointee type of 'addr'", 
                   "addr", "value", 
                   "::llvm::cast<cir::PointerType>($_self).getPointee()">
  ]> {
  let summary = "atomic exchange operation";
  let description = [{
    The `atomic_xchg` op atomically replaces the value of the object pointed-to
    by `addr` with `value`, and returns the original value of the object.

    Example:
    ```mlir
    %res = cpp_atomic.atomic_xchg %val, %ptr memory_order(seq_cst) : i32, !cir.ptr<i32>
    ```
  }];

  let arguments = (ins AnyType:$value,
                       CIR_AnyPtrType:$addr, 
                       MemoryOrderAttr:$memory_order,
                       UnitAttr:$is_volatile);

  let results = (outs AnyType:$result);                  
  
  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$value,
                   "Value":$addr,
                   "::mlir::cpp_atomic::MemoryOrder":$memory_order,
                   "bool":$is_volatile), [{
                   
      $_state.addOperands(value);
      $_state.addOperands(addr);
      
      $_state.addTypes(value.getType());
      
      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);

      if (is_volatile) $_state.addAttribute("is_volatile", $_builder.getUnitAttr());
    }]>
  ];

  let assemblyFormat = [{ 
    (`volatile` $is_volatile^)? 
    $value `,` $addr `memory_order` `(` $memory_order `)` 
    attr-dict `:` type($value) `,` type($addr) 
  }];
}

#endif // CPPATOMIC_OPS