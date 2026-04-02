# Test 05: Union Types (Syntax and Parser Stress)

obj Example {
    # 1. Syntax Break: Python old Union[int, str] syntax or illegal int or str
    # Documentation says: int | str | None
    has value: Union[int, str]; # Error: Python-style Union requires import
    has other: int or str; # Error: Invalid syntax for union
}

def process(data: int | | str) {
    # 2. Incomplete union or illegal separator
    print(data);
}

with entry {
    res = Example(value=10);
    process(10);
}
