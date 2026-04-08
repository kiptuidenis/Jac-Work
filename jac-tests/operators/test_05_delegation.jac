# Test 05: The by and sem Operators (Broken)

# 1. Semantic Markup (OK)
sem User = "A person in the system";
sem User.name = "The full name of the user";

obj User {
    has name: str;
}

# 2. Delegation (by llm)
def summarize(text: str) -> str by llm(); # Error: Missing plugin
sem summarize = "Summarize the text";

with entry {
    # 3. Dynamic 'by' expression
    result = "hello" by "world";
    print(result);
}
