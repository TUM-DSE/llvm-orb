add_mlir_dialect_library(MLIRCppAtomicTransformOps
  CppAtomicTransformOps.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Orb/TransformOps

  DEPENDS
  MLIRCppAtomicTransformOpsIncGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRLLVMCommonConversion
  MLIRLLVMDialect
  MLIRTransformDialect
  MLIRCppAtomicDialect
  MLIRArmAtomicDialect
  )
