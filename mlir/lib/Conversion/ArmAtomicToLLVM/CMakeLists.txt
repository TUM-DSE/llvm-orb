set(CLANG_INCLUDE_DIR ${LLVM_MAIN_SRC_DIR}/../clang/include)
set(CLANG_TABLEGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/tools/clang/include)
include_directories(${CLANG_INCLUDE_DIR})
include_directories(${CLANG_TABLEGEN_OUTPUT_DIR})

add_mlir_conversion_library(MLIRArmAtomicToLLVM
  ArmAtomicToLLVM.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Conversion/ArmAtomicToLLVM

  DEPENDS
  MLIRConversionPassIncGen
  MLIRArmAtomicIncGen

  LINK_LIBS PUBLIC
  MLIRPass
  MLIRTransforms
  MLIRArmAtomicDialect
  MLIRLLVMCommonConversion
  MLIRLLVMDialect
  MLIRCIR
)
