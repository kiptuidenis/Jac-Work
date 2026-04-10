# Test 01: C-Type Strictness and Precision

with entry {
    # 1. i8 Overflow (Signed 8-bit: -128 to 127)
    has x: i8 = 100;
    x = x + 20; # Should overflow to -126 (wrap-around) or throw a type error
    print("Result: ", x);

}
