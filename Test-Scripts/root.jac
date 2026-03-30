walker ListTodos {
    # CORRECT: can collect with Root entry { ... }
    can collect with root entry {
        print("I am here");
        report "I have worked";
    }
}

with entry {
    root spawn ListTodos();
}
