# Test 02c: Pattern Matching (Object Attributes)

obj User { 
    has name: str;
    has age: int; 
}

def test_match(value: any) {
    match value {
        # ✖ ERROR: User has fields 'name' and 'age', not 'n' and 'a'.
        # Checking if this causes a clean type error or a panic.
        case User(n=name, a=age):
            print(f"User: {name}, {age}");
        case _:
            print("Default");
    }
}

with entry {
    test_match(User(name="Alice", age=30));
}
