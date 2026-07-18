add_mlir_conversion_library(MLIRArmAtomicToLLVM
  ArmAtomicToLLVM.cpp
  FenceSynthesis.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Conversion/ArmAtomicToLLVM

  DEPENDS
  MLIRConversionPassIncGen
  MLIRArmAtomicIncGen

  LINK_LIBS PRIVATE
  MLIRAnalysis
  MLIRPass
  MLIRTransforms
  MLIRArmAtomicDialect
  MLIROrbAtomicInterface
  MLIRLLVMCommonConversion
  MLIRLLVMDialect
  MLIRPtrDialect
)
