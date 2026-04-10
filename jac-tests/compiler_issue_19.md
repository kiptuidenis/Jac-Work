# Bug Report: Native Arithmetic Panic (LLVM IR Type Mismatch)

**Jac Version:** 0.13.5

## 1. What I expected the compiler to do
I expected the compiler to handle arithmetic between mixed fixed-width types (e.g., `i8 + int`) by either performing implicit promotion (widening the `i8`) or narrowing the literal if it fits. At the very least, it should throw a clean Jac error.

## 2. What it actually did
The Native compiler pass fails to unify types before generating LLVM IR. It passes mismatched bit-widths to the LLVM builder, causing an internal `llvmlite` TypeError that crashes the compiler.

**Actual Behavior:**
> `✖ Error: Error: Type of #1 arg mismatch: i64 != i8`
> (Followed by a compiler stack trace)

## 3. Minimal code that reproduces it
```jac
# test.na.jac
with entry {
    x: i8 = 100;
    # Fails because 20 is i64 and x is i8
    x = x + 20; 
}
```

---

**Classification: `#bug-and-issues` 🐛**
This is a critical failure in the Native backend's type-lowering logic. It forces users to perform extremely verbose manual casting for even the simplest arithmetic operations.
