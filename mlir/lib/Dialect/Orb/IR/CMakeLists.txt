add_mlir_dialect_library(MLIRArmAtomicDialect
  PARTIAL_SOURCES_INTENDED

  ArmAtomicDialect.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Orb

  DEPENDS
  MLIRArmAtomicIncGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRSideEffectInterfaces
  )

add_mlir_dialect_library(MLIRCppAtomicDialect
  CppAtomicDialect.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Orb

  DEPENDS
  MLIRCppAtomicIncGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRSideEffectInterfaces
  )
