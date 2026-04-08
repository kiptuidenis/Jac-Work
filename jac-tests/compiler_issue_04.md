# Jac Compiler Diagnostic Issue: Inconsistent Attribute Strictness (Construction vs. Runtime)

## Issue Description
There is a fundamental inconsistency in how the Jac compiler enforces its "declarative" data model during object lifecycle. While the auto-generated constructor (`__init__`) is strictly limited to the `has` fields, the runtime allows dynamic attribute assignment on instances after they are created.

## Reproduction
**File:** `variables_and_scope/test_02_instance_variables.jac`
```jac
obj Person {
    has name: str;
}

with entry {
    # 1. Constructor: STRICT (Fails as expected)
    # p = Person(name="Alice", age=30); 
    # Error: Person.__init__() got an unexpected keyword argument 'age'

    # 2. Runtime: PERMISSIVE (Succeeds unexpectedly)
    p = Person(name="Alice");
    p.height = 175; # This is NOT in 'has'
    print(p.height); # Prints '175'
}
```

## Why it is Confusing
The **Jac Foundation Documentation (Variables and Scope > Instance Variables)** states:
> "Jac uses declarative `has` statements that make your data model explicit... no `self` needed for declarations."

By allowing `p.height = 175`, the language violates its own declarative promise and reverts to Python's dynamic behavior. This creates a "Security Hole" in the data model:
-   A developer might assume that an `obj` is a fixed-schema structure based on its `has` blocks.
-   However, runtime code can inject arbitrary attributes at any time, bypassing type checks and model clarity.

## Expected Behavior
If Jac aims to be a "declarative" language that "improves readability for both humans and AI," then attribute assignment on an `obj` instance should be restricted to those names explicitly declared in the archetype's `has` blocks. Attempting to assign `p.height` should result in an `AttributeError` or a compiler warning.

## Severity Level
**Medium**
-   **Impact:** Undermines the value of the declarative `has` syntax.
-   **Fix:** Consider adding `__slots__` generation or a custom `__setattr__` to archetypes to enforce the schema.
