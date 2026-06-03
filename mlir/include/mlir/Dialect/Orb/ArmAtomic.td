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
// ArmAtomic type definition
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// ArmAtomic op definitions
//===----------------------------------------------------------------------===//

#endif // ARMATOMIC_OPS
