set(CLANG_INCLUDE_DIR ${LLVM_MAIN_SRC_DIR}/../clang/include )
set(CLANG_TABLEGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/tools/clang/include)
include_directories(${CLANG_INCLUDE_DIR})
include_directories(${CLANG_TABLEGEN_OUTPUT_DIR})

add_mlir_dialect_library(MLIRCppAtomicTransformOps
  CppAtomicTransformOps.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/Orb/TransformOps

  DEPENDS
  MLIRCppAtomicTransformOpsIncGen

  LINK_LIBS PUBLIC
  MLIRIR
  MLIRCIR
  MLIRLLVMCommonConversion
  MLIRLLVMDialect
  MLIRTransformDialect
  MLIRCppAtomicDialect
  MLIRArmAtomicDialect
  )
