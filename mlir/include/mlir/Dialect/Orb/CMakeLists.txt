set(CLANG_INCLUDE_DIR ${LLVM_MAIN_SRC_DIR}/../clang/include )
set(CLANG_TABLEGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/tools/clang/include)
include_directories(${CLANG_INCLUDE_DIR})
include_directories(${CLANG_TABLEGEN_OUTPUT_DIR})

set(LLVM_TARGET_DEFINITIONS CppAtomic.td)

mlir_tablegen(CppAtomicEnums.h.inc -gen-enum-decls)
mlir_tablegen(CppAtomicEnums.cpp.inc -gen-enum-defs)

add_mlir_dialect_tablegen_target(MLIRCppAtomicEnumsIncGen)

add_mlir_dialect(CppAtomic cpp_atomic)
add_mlir_doc(CppAtomic CppAtomic Dialects/ -gen-dialect-doc)


set(LLVM_TARGET_DEFINITIONS ArmAtomic.td)

mlir_tablegen(ArmAtomicEnums.h.inc -gen-enum-decls)
mlir_tablegen(ArmAtomicEnums.cpp.inc -gen-enum-defs)

add_mlir_dialect_tablegen_target(MLIRArmAtomicEnumsIncGen)


mlir_tablegen(ArmAtomicConversions.inc -gen-llvmir-conversions)
add_mlir_dialect_tablegen_target(MLIRArmAtomicConversionsIncGen)

add_mlir_dialect(ArmAtomic arm_atomic)
add_mlir_doc(ArmAtomic ArmAtomic Dialects/ -gen-dialect-doc)

add_subdirectory(TransformOps)