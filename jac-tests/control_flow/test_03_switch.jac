# Test 03: Switch Statement

def test_switch(val: int) {
    switch val {
        case 1:
            print("One");
            # Fall through
        case 2:
            print("Two");
            break;
        case 3:
            print("Three");
        default:
            print("Other");
    }
}

with entry {
    test_switch(1);
    test_switch(4);
}
