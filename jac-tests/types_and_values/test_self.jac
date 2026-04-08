obj Node {
    has value: int = 0,
        next: Self | None = None;  # Self = Node in type annotations

    class def create(v: int) -> Self {  # Self = cls in class methods
        return Self(value=v);
    }

    def set_next(n: Self) -> Self {  # Self as parameter and return type
        Self.next = n;
        return self;
    }
}

with entry {
    n = Node.create(10);
    print(n);
    n.set_next(n);
    print(n);
}