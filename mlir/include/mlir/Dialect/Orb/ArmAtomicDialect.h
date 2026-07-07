//===- ArmAtomicDialect.h - MLIR Dialect for Arm atomics --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares the Target dialect for ArmAtomic in MLIR.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_ARMATOMIC_ARMATOMICDIALECT_H_
#define MLIR_DIALECT_ARMATOMIC_ARMATOMICDIALECT_H_

#include "mlir/IR/Builders.h"
#include "mlir/Bytecode/BytecodeOpInterface.h"

#include "mlir/Dialect/Orb/ArmAtomicDialect.h.inc"
#include "mlir/Dialect/Orb/ArmAtomicEnums.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/Orb/ArmAtomic.h.inc"

#endif // MLIR_DIALECT_ARMATOMIC_ARMATOMICDIALECT_H_
