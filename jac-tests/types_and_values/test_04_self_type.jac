# Test 04: The Self Type (Self vs self)

obj Node {
    has value: int = 0;
    
    # 1. Scope Violation: Using Self (type) incorrectly
    def set_value(v: int) -> Self {
        Self.value = v; # Error: Self is the type, self is the instance
        return self;
    }
    
    # 2. Static vs Instance: Using self inside a static method
    static def create(v: int) -> Self {
        return self(value=v); # Error: self is not available in static
    }
}

with entry {
    n = Node();
}
