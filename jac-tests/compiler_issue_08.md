# Jac Compiler Diagnostic: Match/Case Parser Panic (Indentation Rule)

## Issue Description
Jac documentation specifies that `match/case` blocks are the only place where Python-style indentation is mandatory and braces `{ }` are forbidden for case bodies. However, if a developer mistakenly uses braces, the parser fails to provide a clear error message. Instead, it "panics" and generates a cascade of unrelated syntax errors.

## Classification: #bug-and-issues 🐛
This is a **Parser Recovery Bug**. The compiler should explicitly recognize the use of braces in a `match` context and report the indentation requirement clearly.

## Reproduction
**File:** `control_flow/test_02a_match_indentation.jac`
```jac
def test_match(value: any) {
    match value {
        case 1: {
            # ✖ ERROR: Braces are forbidden here.
            print("One"); 
        }
    }
}
```

## The Diagnostic Findings (Error Cascade)
The compiler generates a confusing list of errors:
1. `error[E0002]: Missing '}'` (Incorrectly claiming the closing brace of the case body is missing).
2. `error[E0032]: Unexpected 'case' -- must follow its parent statement` (Triggered by the next case or the end of the block).
3. `error[E0001]: Expected 'else', got ':'` (The parser attempts to treat the broken match as an `if` statement).

## Analysis
- **Root Cause:** The grammar for `match` cases expects a colon followed by an indented block. When it hits a `{`, it attempts to reconcile the line as a statement and fails to recover the `match` context.
- **User Impact:** Beginners coming from other brace-based languages (or Jac's own `if`/`while` blocks) will find these "Missing Semicolon" or "Expected Else" errors impossible to correlate to a simple brace violation.

## Recommendation
Implement a specific parser rule that catches `{` immediately after a `case ... :` and suggests: 
> *Hint: Match bodies must use indentation, not braces. See Foundation Part 4, Section 4.*
