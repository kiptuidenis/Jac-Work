# Jac Compiler Diagnostic Issue: The `Self` Keyword Paradox

## Issue Description
There is a fundamental confusion in how the Jac compiler distinguishes between `Self` (capital S) and `self` (lowercase s) during reference resolution and type checking. 

According to the **Jac Foundation Documentation (Language Basics > Identifiers)**:
> "self is the current instance; Self is the enclosing type."

Our tests reveal that the compiler's diagnostic engine (specifically in `jac check`) currently fails to recognize `Self` as a protected, built-in keyword for the enclosing archetype's type. Instead, it treats `Self` as an independent identifier, leading to errors when a developer attempts to use it as a type reference or as a static access point.

## Reproduction
**File:** `types_and_values/test_04_self_type.jac`
```jac
obj Node {
    has value: int = 0;
    
    # Intentional Break: Using Self (the type) as an instance
    def set_value(v: int) -> Self {
        Self.value = v; # Should be self.value
        return self;
    }
}
```

## The Paradoxical Findings

### 1. `jac run` is oblivious
The runtime completely ignores the line `Self.value = v;`. It does not throw a NameError or an AttributeError. This suggests that during the Python transpilation phase, `Self` might be being swallowed or incorrectly mapped in a way that doesn't trigger Python's runtime checks.

### 2. `jac check` is conflicted
When running `jac check`, the compiler produces two contradictory messages:
- **Error [E1032]**: `Type is Unknown, cannot access attribute "value"`. (This is "correct" in the sense that you can't access instance attributes on a type, but it calls the type `Unknown`).
- **Warning [W2001]**: `Name 'Self' may be undefined`. 

## Why it is Confusing
If `Self` is a built-in keyword (a "Pillar of Jac"), the type checker should never report it as "possibly undefined." 

This creates a "Double Blind" for developers:
- If they use `Self` correctly as a return type (e.g., `-> Self`), they get an "undefined" warning.
- If they use it incorrectly as an instance, they get an "Unknown Type" error.
- In both cases, the compiler acts as if `Self` is a user-defined name it hasn't seen yet, rather than a core language feature.

## Severity Level
**Medium**
It doesn't break the build (warnings are just warnings), but it undermines the developer's trust in the "Mandatory Typing" and "Object-Spatial" principles of the language.

## Recommendation
The reference resolution for `Self` needs to be hardcoded into the compiler's symbol table, similar to how `self` is handled, to ensure it is always recognized as the "enclosing class/archetype type."
