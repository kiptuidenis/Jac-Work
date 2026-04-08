# Test 04: Scope Rules (LEGB and Block Leakage)

# 1. Nonlocal Abuse: Using nonlocal in top-level scope (no parent)
# def outer() {
#     x = 10;
#     def inner() {
#         nonlocal x; # Correct
#         x += 1;
#     }
# }

def top_level() {
    # nonlocal x; # Error: There is no enclosing scope
    x = 10;
    print(x);
}

def block_leak() {
    # 2. Block Leak: Accessing a variable from an un-executed branch
    if False {
        y = 42;
    }
    # print(y); # Error: y was never assigned
    
    # 3. Loop Leak: Iterator variable after a for loop
    for i in range(3) {
        val = i;
    }
    print(f"Iterator index is: {i}"); # Should be accessible in Jac
    print(f"Final value was: {val}"); # Should be accessible in Jac
}

with entry {
    # top_level();
    block_leak();
}
