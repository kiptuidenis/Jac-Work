# Test 03: Global Variables (glob) and Modification

glob DEBUG: bool = True;

def toggle_debug() {
    # 1. Implicit global: Modifying a glob without the 'global' keyword
    # Python-style: Should throw a local variable error
    DEBUG = not DEBUG;
    print(f"Debug is: {DEBUG}");
}

def global_as_local() {
    # 2. Forbidden glob: Attempting to use glob inside a function
    # glob NAME: str = "LocalGlob"; # Correctly caught at compile-time
    NAME = "LocalGlob";
    print(NAME);
}

with entry {
    toggle_debug();
    global_as_local();
}
