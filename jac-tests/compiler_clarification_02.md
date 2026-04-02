# Jac Compiler Clarification: Named Entry Points (`with entry:name`)

## Context
During the testing of `test_07_entry_points.jac`, it was observed that defining a named entry point such as `with entry:entry_one { ... }` results in code that does not execute when using the standard `jac ` or `jac enter` CLI commands.

## The Confusion
A developer might naturally assume that `with entry:name` is a way to create a "named script" inside a file that can be invoked directly from the CLI (e.g., `jac enter file.jac name`). However, attempt to do so results in an `AttributeError`, as the CLI looks for a function or class attribute, while the named entry is a top-level block guarded by a module name check.

## Root Cause & Technical Purpose
The `with entry:name` syntax transpiles to a module name guard in Python:
```python
if __name__ == 'name':
    # block content
```

### Actual Use Cases:
1. **Multi-Target Variants**: This syntax is primarily intended for **Plugin-driven Variant selection**. Names like `cl` (client), `sv` (server), and `na` (native) are recognized by the Jaseci ecosystem to execute code only in specific execution environments (e.g., code in a `.cl.jac` file using `with entry:cl` only runs on the client).
2. **Import-Time Execution**: A named entry block will execute if the module is imported under that specific name. For example, if `module_a.jac` is imported as `module_a`, any `with entry:module_a` block inside it will run during the import.

## Developer Note
> [!TIP]
> If you want to create a named entry point that is **directly runnable from the CLI**, do not use `with entry:name`. Instead, define a **walker** or a **function** with that name:
> ```jac
> walker my_entry {
>     can speak with entry { print("Hello!"); }
> }
> ```
> This can be triggered via `jac enter filename.jac my_entry`.

## Severity of Confusion
**Medium**
New developers often mistake this for a task-runner feature. Proper documentation of this "guarded" behavior is essential for language clarity.
