add_subdirectory(TargetLowering)

add_clang_library(MLIRCIRTransforms
  CallConvLoweringPass.cpp
  CIRCanonicalize.cpp
  CIRSimplify.cpp
  CIRToPtr.cpp
  CIRTransformUtils.cpp
  CXXABILowering.cpp
  EHABILowering.cpp
  TargetLowering.cpp
  CIRToCF.cpp
  CIRToCppAtomic.cpp
  FlattenCFG.cpp
  HoistAllocas.cpp
  LoweringPrepare.cpp
  GotoSolver.cpp
  IdiomRecognizer.cpp

  DEPENDS
  MLIRCIRPassIncGen

  LINK_LIBS PUBLIC
  clangAST
  clangBasic

  MLIRABI
  MLIRAnalysis
  MLIRDLTIDialect
  MLIRIR
  MLIRPass
  MLIRTransformUtils

  MLIRCIR
  MLIRCIRInterfaces
  MLIRCIRTargetLowering
  MLIRPtrDialect
  MLIROpenMPDialect
  MLIRSCFDialect
  MLIROpenACCDialect

  MLIRCppAtomicDialect
)
