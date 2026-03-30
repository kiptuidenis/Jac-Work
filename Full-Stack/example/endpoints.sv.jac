
# ========================================
# Data Models
# ========================================
node Todo {
    has id: str,
        title: str,
        completed: bool = False;
}

glob todo_counter: int = 0;

# ========================================
# Walkers (API Operations)
# ========================================
walker:priv AddTodo {
    """Add a new todo item to the user's list."""
    has title: str;

    can create with Root entry {
        global todo_counter;
        todo_counter += 1;
        new_id = "todo_" + str(todo_counter);
        print(f"Old_todo: {todo_counter}");
        new_todo = here ++> Todo(id=new_id, title=self.title, completed=False);
        if new_todo {
            report new_todo[0];
        }
    }

    can create with Root entry {
        global todo_counter;
        todo_counter += 10;
        new_id = "todo_" + str(todo_counter);
        print(f"New_todo: {todo_counter}");
        new_todo = here ++> Todo(id=new_id, title=self.title, completed=False);
        if new_todo {
            report new_todo[0];
        }
    }
}

walker:priv ListTodos {
    """List all todo items for the current user."""
    has todos: list = [];

    can collect with Root entry {
        print("I ran this ListTodos first");
        visit [-->];
    }

    can collect with Root entry {
        print("I ran this ListTodos second");
        self.todos.append(
            {"id": here.id, "title": here.title, "completed": here.completed}
        );
    }

    can collectss with Root exit {
        report self.todos;
    }
}

walker:priv ToggleTodo {
    """Toggle a todo's completed status."""
    has todo_id: str;

    can with Root entry {
        visit [-->];
    }

    can with Todo entry {
        if here.id == self.todo_id {
            here.completed = not here.completed;
            report {"id": here.id, "completed": here.completed};
        }
    }
}

walker:priv DeleteTodo {
    """Delete a todo item."""
    has todo_id: str;

    can search with Root entry {
        visit [-->];
    }

    can with Todo entry {
        if here.id == self.todo_id {
            del here;
            report {"deleted": self.todo_id};
        }
    }
}
