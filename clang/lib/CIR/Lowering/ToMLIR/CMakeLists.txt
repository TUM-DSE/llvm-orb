set(LLVM_LINK_COMPONENTS
  Core
  Support
  )

get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)

add_clang_library(clangCIRLoweringToMLIR
  CIRToCF.cpp
  CIRToCppAtomic.cpp
  CIRToPtr.cpp

  DEPENDS
  CIRLowering
  MLIRCIREnumsGen
  MLIRCIROpsIncGen
  MLIRCIROpInterfacesIncGen

  LINK_LIBS PRIVATE
  clangCIRLoweringCommon
  ${dialect_libs}
  MLIRCIR
  MLIRCIRTargetLowering
  MLIRIR
  )

  target_include_directories(clangCIRLoweringToMLIR PRIVATE
  ${CLANG_SOURCE_DIR}/lib/CIR/Dialect/Transforms/TargetLowering
  ${CLANG_SOURCE_DIR}/lib/CIR/Dialect/Transforms
  )
