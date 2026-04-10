# test_u16.na.jac
# Testing Unsigned 16-bit Integer (0 to 65535)

with entry {
    x: u16 = 65000;
    #x = x + (1000:u16); 
    
    print("u16 Result:", x);
}
