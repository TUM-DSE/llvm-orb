//===- CppAtomicOps.cpp - MLIRCppAtomic ops implementation --------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the CppAtomic dialect and its operations.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Orb/CppAtomicDialect.h"

using namespace mlir;

#include "mlir/Dialect/Orb/CppAtomicDialect.cpp.inc"

#include "mlir/Dialect/Orb/CppAtomicEnums.cpp.inc"

void cpp_atomic::CppAtomicDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/Orb/CppAtomic.cpp.inc"
      >();
}

#define GET_OP_CLASSES
#include "mlir/Dialect/Orb/CppAtomic.cpp.inc"
