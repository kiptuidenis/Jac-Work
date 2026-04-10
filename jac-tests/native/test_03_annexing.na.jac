# test_03_annexing.na.jac
# Native Codespace

# Import the ability from the Python side (documented at line 5654)
import from ... test_03_annexing {
    def python_compute(x: int) -> int;
}

def native_compute(x: int) -> int {
    # Call the Python function from Native
    res = python_compute(x);
    return res + 1;
}

with entry {
    print("Native entry.");
}
