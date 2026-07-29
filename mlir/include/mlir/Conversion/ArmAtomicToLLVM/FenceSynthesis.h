//===- FenceSynthesis.h - Atomic fence synthesis pass ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_CONVERSION_ARMATOMICTOLLVM_FENCESYNTHESIS_H
#define MLIR_CONVERSION_ARMATOMICTOLLVM_FENCESYNTHESIS_H

#include <memory>

namespace mlir {
class Pass;
std::unique_ptr<Pass> createFenceSynthesisPass();
} // namespace mlir

#endif // MLIR_CONVERSION_ARMATOMICTOLLVM_FENCESYNTHESIS_H
