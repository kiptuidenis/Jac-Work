# Test 03: Generic Types (Placeholder/Coming Soon)

# 1. Syntax Break: Trying to use [T] generic syntax on function
# Documentation says: def first[T](items: list[T]) (Coming soon)
def first[T](items: list[T]) -> T {
    return items[0];
}

# 2. Constraint Break: Providing incorrect number of type arguments to dict
# dict expects [Key, Value]
has mapping: dict[int] = {};

with entry {
    res = first([1, 2, 3]);
}
