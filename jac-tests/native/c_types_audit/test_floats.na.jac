# test_floats.na.jac
# Testing Floating Point Types f32 and f64

with entry {
    # 64-bit float (Double) - Bridges correctly to Python float
    f64_val: f64 = 3.141592653589793;
    print("f64 (Double) Result: ", f64_val);
    print(type(f64_val));

    # 32-bit float (Single) - This might fail to print due to Issue 13
    f32_val: f32 = 3.14159;
    print("f32 (Single) Result: ", f32_val);
    print(type(f32_val));
}
