# Bug Report: Native Linker Memory Corruption (Segfault)

**Jac Version:** 0.13.5

## 1. What I expected the compiler to do
I expected the `jac` command to validate that all native library imports (`import from "libname"`) and their associated symbols are resolvable before attempting execution. If a library or function is missing, it should emit a clear diagnostic error (e.g., "Library not found").

## 2. What it actually did
The runtime performs unvalidated lazy linkage. It allows the program to start even if the target library is missing. When the unresolved symbol is invoked, the process crashes with a **Segmentation Fault** instead of a Jac-level error.

**Actual Behavior:**
> `Segmentation fault (core dumped)`
> `Exit code: 139`

## 3. Minimal code that reproduces it
```jac
import from "non_existent_lib" {
    def missing_func() -> i32;
}

with entry {
    # System segfaults here instead of throwing a LinkError
    res = missing_func(); 
}
```

---

**Classification: `#bug-and-issues` 🐛**
This is a critical security and stability issue, as it allows invalid memory access through the native interop layer.
