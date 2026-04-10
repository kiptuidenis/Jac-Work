# Type Checker Feedback: Widespread Literal-to-Native Assignment Failure

**Jac Version:** 0.13.5

## 1. What I expected the type checker to do
I expected the Type Checker to permit assigning standard Jac literals (`1.0`, `100`) to native fixed-width types (`f64`, `i8`, `u32`, etc.) when the values are within bounds. This should follow the same implicit promotion/coercion rules that the JIT runtime successfully uses.

## 2. What it actually did
The type checker flags **every** assignment to a native type as a type mismatch error. It treats Pythonic `float` and `int` as strictly incompatible with their native counterparts like `f64` or `i8`.

**Actual Error Messages:**
> `error[E1053]: Cannot assign float to parameter 'x' of type f64`
> `error[E1053]: Cannot assign int to parameter 'x' of type i8`
> `error[E1053]: Cannot assign int to parameter 'x' of type u32`

## 3. Minimal code that reproduces it
```jac
# reproduce_mismatch.na.jac
with entry {
    # All three of these produce E1053 errors in 'jac check'
    val_f: f64 = 3.14; 
    val_i: i8  = 100;
    val_u: u32 = 500;
}
```

---

**Classification: `#type-checker-feedback` 🛡️**
This makes the Native backend effectively "un-validatable" using the standard `jac check` command, forcing users to ignore type-checker results entirely when working with LLVM-targeted code.
