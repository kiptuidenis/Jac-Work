# Test 01: Builtin Types and Malformed Literals

with entry {
    # 1. Malformed literals
    # hex_error = 0xG1; 
    # bin_error = 0b2;
    # oct_error = 0o8;
    
    # 2. Invalid underscore placement
    # under_error1 = 123__456;
    # under_error2 = _100;

    # 3. Type violation (Assignment of wrong type)
    x: int = "This is a string";
    print(x);

    # 4. Native types in standard jac (Should fail or warn)
    y: i8 = 127;
    z: u32 = 4000000;
}
