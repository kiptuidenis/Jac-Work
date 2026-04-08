# Jac Language Feature Confirmation: Block/Loop Scope Persistent Visibility

## Context
In many statically typed languages (e.g., C++, Java), variables defined within a block (`if`, `for`, `while`) are only accessible within that block. This is often referred to as "Block Scope."

## The Behavioral Finding (Confirmed Feature)
In Jac, **block-level variables remain visible** in the function scope after the block concludes. This matches Python's scoping rules (LEGB) and is a deliberate design choice documented in the Foundation library.

## Proof from Documentation
The **Jac Foundation Documentation (Variables and Scope > Scope Rules)** explicitly states:
> "block_var is still accessible here in Jac (unlike some languages)"

## Why this is useful
By maintaining visibility of block-level variables, Jac provides:
1.  **Pythonic Flexibility**: Developers can use the results of a loop or a conditional branch without re-declaring variables in the outer scope.
2.  **Reduced Boilerplate**: Eliminates the need for "pre-hoisting" variables before a block.
