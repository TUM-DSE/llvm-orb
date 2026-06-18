//===- CppAtomicDialect.h - MLIR Dialect for Cpp atomics --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the Target dialect for CppAtomic in MLIR.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_CPPATOMIC_CPPATOMICDIALECT_H_
#define MLIR_DIALECT_CPPATOMIC_CPPATOMICDIALECT_H_

#include "mlir/Bytecode/BytecodeOpInterface.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

#include "mlir/Dialect/Orb/CppAtomicDialect.h.inc"
#include "mlir/Dialect/Orb/CppAtomicEnums.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/Orb/CppAtomic.h.inc"

#endif // MLIR_DIALECT_CPPATOMIC_CPPATOMICDIALECT_H_
