# Test 02: Null-Safe Operators (Broken)

obj User {
    has profile: Profile | None = None;
}

obj Profile {
    has settings: dict | None = None;
}

with entry {
    # 1. ?. on non-optional type (likely warned or ignored)
    u = User();
    
    # 2. ?. Chaining
    result = u?.profile?.settings; # Should be None
    
    # 3. ?[] Indexing an integer
    x = 5;
    item = x?[0]; # Error: Type mismatch (int is not subscriptable)
    
    # 4. ? in filter comprehensions
    items = [1, -5, 10];
    results = items[? value > 0]; # Error: 'int' has no field 'value'
}
