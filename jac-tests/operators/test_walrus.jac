def example() {
    items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

    # In conditionals - assign and test
    if (n := len(items)) > 10 {
        print(f"List has {n} items, too many!");
    }

    # In comprehensions
    data = [1, 2, 3];
    results = [y for x in data if (y := x * 2) > 2];

    # In function calls
    text = "hello";
    print(f"Length: {(n := len(text))}, doubled: {n * 2}");
}
with entry {
    example();
}