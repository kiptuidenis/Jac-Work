def example() {
    # Basic by expression
    result = "hello" by "world";
    print(result);

    # Chained by expressions (right-associative)
    result = "a" by "b" by "c";  # Parsed as: "a" by ("b" by "c")
    print(result);

    # With expressions
    result = (1 + 2) by (3 * 4);
    print(result);
}

with entry {
    example();
}