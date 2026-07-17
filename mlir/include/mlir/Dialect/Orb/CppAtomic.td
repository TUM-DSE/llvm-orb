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

include "mlir/IR/OpBase.td"
include "mlir/IR/EnumAttr.td"

// Type predicate for !ptr.ptr<space> (from the MLIR ptr dialect)
def CppAtomic_AnyPtrType : Type<
    CPred<"::mlir::isa<::mlir::ptr::PtrType>($_self)">,
    "ptr.ptr type">;

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

def AtomicLoadOp : Op<CppAtomic_Dialect, "atomic_load", []> {
  let summary = "atomic load operation";
  let description = [{
    The `atomic_load` op reads a value through a `!ptr.ptr<>` using the provided
    memory ordering.  The result type must be supplied explicitly because
    `!ptr.ptr<>` carries no pointee type.

    Example:
    ```mlir
    %0 = cpp_atomic.atomic_load %ptr memory_order(acquire) : !ptr.ptr<generic> -> i32
    ```
  }];

  let arguments = (ins CppAtomic_AnyPtrType:$addr,
                       MemoryOrderAttr:$memory_order,
                       OptionalAttr<I64Attr>:$alignment);

  let results = (outs AnyType:$result);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "::mlir::Type":$resultType,
                   "Value":$addr,
                   "::mlir::cpp_atomic::MemoryOrder":$memory_order,
                   CArg<"::mlir::IntegerAttr", "nullptr">:$alignment), [{
      $_state.addTypes(resultType);
      $_state.addOperands(addr);
      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);
      if (alignment)
        $_state.addAttribute("alignment", alignment);
    }]>
  ];

  let assemblyFormat = [{
    $addr `memory_order` `(` $memory_order `)` (`align` `(` $alignment^ `)`)?
    attr-dict `:` type($addr) `->` type($result)
  }];
}

//===----------------------------------------------------------------------===//
// AtomicStoreOp
//===----------------------------------------------------------------------===//

def AtomicStoreOp : Op<CppAtomic_Dialect, "atomic_store", []> {
  let summary = "atomic store operation";
  let description = [{
    The `atomic_store` op writes a value through a `!ptr.ptr<>` using the provided
    memory ordering.

    Example:
    ```mlir
    cpp_atomic.atomic_store %val, %ptr memory_order(release) : i32, !ptr.ptr<generic>
    ```
  }];

  let arguments = (ins AnyType:$value,
                       CppAtomic_AnyPtrType:$addr,
                       MemoryOrderAttr:$memory_order,
                       OptionalAttr<I64Attr>:$alignment);

  let results = (outs);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$value,
                   "Value":$addr,
                   "::mlir::cpp_atomic::MemoryOrder":$memory_order,
                   CArg<"::mlir::IntegerAttr", "nullptr">:$alignment), [{
      $_state.addOperands(value);
      $_state.addOperands(addr);
      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);
      if (alignment)
        $_state.addAttribute("alignment", alignment);
    }]>
  ];

  let assemblyFormat = [{
    $value `,` $addr `memory_order` `(` $memory_order `)` (`align` `(` $alignment^ `)`)?
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

  let arguments = (ins MemoryOrderAttr:$memory_order,
                       OptionalAttr<StrAttr>:$syncscope);
  let results = (outs);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "::mlir::cpp_atomic::MemoryOrder":$memory_order,
                   "::mlir::StringAttr":$syncscope), [{
      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);
      if (syncscope)
        $_state.addAttribute("syncscope", syncscope);
    }]>
  ];

  let assemblyFormat = [{
    `memory_order` `(` $memory_order `)` (`syncscope` `(` $syncscope^ `)`)? attr-dict
  }];
}


#endif // CPPATOMIC_OPS