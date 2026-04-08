# Test 09: Shadow Contexts in Filters

obj User {
    has name: str;
    has age: int;
}

def example() {
    users = [User(name="Alice", age=25), User(name="Bob", age=30)];
    
    # 1. Attribute filter (OK)
    res = users[? age > 26]; # Should be [Bob]
    print(f"age > 26: {res}");

    # 2. Primitive List (Broken)
    ints = [1, 2, 3];
    # res = ints[? it > 1]; # Error: 'int' has no it
    # res = ints[? _ > 1]; # Error: 'int' has no _
}

with entry {
    example();
}
