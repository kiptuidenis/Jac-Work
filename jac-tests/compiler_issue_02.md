# Type Checker Feedback: `jac` run ignores type violations caught by `jac check`

**Jac Version:** 0.13.5

## 1. What I expected the type checker to do
When running a Jac file via the primary CLI (`jac code.jac`), I expected the compiler to perform a type check pass and either block execution or emit warnings if explicit type annotations are violated (e.g., assigning a string to an `int`).

## 2. What it actually did
The default run command skips type validation entirely, executing code with "invisible" type errors. The errors are only visible when manually running a separate `jac check` command.

**Actual Behavior (jac run):**
> Output: `"This is a string"` (Exits 0)

**Error Message (only seen via 'jac check'):**
> `error[E1001]: Cannot assign Literal["..."] to int`

## 3. Minimal code that reproduces it
```jac
with entry {
    # Type checker knows this is wrong, but 'jac' executes it anyway.
    x: int = "This is a string";
    print(x);
}
```

## Significance
This creates a discrepancy where the language's enforced type system is "opt-in" rather than "opt-out," potentially leading developers to bypass safety checks during active development.
