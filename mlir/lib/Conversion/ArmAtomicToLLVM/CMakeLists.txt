add_mlir_conversion_library(MLIRArmAtomicToLLVM
  ArmAtomicToLLVM.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Conversion/ArmAtomicToLLVM

  DEPENDS
  MLIRConversionPassIncGen
  MLIRArmAtomicIncGen

  LINK_LIBS PRIVATE
  MLIRPass
  MLIRTransforms
  MLIRArmAtomicDialect
  MLIRLLVMCommonConversion
  MLIRLLVMDialect
  MLIRPtrDialect
)
