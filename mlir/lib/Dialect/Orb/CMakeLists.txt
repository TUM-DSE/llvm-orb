set(CLANG_INCLUDE_DIR ${LLVM_MAIN_SRC_DIR}/../clang/include )
set(CLANG_TABLEGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/tools/clang/include)
include_directories(${CLANG_INCLUDE_DIR})
include_directories(${CLANG_TABLEGEN_OUTPUT_DIR})

add_subdirectory(IR)
add_subdirectory(Transforms)
add_subdirectory(TransformOps)
