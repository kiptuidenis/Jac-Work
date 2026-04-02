# Test 06: Type References (Context and Syntax)

# 1. Context Violation: Using Root keyword outside of walker
def example() {
    # Documentation says: Root keyword refers to the root node type in entry/exit clauses
    n: Root = root; # Error: Root is a type reference for OSP, not a general type?
}

node Person { has name: str; }

walker Visitor {
    can visit with entry {
        # 2. Syntax Break: Malformed type filter [?:TypeName]
        # [ --> ] [?: Person]; # Filter nodes by Person type
        
        # Missing closing bracket or colon
        p = [ --> ] [?: Person ; 
        print(p);
    }
}

with entry {
    example();
}
