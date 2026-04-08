# Jac Compiler Diagnostic: The Pipe Precedence Trap

## Issue Description
Jac's pipe operator (`|>`) has a counter-intuitive precedence level that differs from most functional-style languages (like Elixir or F#). In Jac, Addition (`+`) and Multiplication (`*`) have **higher** precedence than Piping.

## Reproduction
**File:** `operators/test_06_precedence.jac`
```jac
def double(x: int) -> int { return x * 2; }

with entry {
    # Expected: (5 |> double) + 1 = 11
    # Actual Parser Behavior: 5 |> (double + 1)
    result = 5 |> double + 1; 
}
```

## The Diagnostic Finding (Runtime Error)
```
Error: unsupported operand type(s) for +: 'function' and 'int'
```
This confirms that the compiler attempted to evaluate `double + 1` before performing the pipe operation.

## Why it is confusing
According to the **Jac Foundation Documentation (Part 3, Section 10)**:
- **Precedence Level 13**: `|>` (Forward Pipe)
- **Precedence Level 14**: `+`, `-` (Addition/Subtraction)
- **Precedence Level 15**: `*`, `/`, `%` (Multiplication/Division)

While the behavior is "correct" according to the documented table, it is highly unconventional for a functional operator. Developers typically expect a pipe to "catch" the result of the entire expression to its left.

## Recommendation
Developers MUST use parentheses when mixing pipes with arithmetic operators if they intend to pipe the arithmetic result, or vice versa.
```jac
# Correct way to pipe result to arithmetic
(5 |> double) + 1; # 11

# Correct way to pipe arithmetic to function
(5 + 1) |> double; # 12
```

## Severity Level
**Low (User Experience)**
- **Impact:** Leads to confusing "Function + Int" errors rather than logical calculation results.
- **Fix:** Either adjust the precedence table in the language spec or add a specific lint warning for unparenthesized pipes mixed with arithmetic.
