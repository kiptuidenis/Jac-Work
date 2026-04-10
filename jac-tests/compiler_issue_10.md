# Type Checker Feedback: identifier 'any' Resolved as Function Instead of Type

**Jac Version:** 0.13.5

## 1. What I expected the type checker to do
According to Jaseci Foundation documentation (Section 3), `any` should be used as a placeholder type for generic parameters. I expected the type checker to recognize `any` as the top-level type when used in an annotation context (e.g., `: any`).

## 2. What it actually did
The type checker resolved the identifier `any` as the built-in function `any(iterable) -> bool`, leading to a false-positive type mismatch when passing non-function arguments to the parameter.

**Error Message:**
> `Cannot assign list[int] to parameter 'value' of type <function any(iterable: Iterable[object]) -> bool>`

## 3. Minimal code that reproduces it
```jac
def test_func(value: any) {
    print(value);
}

with entry {
    # Type checker incorrectly thinks 'value' must be a function pointer to any()
    test_func([1, 2, 3]);
}
```
