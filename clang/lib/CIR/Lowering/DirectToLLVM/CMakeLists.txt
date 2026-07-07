set(LLVM_LINK_COMPONENTS
  Core
  Support
  )

get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)

add_clang_library(clangCIRLoweringDirectToLLVM
  LowerToLLVM.cpp
  LowerToLLVMIR.cpp

  DEPENDS
  CIRLowering
  MLIRCIREnumsGen
  MLIRCIROpsIncGen
  MLIRCIROpInterfacesIncGen

  LINK_LIBS PRIVATE
  clangCIRLoweringCommon
  clangCIRLoweringToMLIR
  ${dialect_libs}
  MLIRCIR
  MLIRCIRTargetLowering
  MLIRCIRTransforms
  MLIRBuiltinToLLVMIRTranslation
  MLIRLLVMToLLVMIRTranslation
  MLIRPtrToLLVMIRTranslation
  MLIROpenMPToLLVM
  MLIROpenMPToLLVMIRTranslation
  MLIROpenMPTransforms
  MLIRIR
  MLIRCppAtomicToArmAtomic
  MLIRArmAtomicToLLVM
  MLIRPtrToLLVM
  MLIRUBToLLVM
  )

target_include_directories(clangCIRLoweringDirectToLLVM PRIVATE
  ${CLANG_SOURCE_DIR}/lib/CIR/Dialect/Transforms/TargetLowering
  )
