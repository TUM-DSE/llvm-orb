//===- ArmAtomicToLLVM.h - ArmAtomic to LLVM Pass ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_CONVERSION_ARMATOMICTOLLVM_ARMATOMICTOLLVM_H_
#define MLIR_CONVERSION_ARMATOMICTOLLVM_ARMATOMICTOLLVM_H_

#include <memory>

namespace mlir {
class LLVMTypeConverter;
class Pass;
class RewritePatternSet;

#define GEN_PASS_DECL_CONVERTARMATOMICTOLLVMPASS
#include "mlir/Conversion/Passes.h.inc"

void populateArmAtomicToLLVMPatterns(LLVMTypeConverter &converter,
                                     RewritePatternSet &patterns);

} // namespace mlir

#endif // MLIR_CONVERSION_ARMATOMICTOLLVM_ARMATOMICTOLLVM_H_
