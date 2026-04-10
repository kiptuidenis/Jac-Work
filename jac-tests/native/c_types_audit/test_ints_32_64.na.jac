# test_ints_32_64.na.jac
# Testing 32-bit and 64-bit Integers

with entry {
    # 32-bit
    x32: i32 = 2147483640;
    #x32 = x32 + (10:i32);
    print("i32 Result ", x32);

    u32_val: u32 = 4294967290;
    #u32_val = u32_val + (10:u32);
    print("u32 Result: ", u32_val);

    # 64-bit
    x64_val: i64 = 9223372036854775800;
    print("i64 Result: ", x64_val);
}
