# Test 07: Parser Panics (Robustness Analysis)

node Person { has name: str; }
edge Friend { has since: int = 2020; }

with entry {
    n1 = Person(name="Alice");
    n2 = Person(name="Bob");

    # 1. Unbalanced Typed Connection (Missing second +>)
    # This was the original panic trigger
    n1 +> :Friend: n2; 

    # 2. Unclosed Edge Attribute Parens
    # alice +> :Friend(since=2021 +> bob;
    
    # 3. Malformed filter in traversal
    # neighbors = [n1 -> :Friend: since > 5 : -> ];
    
    # 4. Nested spatial operations (likely illegal)
    # n1 ++> (n2 ++> n1);
}
