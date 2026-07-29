//===-- ArmAtomicOps.td - Arm Atomic dialect op definitions -*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the basic operations for the Arm Atomic dialect.
//
//===----------------------------------------------------------------------===//

#ifndef ARMATOMIC_OPS
#define ARMATOMIC_OPS

include "mlir/Dialect/LLVMIR/LLVMOpBase.td"
include "mlir/IR/OpBase.td"
include "mlir/IR/EnumAttr.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

// Type predicate for !ptr.ptr<space> (from the MLIR ptr dialect)
def ArmAtomic_AnyPtrType : Type<
    CPred<"::mlir::isa<::mlir::ptr::PtrType>($_self)">,
    "ptr.ptr type">;

//===----------------------------------------------------------------------===//
// ArmAtomic dialect definition
//===----------------------------------------------------------------------===//

def ArmAtomic_Dialect : Dialect {
  let name = "arm_atomic";
  let cppNamespace = "::mlir::arm_atomic";

  // Note: this does not need to depend on LLVMDialect as long as functions in
  // this dialect (such as canonicalization) do not produce entities belonging
  // to the LLVMDialect (ops or types).
}

//===----------------------------------------------------------------------===//
// ArmAtomic Enum definition
//===----------------------------------------------------------------------===//

def ArmMemoryOrderRelaxed   : I32EnumAttrCase<"Relaxed", 0, "relaxed">;
def ArmMemoryOrderAcquirePC : I32EnumAttrCase<"AcquirePC", 1, "acquirePC">;
def ArmMemoryOrderAcquire   : I32EnumAttrCase<"Acquire", 2, "acquire">;
def ArmMemoryOrderRelease   : I32EnumAttrCase<"Release", 3, "release">;
def ArmMemoryOrderAcqRel    : I32EnumAttrCase<"AcqRel",  4, "acq_rel">;

def ArmMemoryOrder : I32EnumAttr<
    "MemoryOrder", "ARM memory ordering for atomic operations", [
      ArmMemoryOrderRelaxed,
      ArmMemoryOrderAcquirePC,
      ArmMemoryOrderAcquire,
      ArmMemoryOrderRelease,
      ArmMemoryOrderAcqRel
    ]> {
  let cppNamespace = "::mlir::arm_atomic";
}

def ArmMemoryOrderAttr : EnumAttr<ArmAtomic_Dialect, ArmMemoryOrder, "memory_order">;

//===----------------------------------------------------------------------===//
// ArmAtomic type definition
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// ArmAtomic op definitions
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// AtomicLoadOp
//===----------------------------------------------------------------------===//

def AtomicLoadOp : Op<ArmAtomic_Dialect, "atomic_load",
    [DeclareOpInterfaceMethods<MemoryEffectsOpInterface>]> {
  let summary = "ARM atomic load operation (LDR/LDAR)";

  let arguments = (ins
    ArmAtomic_AnyPtrType:$addr,
    ArmMemoryOrderAttr:$memory_order,
    OptionalAttr<I64Attr>:$alignment
  );

  let results = (outs AnyType:$result);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "::mlir::Type":$resultType,
                   "Value":$addr,
                   "::mlir::arm_atomic::MemoryOrder":$memory_order,
                   CArg<"::mlir::IntegerAttr", "nullptr">:$alignment), [{
      $_state.addTypes(resultType);
      $_state.addOperands(addr);
      auto orderAttr = ::mlir::arm_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);
      if (alignment)
        $_state.addAttribute("alignment", alignment);
    }]>
  ];

  let assemblyFormat = [{
    $addr `memory_order` `(` $memory_order `)` (`align` `(` $alignment^ `)`)?
    attr-dict `:` type($addr) `->` type($result)
  }];
}

//===----------------------------------------------------------------------===//
// AtomicStoreOp
//===----------------------------------------------------------------------===//

def AtomicStoreOp : Op<ArmAtomic_Dialect, "atomic_store",
    [DeclareOpInterfaceMethods<MemoryEffectsOpInterface>]> {
  let summary = "ARM atomic store operation (STR/STLR)";

  let arguments = (ins AnyType:$value,
                       ArmAtomic_AnyPtrType:$addr,
                       ArmMemoryOrderAttr:$memory_order,
                       OptionalAttr<I64Attr>:$alignment
  );

  let results = (outs);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "Value":$value,
                   "Value":$addr,
                   "::mlir::arm_atomic::MemoryOrder":$memory_order,
                   CArg<"::mlir::IntegerAttr", "nullptr">:$alignment), [{
      $_state.addOperands(value);
      $_state.addOperands(addr);
      auto orderAttr = ::mlir::arm_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);
      if (alignment)
        $_state.addAttribute("alignment", alignment);
    }]>
  ];

  let assemblyFormat = [{
    $value `,` $addr `memory_order` `(` $memory_order `)` (`align` `(` $alignment^ `)`)?
    attr-dict `:` type($value) `,` type($addr)
  }];
}

//===----------------------------------------------------------------------===//
// AtomicFenceOp
//===----------------------------------------------------------------------===//

def AtomicFenceOp : Op<ArmAtomic_Dialect, "atomic_fence",
    [DeclareOpInterfaceMethods<MemoryEffectsOpInterface>]> {
  let summary = "ARM atomic fence operation (DMB)";

  let description = [{
    Represents an ARM atomic fence. It establishes memory synchronization 
    ordering without an associated atomic variable.
  }];

  let arguments = (ins ArmMemoryOrderAttr:$memory_order,
                       OptionalAttr<StrAttr>:$syncscope);
  let results = (outs);

  let skipDefaultBuilders = 1;

  let builders = [
    OpBuilder<(ins "::mlir::arm_atomic::MemoryOrder":$memory_order,
                   "::mlir::StringAttr":$syncscope), [{
      auto orderAttr = ::mlir::arm_atomic::MemoryOrderAttr::get(
          $_builder.getContext(), memory_order);
      $_state.addAttribute("memory_order", orderAttr);
      if (syncscope)
        $_state.addAttribute("syncscope", syncscope);
    }]>
  ];

  let assemblyFormat = [{
    `memory_order` `(` $memory_order `)` (`syncscope` `(` $syncscope^ `)`)? attr-dict
  }];
}

#endif // ARMATOMIC_OPS
