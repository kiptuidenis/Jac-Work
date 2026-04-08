
obj Person {
    has name: str;
}

with entry {

    # Runtime: PERMISSIVE (Succeeds unexpectedly)
    p = Person(name="Alice");
    p.height = 175; # This is NOT in 'has'
    print(p.height); # Prints '175'
}