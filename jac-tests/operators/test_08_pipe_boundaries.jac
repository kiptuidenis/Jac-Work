# Test 08: Pipe Boundary Priority

def double(x: int) -> int { return x * 2; }
def to_str(x: any) -> str { return f"{x}"; }

with entry {
    # 1. Pipe (13) vs Addition (14)
    # 5 |> double + 1 
    # Documented result: 5 |> (double + 1) -> ERROR
    # Expected result for most functionalists: (5 |> double) + 1 = 11
    try {
        result = 5 |> double + 1;
        print(f"5 |> double + 1 = {result}");
    } except Exception as e {
        print(f"5 |> double + 1 failed: {e}");
    }

    # 2. Multiplication (15) vs Pipe (13)
    # 10 * 2 |> double
    # Should be (10 * 2) |> double = 40
    try {
        result = 10 * 2 |> double;
        print(f"10 * 2 |> double = {result}");
    } except Exception as e {
        print(f"10 * 2 |> double failed: {e}");
    }

    # 3. Logical OR (5) vs Pipe (13)
    # True or False |> to_str
    # Should be True or (False |> to_str) = True or "False" = True
    try {
        result = True or False |> to_str;
        print(f"True or False |> to_str = {result}");
    } except Exception as e {
        print(f"True or False |> to_str failed: {e}");
    }
}
