# Test 02b: Pattern Matching Patterns

def test_match(value: any) {
    match value {
        # 1. Sequence Pattern
        case [x, y]:
            print(f"List pair: {x}, {y}");
        
        # 2. Mapping Pattern
        case {"key": v}:
            print(f"Dict result: {v}");
            
        # 3. Wildcard
        case _:
            print("Default");
    }
}

with entry {
    test_match([10, 20]);
    test_match({"key": "secret"});
}
