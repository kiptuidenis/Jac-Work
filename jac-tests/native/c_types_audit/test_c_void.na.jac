# test_c_void.na.jac
# Testing c_void as a return type and parameter

import from "libm" {
    # Some libc functions return void - mapping to c_void
    def some_libc_func(x: f64) -> c_void;
}

def void_test() -> c_void {
    print("Inside void_test function.");
    return;
}

with entry {
    void_test();
    print("Returned from void_test.");
}
