# Bug Report: Silent Data Corruption in Native Type Mapping

**Jac Version:** 0.13.5

## 1. What I expected the compiler to do
When importing C functions, the compiler should ideally perform a basic check (using available debug symbols or C-ABI metadata) to ensure the Jac signature matches the C signature. At minimum, the `jac` command should warn about precision risks when mapping f64 returns to i32.

## 2. What it actually did
The compiler allows any type mapping between Jac and C libraries. If the mapping is incorrect (e.g., mapping `double sqrt(double)` to `i32 sqrt(i32)`), the program executes without warning but produces garbage data or "ghost outputs" (zero/empty values).

**Actual Behavior:**
> `sqrt(16) mapped to i32 = ` (Empty result due to register mismatch and JIT bridge error)

## 3. Minimal code that reproduces it
```jac
import from "libm" {
    # Mismatch: sqrt in libm expects 64-bit floats
    def sqrt(x: i32) -> i32;
}

with entry {
    res = sqrt(16);
    print(res);
}
```

---

**Classification: `#bug-and-issues` 🐛**
This is a stability and reliability issue. Type-safety in native interop is critical to prevent hard-to-debug logic errors.
