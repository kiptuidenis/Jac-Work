# Bug Report: Widespread Native Value Erasure (Ghost Output)

**Jac Version:** 0.13.5

## 1. What I expected the compiler to do
I expected the `jac` command to correctly bridge all documented C-types to the Python runtime for printing and string interpolation.

## 2. What it actually did
During native execution, almost all fixed-width types are "invisible" to the output layer. The program logic executes, but the actual values are erased when passed to any Python-side function (like `print`).

**Verified "Invincible" Types:**
-   **Floating Point**: `f32`
-   **Signed Integers**: `i8`, `i16`, `i32`
-   **Unsigned Integers**: `u8`, `u16`, `u32`

**Working Types (Base 64-bit)**:
-   `f64` (double)
-   `i64` (long)

**Actual Behavior:**
> `i8 Result: ` (Empty)
> `f32 Result: ` (Empty)
> `f64 Result: 3.1415...` (Working)

## 3. Lack of Manual Casting Syntax
The documentation fails to provide a working syntax for manual casting between native types. Implicit promotion currently causes internal LLVM panics (Issue 19), and explicit cast attempts (e.g., `(val:type)`) are rejected by the parser.

## 4. Minimal Code for Repro
```jac
# test.na.jac
with entry {
    x: i8 = 100;
    y: i8 = 20;
    x = x + y;
    print("Result: ", x); # Prints empty value
}
```

---

**Classification: `#bug-and-issues` 🐛**
The combination of widespread variable erasure and the lack of a working casting syntax makes the native backend's fixed-width types currently unusable for development.
