# Test 02b: Missing Library Linker Diagnostic

na import from "non_existent_lib" {
    def some_func() -> i32;
}

with entry {
    # This call is expected to trigger a Linker Error
    # Current behavior: Segmentation Fault
    val = some_func(); 
    print(val);
}
