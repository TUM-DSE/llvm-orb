//===- CPPAtomicTransformOps.h - CPP atomic conversion ops -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_CPP_ATOMIC_TRANSFORMOPS_CONVERSIONOPS_H
#define MLIR_DIALECT_CPP_ATOMIC_TRANSFORMOPS_CONVERSIONOPS_H

#include "mlir/Dialect/Transform/Interfaces/TransformInterfaces.h"
#include "mlir/IR/OpImplementation.h"

//===----------------------------------------------------------------------===//
// CPP Atomic Conversion Operations
//===----------------------------------------------------------------------===//

#define GET_OP_CLASSES
#include "mlir/Dialect/Orb/TransformOps/CppAtomicTransformOps.h.inc"

namespace mlir {
class DialectRegistry;

namespace cpp_atomic {
void registerTransformDialectExtension(DialectRegistry &registry);

} // namespace cpp_atomic
} // namespace mlir

#endif // MLIR_DIALECT_CPP_ATOMIC_TRANSFORMOPS_CONVERSIONOPS_H
