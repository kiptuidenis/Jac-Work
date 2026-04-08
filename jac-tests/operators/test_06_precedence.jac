# Test 06: Operator Precedence and Short-Circuiting (Broken)

def double(x: int) -> int { return x * 2; }

with entry {
    # 1. Short-Circuit Test
    # If False, the second part should NOT run at runtime. 
    # But the compiler check should catch the syntax error first.
    # result = False and (5 +* 10); # Error: Syntax error
    
    # 2. Precedence Trap
    # Pipe (13) vs Addition (14)
    # Documentation says 13 is pipe, 14 is addition. Higher is first.
    # So Addition (14) should happen BEFORE Pipe (13).
    # Expected: result = 5 |> double + 1; 
    # Logic: 5 |> (double + 1) -> should FAIL as double is a function
    
    result = 5 |> double + 1; 
    print(result);
    
    # 3. Logical Mixture
    # or (5) vs and (6)
    result = True or False and False; # True or (False) = True
    print(result);
}
