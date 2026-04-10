# test_u8.na.jac
# Testing Unsigned 8-bit Integer (0 to 255)

with entry {
    x: u8 = 250;
    
    # Testing wrap-around
    #x = x + (10:u8); 
    
    print("u8 Result: ", x);
}
