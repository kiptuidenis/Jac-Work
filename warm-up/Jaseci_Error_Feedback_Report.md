---
# Jaseci Error Reporting Feedback

**Date:** March 2026  
**Environment:** WSL (Ubuntu) on Windows, Python 3.12, Jaseci Environment  
**Reporter:** Denis Kiptui

## Executive Summary
This document provides feedback to the Jaseci Core team regarding the current state of error reporting in the Jac CLI. While the language itself functions well, the compiler and runtime exhibit a poor developer experience (DX) when handling basic Operating System and logic errors. Two key issues have been identified:
1. Missing graceful handling for standard OS exceptions (e.g., `PermissionError`).
2. Secondary bugs relating to database caching states on exit.

---

## 📸 Issue 1: Permission Error Handling Extravaganza
### Problem Description
When compiling/running a `.jac` file in a directory where the user lacks write permissions (blocking the creation of the `.jac` build artifact directory), the command line interface crashes ungracefully. 

Expected behavior is to catch standard OS-level exceptions, particularly `PermissionError`, and display an actionable summary to the developer such as: `[Error] Permission denied. Cannot write compiled artifacts to the '.jac' directory. Please ensure you have write permissions in this folder.`

Instead, the CLI exposes its internal Python stack trace, overwhelming the terminal state. 

### Visual Evidence
Below is a transcription of the trace evidence during testing:

```bash
(jac-env) denis@Denis:~/Jaseci/warm-up$ jac hello.jac
XError: Error executing 'run': [Errno 13] Permission denied: '.jac'
Traceback (most recent call last):
  File "/home/runner/work/jaseci/jaseci/jac/jaclang/cli/impl/executor.impl.jac", line 31, in execute
  File "/home/runner/work/jaseci/jaseci/jac/jaclang/cli/impl/executor.impl.jac", line 113, in run_handler
  File "/home/runner/work/jaseci/jaseci/jac/jaclang/cli/commands/impl/execution.impl.jac", line 136, in run
  File "/home/denis/Jaseci/jac-env/lib/python3.12/site-packages/jaclang/cli/commands/execution.jac", line 116, in _proc_file
    short="f"
  File "/home/denis/Jaseci/jac-env/lib/python3.12/site-packages/jaclang/jac0core/runtime.jac", line 1676, in proxy
    }
  File "/home/runner/work/jaseci/jaseci/jac/jaclang/runtimelib/impl/memory.impl.jac", line 172, in _ensure_connection
  File "<frozen os>", line 215, in makedirs
  File "<frozen os>", line 225, in makedirs
PermissionError: [Errno 13] Permission denied: '.jac'
XError: [Errno 13] Permission denied: '.jac'
```
```

---

## 📸 Issue 2: Parser Melt-down on JS Arrow Functions
### Problem Description
When writing UI components in Jac (e.g., inside `.cl.jac` files), developers migrating from React might accidentally use JavaScript arrow functions `(e) => {}` instead of Jac's `lambda` syntax `lambda e: any -> None {}`. 

On a positive note, the compiler successfully identifies the exact file and line where the error occurred (`frontend.cl.jac:107`) and prints a helpful code snippet pointing directly at the syntax error. However, the overall output cascade is extremely verbose and bleeds internal parser state, heavily obscuring the actual root cause of the syntax failure.

### Visual Evidence
The user replaced a valid Jac lambda bound to an `onChange` prop with `(e) => { newTodoText = e.target.value; }`. The CLI correctly flags the line:

```bash
┌ JAC_CLIENT_005: Compilation Error ─────────────────────────────────┐
│────────────────────────────────────────────────────────────────────│
│                                                                    │
│  'JSX_TAG_END'                                                     │
│                                                                    │
│  File: /home/denis/Jaseci/Full-Stack/example/frontend.cl.jac:107   │
│                                                                    │
│       105 |                         type="text"                    │
│       106 |                         value={newTodoText}            │
│   ->  107 |                         onChange={(e) => { newTodo...  │
...
```

However, instead of stopping at the clean error block and providing a simple message like `[Syntax Error] JS-style arrow functions are not supported. Use Jac lambda syntax.`, the compiler then dumps over 25 lines of raw lexer/parser mismatch traces:

```bash
--- Raw Error (debug=true) ---
Failed to compile '/home/denis/Jaseci/Full-Stack/example/frontend.cl.jac' for
client bundle:/home/denis/Jaseci/Full-Stack/example/frontend.cl.jac, line 107, col
39: Missing '}'
/home/denis/Jaseci/Full-Stack/example/frontend.cl.jac, line 107, col 39: Expected
'JSX_TAG_END', got '='
...
/home/denis/Jaseci/Full-Stack/example/frontend.cl.jac, line 107, col 56: Expected
'</', got '='
...
```

### Analysis & Recommendation
The CLI's ability to locate the syntax error and print the code snippet is excellent UX. However, the fallback parser cascade traces (`--- Raw Error (debug=true) ---`) should absolutely be suppressed by default. A developer should only see the `Compilation Error` snippet block and `JAC_CLIENT_003: Syntax Error` hints. Dumping the raw unrolled AST/Lexer symbol expectation mismatches (e.g., `Expected 'JSX_NAME', got '}'`) is disorienting for regular developers.
