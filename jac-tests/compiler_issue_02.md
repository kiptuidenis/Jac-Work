# Jac Compiler Diagnostic Issue: `jac run` vs `jac check` Discrepancy

## Issue Description
When executing a Jac program using `jac`, the compiler dynamically executes the code without enforcing the static type annotations. A user can assign a string to a variable explicitly typed as an integer (`x: int = "string"`) and `jac` will execute it successfully without any warnings or output. 

Developers must know to run the separate `jac check` command to receive type-level diagnostics (e.g., error[E1001]).

## Reproduction
**File:** `test_types.jac`
```jac
with entry {
    x: int = "This is a string";
    print(x);
}
```

**Commands:**
```bash
jac test_types.jac
# Output: "This is a string" (Exits with 0)

jac check test_types.jac
# Output: [ERROR] Error: error[E1001]: Cannot assign Literal["..."] to int
```

## Why it is Confusing
Jac is advertised as a statically typed language where "all variables, fields, and function signatures require type annotations. This enables better tooling, clearer APIs, and catches errors at compile time rather than runtime." 

If `jac run` serves as the primary gateway for developers (running the JIT/interpreter), new users will assume type errors will block execution or throw errors during compilation. They may write fundamentally type-insecure code without realizing they need to hook `jac check` into their build pipelines to enforce the type system.

## Expected Behavior
`jac run` should either enforce type checking by default (and provide a `--no-check` flag for raw execution speed) or emit a conspicuous warning when type violations are present.

## Severity Level
**High**
- **Impact:** Can lead to a false sense of security regarding type constraints. Developers may push code assuming it's type-safe when it hasn't actually been validated.
