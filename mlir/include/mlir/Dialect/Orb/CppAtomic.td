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
// CppAtomic type definition
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// CppAtomic op definitions
//===----------------------------------------------------------------------===//
class CppAtomic_Op<string mnemonic, list<Trait> traits = []>
    : Op<CppAtomic_Dialect, mnemonic, traits>;


#endif // CPPATOMIC_OPS
