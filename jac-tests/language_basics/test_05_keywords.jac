# Intentionally attempting to use reserved structural and control keywords as identifiers
with entry {
    node = "This is a node";
    spawn = 42;
    if = True;
    
    print(node, spawn, if);
}
