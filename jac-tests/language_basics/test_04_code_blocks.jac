# Jac uses braces { } for code blocks. We will test Python's indentation style.
with entry:
    condition = True;
    if condition {
        print("This should throw a ParseError expecting {");
    }