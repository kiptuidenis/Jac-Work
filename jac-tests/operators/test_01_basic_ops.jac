# Test 01: Basic and Assignment Operators

with entry {
    # 1. Invalid operator chaining
    a = 5 +* 10; # Error: Syntax error
    
    # 2. Walrus in invalid context
    # x := 10; # Standalone walrus
    
    # 3. Mixing logical operators
    result = True or False || True; # Confusing precedence?
}

#obj Test {
    # 4. Forbidden Walrus in has block
#   has x := 5; # Error: has declarations must use = or be abstract
#}
