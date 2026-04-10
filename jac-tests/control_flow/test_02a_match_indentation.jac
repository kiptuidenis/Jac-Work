# Test 02a: Pattern Matching (Indentation)

def test_match(value: any) {
    match value {
        case 1: {
            # ✖ ERROR: Braces are NOT allowed in match/case bodies.
            # This triggers a parser panic.
            print("One"); 
        }
        case 2:
            print("Two");
    }
}

with entry {
    test_match(1);
}
