# Test 05: Standalone Binaries (nacompile)

# This test will be run with 'jac nacompile'
# Success case: Pure native code
# Failure case: Importing a Python-only module (like os or sys)

# import:py os; # Uncommenting this should break standalone compilation

def compute(x: int) -> int {
    return x + 100;
}

with entry {
    val = compute(5);
    print(f"Native standalone execution: {val}");
}
