# Jac Compiler Diagnostic: OSP Parser Panic (Graph Operations)

## Issue Description
When a complex, multi-token spatial operator (Object-Spatial Programming) is malformed—specifically "Typed Connections" or "Filtered Traversals"—the Jac parser fails to recognize the pattern mismatch. Instead of reporting a missing operator, the parser "panics," loses its place in the grammar, and generates a cascade of unrelated follow-up errors.

## Reproduction
**File:** `operators/test_07_parser_panics.jac`
```jac
node Person { has name: str; }
edge Friend { has since: int = 2020; }

with entry {
    n1 = Person(name="Alice");
    n2 = Person(name="Bob");

    # MALFORMED: Missing second '+>' 
    # Documented Syntax: n1 +> :Friend: +> n2;
    n1 +> :Friend: n2; 
}
```

## The Diagnostic Findings (Error Cascade)
The compiler generates **5 separate errors** for this single missing operator:
1. `error[E0004]: Unexpected token in expression: '>'`
2. `error[E0002]: Missing ';'` (Triggered at the colon `:`)
3. `error[E0004]: Unexpected token in expression: ':'`
4. `error[E0002]: Missing ';'` (Triggered at the end of the line)
5. `error[E2008]: Invalid target for context update: BinaryExpr`

## Analysis
- **Parser Recovery Debt:** The parser attempts to treat `:Friend:` and `n2` as separate statements rather than parts of a fractured graph connection.
- **The E2008 Outlier:** The final error `Invalid target for context update` indicates that the internal AST was partially constructed for a context-update operation but the binary expression `n1 +> :Friend:` was found to be an invalid target for that state.

## Significance
**Moderate (Developer Experience)**
- **Impact:** Beginners attempting graph operations will be overwhelmed by technical "Missing Semicolon" errors when the actual issue is a missing spatial token.
- **Root Cause:** The parser's lookahead/recovery logic does not have a "Typed Connection" recovery path.

## Recommendation
Enhance the Jac parser to recognize a dangling `:TypeName:` sequence following a `+>` or `->` operator and provide a target suggestion:
> *Hint: Did you forget the second operator in your typed connection? (e.g., `+> :Type: +>`)?*
