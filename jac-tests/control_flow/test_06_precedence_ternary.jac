# Test 06: Precedence and Ternary Logic

with entry {
    # 1. Complex nested ternary
    # result = "a" if True else "b" if False else "c"; # Should be "a"
    a = 1;
    b = 2;
    res = a if a > b else b if b > a else 0;
    print(res);
    
    # 2. Mixing with logical operators
    # result = True and "yes" if True else "no"; # "yes"
}
