//===- CppAtomicToArmAtomic.h - CppAtomic to ArmAtomic Pass -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_CONVERSION_CPPATOMICTOARMATOMIC_CPPATOMICTOARMATOMIC_H_
#define MLIR_CONVERSION_CPPATOMICTOARMATOMIC_CPPATOMICTOARMATOMIC_H_

#include <memory>

namespace mlir {
class Pass;
class RewritePatternSet;

#define GEN_PASS_DECL_CONVERTCPPATOMICTOARMATOMICPASS
#include "mlir/Conversion/Passes.h.inc"

} // namespace mlir

#endif // MLIR_CONVERSION_CPPATOMICTOARMATOMIC_CPPATOMICTOARMATOMIC_H_
