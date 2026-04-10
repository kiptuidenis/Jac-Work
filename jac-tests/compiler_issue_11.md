# Type Checker Feedback: Pattern Matching Variable Bindings Not Recognized

**Jac Version:** 0.13.5

## 1. What I expected the type checker to do
When using a sequence pattern (list) or mapping pattern (dict) in a `match/case` block, such as `case [x, y]:`, I expected the type checker to recognize `x` and `y` as new local variables bound within that case's scope. 

## 2. What it actually did
The type checker fails to recognize the binding and flags the variables as potentially undefined at the point of usage.

**Error Message:**
> `warning[W2001]: Name 'x' may be undefined`
> `warning[W2001]: Name 'y' may be undefined`

## 3. Minimal code that reproduces it
```jac
def test_match(value: any) {
    match value {
        case [x, y]:
            # Type checker warns that x and y may be undefined
            print(f"Binds: {x}, {y}");
    }
}

with entry {
    test_match([10, 20]);
}
```
