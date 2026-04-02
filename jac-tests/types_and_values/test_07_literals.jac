# Test 07: Literals (Strings & Collections)

def example() {
    # 1. String Break: Mismatched quotes elsewhere in the file
    # s1 = "hello';
    # s2 = 'world";
    
    # 2. String Break: Invalid escape sequence in raw string?
    # No, raw strings are for that.
    
    # 3. Collection Break: Malformed literals
    # sets with mutable elements?
    # s3 = {[1, 2], [3, 4]}; # Error: list is mutable, not hashable (Python legacy)
    
    # 4. Collection Break: Missing commas
    # l1 = [1 2 3]; # Error: missing commas
}

with entry {
    example();
}
