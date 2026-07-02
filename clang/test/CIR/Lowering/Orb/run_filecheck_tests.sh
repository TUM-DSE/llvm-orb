#!/usr/bin/env bash

# Define colors for pretty output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper function to run a test and report the result
run_test() {
    local description="$1"
    local command="$2"

    echo -e "${BLUE}======================================================================${NC}"
    echo -e "${BLUE}Running Filecheck test for ${description}${NC}"
    
    # Execute the command using eval so the pipe (|) works correctly
    eval "$command"
    
    # Check if the previous command was successful
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Succeeded!${NC}\n"
    else
        echo -e "${RED}❌ Failed! Stopping tests.${NC}\n"
        exit 1
    fi
}

echo "Starting MLIR Test Pipeline..."
echo ""

run_test "Phase 1, going from CIR to CppAtomic" \
    "./../../../../../build/bin/cir-opt test_cir_to_cpp_atomic.mlir --cir-to-cpp-atomic | ./../../../../../build/bin/FileCheck test_cir_to_cpp_atomic.mlir"

run_test "Phase 2, going from CppAtomic to ArmAtomic" \
    "./../../../../../build/bin/cir-opt test_cpp_atomic_to_arm_atomic.mlir --cpp-atomic-to-arm-atomic | ./../../../../../build/bin/FileCheck test_cpp_atomic_to_arm_atomic.mlir"

run_test "Phase 3, going from CIR to ArmAtomic" \
    "./../../../../../build/bin/cir-opt test_cir_to_arm_atomic.mlir --cir-to-cpp-atomic --cpp-atomic-to-arm-atomic | ./../../../../../build/bin/FileCheck test_cir_to_arm_atomic.mlir"

run_test "Phase 4, going from ArmAtomic to LLVM" \
    "./../../../../../build/bin/cir-opt test_arm_atomic_to_llvm.mlir --arm-atomic-to-llvm | ./../../../../../build/bin/FileCheck test_arm_atomic_to_llvm.mlir"

run_test "Phase 5, going from CppAtomic to LLVM" \
    "./../../../../../build/bin/cir-opt test_cpp_atomic_to_llvm.mlir --cpp-atomic-to-arm-atomic --arm-atomic-to-llvm | ./../../../../../build/bin/FileCheck test_cpp_atomic_to_llvm.mlir"

run_test "Phase 6, going from CIR to LLVM" \
    "./../../../../../build/bin/cir-opt test_cir_to_llvm.mlir --cir-to-cpp-atomic --cpp-atomic-to-arm-atomic --arm-atomic-to-llvm | ./../../../../../build/bin/FileCheck test_cir_to_llvm.mlir"

run_test "Phase 7, Direct CIR to LLVMIR" \
    "./../../../../../build/bin/cir-translate test_direct_cir_to_llvmir.mlir -cir-to-llvmir --target x86_64-unknown-linux-gnu --disable-cc-lowering | ./../../../../../build/bin/FileCheck test_direct_cir_to_llvmir.mlir"

echo -e "All tests passed successfully!"