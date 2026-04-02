# Two breakages: invalid prefix (number) and invalid backtick usage in datamodels

obj BreakableModel {
    # The documentation specifically says this will crash the Python dataclass machinery at runtime!
    has `class: str;
}

with entry {
    1invalid_var = 10;
    
    # Trying to mutate an internal reference
    self = 42;
}
