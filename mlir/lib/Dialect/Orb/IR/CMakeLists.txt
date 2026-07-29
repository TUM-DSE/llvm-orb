add_mlir_library(MLIROrbAtomicInterface
  PARTIAL_SOURCES_INTENDED

  OrbAtomicInterface.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Orb

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRAnalysis
  PRIVATE
  MLIRPtrDialect
  )

add_mlir_dialect_library(MLIRArmAtomicDialect
  PARTIAL_SOURCES_INTENDED

  ArmAtomicDialect.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Orb

  DEPENDS
  MLIRArmAtomicIncGen
  MLIRArmAtomicEnumsIncGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRBytecodeOpInterface
  MLIROrbAtomicInterface
  PRIVATE
  MLIRPtrDialect
  )

add_mlir_dialect_library(MLIRCppAtomicDialect
  CppAtomicDialect.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Orb

  DEPENDS
  MLIRCppAtomicIncGen
  MLIRCppAtomicEnumsIncGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRBytecodeOpInterface
  MLIROrbAtomicInterface
  PRIVATE
  MLIRPtrDialect
  )
