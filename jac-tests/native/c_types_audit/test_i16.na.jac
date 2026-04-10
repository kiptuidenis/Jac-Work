# test_i16.na.jac
# Testing Signed 16-bit Integer (-32768 to 32767)

with entry {
    x: i16 = 32000;
    #x = x + (1000:i16); 
    
    print("i16 Result ", x);
}
