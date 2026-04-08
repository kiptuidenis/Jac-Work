# Test 04: Context Managers & Exceptions (Broken)

with entry {
    # 1. Raising non-Exception derivative
    # raise 5; # This is caught at compile-time/runtime? 
    
    # 2. Try with unreachable except
    try {
        x = 1 / 0;
    } except Exception {
        print("Caught everything");
    } except ZeroDivisionError {
        # Error: This is unreachable
        print("Caught zero div");
    }
}
