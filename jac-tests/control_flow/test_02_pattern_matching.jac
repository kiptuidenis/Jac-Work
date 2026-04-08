# Test 02: Pattern Matching (The Golden Rule of Indentation)

obj Point { has x: int, y: int; }

def test_match(value: any) {
    match value {
        case 0:
            print("Zero"); # OK: Indented body
            
        case 1: {
            print("One"); # Error: Braces are NOT allowed in match/case bodies
        }
        
        # 2. Pattern Shape Misalignment
        case [x, y] if x > 0:
            print(f"Positive pair: {x}, {y}");
            
        case Point(a=x, b=y): # Error: Point has fields x and y, not a and b
            print(f"Point: {x}, {y}");
    }
}

with entry {
    test_match(0);
}
