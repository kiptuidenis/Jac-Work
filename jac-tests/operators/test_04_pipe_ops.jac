# Test 04: Pipe Operators (|>, :>, .>) (Broken)

def double(x: int) -> int { return x * 2; }
def add_one(x: int) -> int { return x + 1; }

with entry {
    # 1. Forward Pipe (OK)
    result = 5 |> double |> add_one;
    print(result);
    
    # 2. Type mismatch in Pipe
    result = "Alice" |> double; # Error: expected int, got str
    print(result);

    # 3. Dot Pipe on non-method
    #x = 10;
    #result = x .> double; # Error: expected method, got function
    
    # 4. Atomic Pipe (spawn :>) on non-walker
    # 5 :> 10; # Error: expected spawn or walker, got int
}
