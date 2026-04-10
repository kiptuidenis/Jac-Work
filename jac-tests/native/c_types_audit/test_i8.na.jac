# test_i8.na.jac
# Testing Signed 8-bit Integer (-128 to 127)

with entry {
    x: i8 = 100;
    y: i8 = 10;
    
    # Testing overflow behavior
    
    x = x + y; 
    print (type(x));
    
    print("i8 Result (Expected -126): ", x);
}
