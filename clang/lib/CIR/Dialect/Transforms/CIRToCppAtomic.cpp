//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "PassDetail.h"
#include "mlir/Dialect/Orb/CppAtomicDialect.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Region.h"
#include "mlir/Support/LogicalResult.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "mlir/Transforms/WalkPatternRewriteDriver.h"
#include "mlir/Transforms/DialectConversion.h"
#include "clang/CIR/Dialect/IR/CIRDialect.h"
#include "clang/CIR/Dialect/Passes.h"
#include "llvm/ADT/SmallVector.h"

using namespace mlir;
using namespace cir;

namespace mlir {
#define GEN_PASS_DEF_CIRTOCPPATOMIC
#include "clang/CIR/Dialect/Passes.h.inc"
} // namespace mlir

//===----------------------------------------------------------------------===//
// Rewrite patterns
//===----------------------------------------------------------------------===//

namespace {


// struct BrRewriter : public OpConversionPattern<cir::BrOp> {

//   BrRewriter(MLIRContext *context)
//       : OpConversionPattern<cir::BrOp>(context) {}

//   LogicalResult matchAndRewrite(cir::BrOp brOp, OpAdaptor adaptor,
//                                 ConversionPatternRewriter &rewriter) const override {
//     auto *cir_dst = brOp.getDest();
//     rewriter.replaceOpWithNewOp<cf::BranchOp>(brOp, cir_dst);
//     return success();
//   }
// };


void populateCIRToCppAtomicPatterns(RewritePatternSet &patterns) {
//   patterns.add<BrCondRewriter>(patterns.getContext(), typeConverter);
//   patterns.add<BrRewriter>(patterns.getContext());
//   patterns.add<SwitchRewriter>(patterns.getContext(), typeConverter);
}

//===----------------------------------------------------------------------===//
// Pass definition
// ===----------------------------------------------------------------------===//

struct CIRToCppAtomicPass : public impl::CIRToCppAtomicBase<CIRToCppAtomicPass> {
  CIRToCppAtomicPass() = default;
  void runOnOperation() override;
};

void CIRToCppAtomicPass::runOnOperation() {
  MLIRContext *context = &getContext();
  ConversionTarget target(*context);
  target.addLegalDialect<cpp_atomic::CppAtomicDialect>();
  //target.addLegalOp<mlir::UnrealizedConversionCastOp>();
  //target.addIllegalOp<cir::BrCondOp, cir::BrOp, cir::SwitchFlatOp>();

  RewritePatternSet patterns(context);

  populateCIRToCppAtomicPatterns(patterns);

  if (failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
    signalPassFailure();
}

} // namespace

std::unique_ptr<Pass> mlir::createCIRToCppAtomicPass() {
  return std::make_unique<CIRToCppAtomicPass>();
}
