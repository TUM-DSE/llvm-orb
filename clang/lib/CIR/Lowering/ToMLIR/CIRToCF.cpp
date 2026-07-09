//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "PassDetail.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/ControlFlow/IR/ControlFlowOps.h"
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
#define GEN_PASS_DEF_CIRTOCF
#include "clang/CIR/Dialect/Passes.h.inc"
} // namespace mlir

//===----------------------------------------------------------------------===//
// Rewrite patterns
//===----------------------------------------------------------------------===//

namespace {

struct BrCondRewriter : public OpConversionPattern<cir::BrCondOp> {

  BrCondRewriter(MLIRContext *context, TypeConverter &typeConverter)
      : OpConversionPattern<cir::BrCondOp>(typeConverter, context) {}

  LogicalResult matchAndRewrite(cir::BrCondOp cbrOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {


    auto cir_cond_bool = adaptor.getCond();
    auto *cir_true = cbrOp.getDestTrue();
    auto *cir_false = cbrOp.getDestFalse();

    auto cf_br = cf::CondBranchOp::create(rewriter, cbrOp.getLoc(), cir_cond_bool, cir_true, cir_false);
    rewriter.eraseOp(cbrOp);
    //rewriter.replaceOpWithNewOp<cf::CondBranchOp>(cbrOp, cir_cond_bool, cir_true,
    //    cir_false);
    return success();
  }
};

struct BrRewriter : public OpConversionPattern<cir::BrOp> {

  BrRewriter(MLIRContext *context, TypeConverter &typeConverter)
      : OpConversionPattern<cir::BrOp>(typeConverter, context) {}

  LogicalResult matchAndRewrite(cir::BrOp brOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    Block *dest = brOp.getDest();
    ValueRange convertedOps = adaptor.getDestOperands();

    // Convert destination block argument types to match the converted operands.
    // Only convert if types don't already match (avoids double-conversion when
    // multiple predecessors branch to the same block).
    if (!convertedOps.empty() &&
        dest->getArgument(0).getType() != convertedOps[0].getType()) {
      TypeConverter::SignatureConversion sigConv(dest->getNumArguments());
      for (auto [idx, val] : llvm::enumerate(convertedOps))
        sigConv.addInputs(idx, val.getType());
      dest = rewriter.applySignatureConversion(dest, sigConv, getTypeConverter());
    }

    rewriter.replaceOpWithNewOp<cf::BranchOp>(brOp, dest, convertedOps);
    return success();
  }
};

struct SwitchRewriter : public OpConversionPattern<cir::SwitchFlatOp> {

  SwitchRewriter(MLIRContext *context, TypeConverter &typeConverter)
      : OpConversionPattern<cir::SwitchFlatOp>(typeConverter, context) {}

  LogicalResult matchAndRewrite(cir::SwitchFlatOp switchOp, OpAdaptor adaptor,
                                ConversionPatternRewriter &rewriter) const override {
    auto cir_cond = adaptor.getCondition();

    auto cir_default = switchOp.getDefaultDestination();
    auto cir_defaultOp = switchOp.getDefaultOperands();

    auto cir_cases_raw = switchOp.getCaseValues();
    SmallVector<int32_t> cir_cases;
    for (auto caseVal : cir_cases_raw) {
      auto intAttr = cast<cir::IntAttr>(caseVal);
      cir_cases.push_back(intAttr.getValue().getSExtValue());
    }

    auto cir_dsts_raw = switchOp.getCaseDestinations();
    auto cir_caseOps_raw = switchOp.getCaseOperands();

    SmallVector<Block *> cir_dsts(cir_dsts_raw.begin(), cir_dsts_raw.end());
    SmallVector<ValueRange> cir_caseOps(cir_caseOps_raw.begin(), cir_caseOps_raw.end());

    auto cf_switch = cf::SwitchOp::create(rewriter, switchOp.getLoc(), cir_cond, cir_default, cir_defaultOp, rewriter.getI32TensorAttr(cir_cases), cir_dsts, cir_caseOps);
    rewriter.eraseOp(switchOp);
    //rewriter.replaceOpWithNewOp<cf::SwitchOp>(switchOp, cir_cond, cir_default, cir_defaultOp, rewriter.getI32TensorAttr(cir_cases), cir_dsts, cir_caseOps);

    return success();
  }
};

void populateCIRToCFPatterns(RewritePatternSet &patterns, TypeConverter &typeConverter) {
  patterns.add<BrCondRewriter>(patterns.getContext(), typeConverter);
  patterns.add<BrRewriter>(patterns.getContext(), typeConverter);
  patterns.add<SwitchRewriter>(patterns.getContext(), typeConverter);
}

void populateTypeConversions(TypeConverter &typeConverter, MLIRContext *context) {
  typeConverter.addConversion([](mlir::Type type) { return type; });
  typeConverter.addConversion([&](cir::BoolType type) -> mlir::Type {
    return mlir::IntegerType::get(type.getContext(), 1,
                                  mlir::IntegerType::Signless);
  });
  typeConverter.addConversion([&](cir::IntType type) -> mlir::Type {
    return mlir::IntegerType::get(type.getContext(), type.getWidth(),
                                  mlir::IntegerType::Signless);
  });

  typeConverter.addSourceMaterialization([](OpBuilder &builder, mlir::Type srcTy,
    mlir::ValueRange inputs,
    mlir::Location loc) -> Value {
      if (inputs.size() != 1)
        return nullptr;
      //if (!isa<cir::BoolType>(srcTy))
      //  return nullptr;

      return mlir::UnrealizedConversionCastOp::create(builder, loc, srcTy, inputs[0]).getResult(0);
  });

  typeConverter.addTargetMaterialization([](OpBuilder &builder, mlir::Type dstTy,
    mlir::ValueRange inputs,
    mlir::Location loc) -> Value {
      if (inputs.size() != 1)
        return nullptr;

      auto InTy = inputs[0].getType();
      if (!isa<cir::BoolType>(InTy) && !isa<cir::IntType>(InTy))
        return nullptr;

      //if (isa<cir::IntType>(InTy)) {
      //  auto InIntTy = cast<cir::IntType>(InTy);
      //  if (InIntTy.getWidth() != 32 || !InIntTy.isSigned())
      //    return nullptr;
      //}

      return mlir::UnrealizedConversionCastOp::create(builder, loc, dstTy, inputs[0]).getResult(0);
  });
}

//===----------------------------------------------------------------------===//
// Pass definition
// ===----------------------------------------------------------------------===//

struct CIRToCFPass : public impl::CIRToCFBase<CIRToCFPass> {
  CIRToCFPass() = default;
  void runOnOperation() override;
};

void CIRToCFPass::runOnOperation() {
  MLIRContext *context = &getContext();
  ConversionTarget target(*context);
  target.addLegalDialect<cf::ControlFlowDialect>();
  target.addLegalOp<mlir::UnrealizedConversionCastOp>();
  target.addIllegalOp<cir::BrCondOp, cir::BrOp, cir::SwitchFlatOp>();

  RewritePatternSet patterns(context);
  TypeConverter typeConverter;

  populateTypeConversions(typeConverter, context);
  populateCIRToCFPatterns(patterns, typeConverter);

  if (failed(applyPartialConversion(getOperation(), target, std::move(patterns))))
    signalPassFailure();
}

} // namespace

std::unique_ptr<Pass> mlir::createCIRToCFPass() {
  return std::make_unique<CIRToCFPass>();
}
