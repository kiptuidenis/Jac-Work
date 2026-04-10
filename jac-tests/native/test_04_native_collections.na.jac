# Test 04: Native Collections

with entry {
    # 1. Non-literal list initialization (might fail if only literals are supported)
    data = [1, 2, 3];
    mapped = [x * 2 for x in data];
    print(f"Mapped: {mapped}");

    # 2. Dictionary in native
    # has registry: dict[str, int] = {"a": 1, "b": 2}; # Archetype level
    registry = {"a": 1, "b": 2}; # Local
    print(f"Registry: {registry}");

    # 3. Set membership
    unique = {10, 20, 30};
    exists = 10 in unique;
    print(f"10 in {unique}: {exists}");
}
