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
include "clang/CIR/Dialect/IR/CIRTypes.td"  // CIR type definitions

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

  let arguments = (ins CIR_PointerType:$addr, 
                      MemoryOrderAttr:$memory_order,
                      OptionalAttr<IntValidAlignment<I64Attr>>:$alignment);

  let results = (outs AnyType:$result);

  let builders = [
    OpBuilder<(ins "Value":$addr,
                   "::mlir::cpp_atomic::MemoryOrder":$memory_order,
                   CArg<"llvm::MaybeAlign", "llvm::MaybeAlign()">:$alignment), [{

      auto ptrType = ::llvm::cast<cir::PointerType>(addr.getType());
      Type resultType = ptrType.getPointee();

      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
          
      return build($_builder, $_state, resultType, addr, orderAttr,
                   alignment ? $_builder.getI64IntegerAttr(alignment->value()) :
                               nullptr);
    }]>,
  ];

  let assemblyFormat = [{
    $addr `memory_order` `(` $memory_order `)` attr-dict `:` type($addr)
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
                      CIR_PointerType:$addr, 
                      MemoryOrderAttr:$memory_order,
                      OptionalAttr<IntValidAlignment<I64Attr>>:$alignment);

  let results = (outs);                    

  let builders = [
    OpBuilder<(ins "Value":$value,
                   "Value":$addr,
                   "::mlir::cpp_atomic::MemoryOrder":$memory_order,
                   CArg<"llvm::MaybeAlign", "llvm::MaybeAlign()">:$alignment), [{
                   
      auto orderAttr = ::mlir::cpp_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
          
      build($_builder, $_state, value, addr, orderAttr,
            alignment ? $_builder.getI64IntegerAttr(alignment->value()) :
                        nullptr);
    }]>
  ];

  let assemblyFormat = [{
    $value `,` $addr `memory_order` `(` $memory_order `)` attr-dict `:` type($addr)
  }];
}


#endif // CPPATOMIC_OPS
