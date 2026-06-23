add_mlir_conversion_library(MLIRCppAtomicToArmAtomic
  CppAtomicToArmAtomic.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Conversion/CppAtomicToArmAtomic

  DEPENDS
  MLIRConversionPassIncGen
  MLIRCppAtomicIncGen
  MLIRArmAtomicIncGen

  LINK_LIBS PUBLIC
  MLIRPass
  MLIRTransforms
  MLIRCppAtomicDialect
  MLIRArmAtomicDialect
  MLIRCIR
)
