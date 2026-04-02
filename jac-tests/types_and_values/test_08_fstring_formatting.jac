# Test 08: F-String Format Specifications (Nesting and Invalid Specs)

with entry {
    # 1. Spec Break: Invalid precision for integers
    # Documentation says: {expression:format_spec}
    # n = 42;
    # print(f"{n:.2f}"); # Error: int is not float
    
    # 2. Nesting Break: Intentionally unclosed nested expressions
    # This is a classic parser stress test
    # width = 10;
    # pi = 3.14159;
    # print(f"{pi:{width}}"); # Correct
    # print(f"{pi:{width"); # Error: missing closing brace
    
    # 3. Invalid fill/align combinations
    # print(f"{'test':*^10*}"); # Error: too many specifiers
}
