set(LLVM_TARGET_DEFINITIONS CppAtomicTransformOps.td)
mlir_tablegen(CppAtomicTransformOps.h.inc -gen-op-decls)
mlir_tablegen(CppAtomicTransformOps.cpp.inc -gen-op-defs)
add_mlir_dialect_tablegen_target(MLIRCppAtomicTransformOpsIncGen)

add_mlir_doc(CppAtomicTransformOps CppAtomicTransformOps Dialects/ -gen-op-doc -dialect=transform)
