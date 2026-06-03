add_mlir_dialect(CppAtomic cpp_atomic)
add_mlir_doc(CppAtomic CppAtomic Dialects/ -gen-dialect-doc)

add_mlir_dialect(ArmAtomic arm_atomic)
add_mlir_doc(ArmAtomic ArmAtomic Dialects/ -gen-dialect-doc)

set(LLVM_TARGET_DEFINITIONS ArmAtomic.td)
mlir_tablegen(ArmAtomicConversions.inc -gen-llvmir-conversions)
add_mlir_dialect_tablegen_target(MLIRArmAtomicConversionsIncGen)

add_subdirectory(TransformOps)
