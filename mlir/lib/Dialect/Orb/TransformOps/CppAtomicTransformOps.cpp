//===- CppAtomicTransformOps.cpp - Implementation conversion ops -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Orb/TransformOps/CppAtomicTransformOps.h"

#include "mlir/Dialect/Orb/ArmAtomicDialect.h"
#include "mlir/Dialect/Orb/CppAtomicDialect.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"

using namespace mlir;

//===----------------------------------------------------------------------===//
// Apply...PatternsOp
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Transform op registration
//===----------------------------------------------------------------------===//

namespace {
class CppAtomicTransformDialectExtension
    : public transform::TransformDialectExtension<
          CppAtomicTransformDialectExtension> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(
      CppAtomicTransformDialectExtension)

  CppAtomicTransformDialectExtension() {
    declareGeneratedDialect<arm_atomic::ArmAtomicDialect>();
    registerTransformOps<
#define GET_OP_LIST
#include "mlir/Dialect/Orb/TransformOps/CppAtomicTransformOps.cpp.inc"
        >();
  }
};
} // namespace

#define GET_OP_CLASSES
#include "mlir/Dialect/Orb/TransformOps/CppAtomicTransformOps.cpp.inc"

void mlir::cpp_atomic::registerTransformDialectExtension(
    DialectRegistry &registry) {
  registry.addExtensions<CppAtomicTransformDialectExtension>();
}
