# Test 03: Graph Operators (OSP) (Broken)

node Person { has name: str; }
edge Friend { has since: int = 2020; }
obj NonNode { has name: str; }

with entry {
    n1 = Person(name="Alice");
    n2 = Person(name="Bob");
    nn = NonNode(name="Charlie");
    
    # 1. Connection (OK)
    n1 ++> n2;
    
    # 2. Context Violation: ++> on NonNode
    #nn ++> n1; # Error: expected node, got obj
    
    # 3. Malformed typed connection
    n1 +> :Friend: n2; # Error: missing second +>
    
    # 4. Traversal Violation: `-->` on NonNode
    #results = [nn -->]; # Error: expected node or walker, got obj
}
