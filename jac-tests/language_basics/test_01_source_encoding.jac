# Intentionally injecting a random unrecognized operator/symbol to test the lexer
$invalid_symbol = 42;

with entry {
    print($invalid_symbol);
}
