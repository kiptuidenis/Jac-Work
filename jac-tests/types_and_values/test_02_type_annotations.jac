# Test 02: Type Annotations and Mandatory Fields

obj Person {
    # 1. Mandatory Violation: Declaring field without type annotation
    # Documentation says: all variables, fields, and function signatures require type annotations.
    # has name; # Uncomment to test
    
    # 2. Mandatory Violation (Partial): Using any where specific was expected?
    # No, 'any' is valid. Let's try malformed annotation logic.
    has data: list[int] | ; # Incomplete union
}

def greet(name: str) {
    # 3. Signature Violation: Missing return type annotation for function
    print(f"Hello, {name}");
}

with entry {
    greet("World");
}
