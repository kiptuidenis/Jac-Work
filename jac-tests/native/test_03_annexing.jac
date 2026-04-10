# test_03_annexing.jac
# Python/Server Codespace

sv {
    def python_compute(x: int) -> int {
        return x * 10;
    }
}

with entry {
    # Call a native function defined in the sibling .na.jac
    # res = native_compute(5);
    # print(f"Native compute result: {res}");
    print("Python main entry.");
}
