# Type Checker Feedback: Missing Unreachable Code Detection for exception Handlers

**Jac Version:** 0.13.5

## 1. What I expected the type checker to do
When a specific exception handler (e.g., `except ZeroDivisionError`) is placed after a generic handler (e.g., `except Exception`), I expected the type checker to flag the specific handler as unreachable code.

## 2. What it actually did
The type checker warns about the "overly broad" exception (W2052), but remains silent about the fact that the subsequent handler will never be executed.

**Actual Behavior (Partial Warning Only):**
> `⚠ warning[W2052]: Catching overly broad exception type 'Exception' — catch a more specific exception`
> *(No warning for the unreachable ZeroDivisionError block)*

## 3. Minimal code that reproduces it
```jac
try {
    x = 1 / 0;
} except Exception {
    print("Caught broad");
} except ZeroDivisionError {
    # This block is dead code but generates no warning
    print("Caught specific");
}
```
