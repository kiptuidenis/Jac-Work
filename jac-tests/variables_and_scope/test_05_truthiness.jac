# Test 05: Truthiness (Falsy checks and identity comparisons)

def test_truthiness() {
    empty_list = [];
    
    # 1. Identity Fallacy: comparing [] to False using 'is'
    if empty_list is False {
        print("Empty list is False? (unexpected)");
    } else {
        print("Empty list is NOT False (expected identity-wise)");
    }
    
    # 2. Value Comparison
    if empty_list == False {
         print("Empty list == False? (unexpected)");
    }

    # 3. Functional truthiness
    if not empty_list {
        print("Empty list is falsy (expected)");
    }
}

with entry {
    test_truthiness();
}
