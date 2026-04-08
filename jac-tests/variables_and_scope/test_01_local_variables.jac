# Test 01: Local Variables (Definition and Shadowing)

def example() {
    # 1. Definition Collision: Redefining x with different type (Explicit)
    x: int = 5;
    # x: str = "hello"; # Error: Redefinition in same scope

    # 2. Use-Before-Def
    # print(y); # Error: y is not defined yet
    y = 10;
    print(y);

    # 3. Type inference (Sticky?)
    z = 100;
    z = "string"; # Does this fail during 'jac check'?
    print(z);
}

with entry {
    example();
}
