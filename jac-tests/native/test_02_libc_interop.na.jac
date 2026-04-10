# Test 02: C-Library Mapping and Linker

import from "libm" {
    # CORRECT: def sqrt(x: f64) -> f64;
    # WRONG: Mapping a floating point function to i32
    def sqrt(x: i32) -> i32;
}


with entry {
    # 1. Calling incorrectly mapped function
    res = sqrt(16);
    print(sqrt(16));
    print(f"sqrt(16) mapped to i32 = {res}");
    
}
