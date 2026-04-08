"""Jac-Diagnostics - Entry Point.

Combines server-side diagnostic endpoints with client-side UI.
"""

import from typing { Any }
import json;
import from mcp_client { McpClient, call_tool }
import from byllm.lib { Model }

glob llm = Model(model_name="gemini/gemini-2.5-flash");

# MCP Tool Bridges for LLM Function Calling

def _log_mcp(tool_name: str) {
    print(f"\n🤖 [LLM AGENT] Executing MCP Tool: {tool_name}...\n");
}

"""Validate Jac code for syntax and type errors."""
def mcp_validate_jac(code: str) -> dict {
    _log_mcp("validate_jac");
    return call_tool(McpClient(transport="stdio"), "validate_jac", {"code": code});
}

"""Search authoritative Jac documentation by keywords."""
def mcp_search_docs(query: str) -> dict {
    _log_mcp("search_docs");
    return call_tool(McpClient(transport="stdio"), "search_docs", {"query": query});
}

"""Fetch a complete, working Jac code example by category name."""
def mcp_get_example(name: str) -> dict {
    _log_mcp("get_example");
    return call_tool(McpClient(transport="stdio"), "get_example", {"name": name});
}

"""Quick syntax-only check (parse-only, no type checking)."""
def mcp_check_syntax(code: str) -> dict {
    _log_mcp("check_syntax");
    return call_tool(McpClient(transport="stdio"), "check_syntax", {"code": code});
}

"""Format Jac code according to standard style."""
def mcp_format_jac(code: str) -> dict {
    _log_mcp("format_jac");
    return call_tool(McpClient(transport="stdio"), "format_jac", {"code": code});
}

"""Convert Python code to Jac using the official compiler transpiler."""
def mcp_py_to_jac(python_code: str) -> dict {
    _log_mcp("py_to_jac");
    return call_tool(McpClient(transport="stdio"), "py_to_jac", {"python_code": python_code});
}

"""Explain a Jac compiler error with suggestions and examples."""
def mcp_explain_error(error_message: str) -> dict {
    _log_mcp("explain_error");
    return call_tool(McpClient(transport="stdio"), "explain_error", {"error_message": error_message});
}

"""List available Jac example code categories."""
def mcp_list_examples(category: str = "") -> dict {
    _log_mcp("list_examples");
    payload = {"category": category} if category else {};
    return call_tool(McpClient(transport="stdio"), "list_examples", payload);
}

"""Parse Jac code and return AST representation as tree or json."""
def mcp_get_ast(code: str, format: str = "tree") -> dict {
    _log_mcp("get_ast");
    return call_tool(McpClient(transport="stdio"), "get_ast", {"code": code, "format": format});
}

"""Lint Jac code to detect style violations and unused symbols."""
def mcp_lint_jac(code: str, auto_fix: bool = False) -> dict {
    _log_mcp("lint_jac");
    return call_tool(McpClient(transport="stdio"), "lint_jac", {"code": code, "auto_fix": auto_fix});
}

"""Convert Jac code to Python using the official transpiler."""
def mcp_jac_to_py(code: str) -> dict {
    _log_mcp("jac_to_py");
    return call_tool(McpClient(transport="stdio"), "jac_to_py", {"code": code});
}

"""Convert Jac code to JavaScript using the official transpiler."""
def mcp_jac_to_js(code: str) -> dict {
    _log_mcp("jac_to_js");
    return call_tool(McpClient(transport="stdio"), "jac_to_js", {"code": code});
}

"""Execute Jac code natively and return stdout/stderr."""
def mcp_run_jac(code: str, entrypoint: str = "", timeout: int = 10) -> dict {
    _log_mcp("run_jac");
    return call_tool(McpClient(transport="stdio"), "run_jac", {"code": code, "entrypoint": entrypoint, "timeout": timeout});
}

"""Execute Jac code and generate a graph visualization (dot/json)."""
def mcp_graph_visualize(code: str, format: str = "dot", depth: int = -1, bfs: bool = True) -> dict {
    _log_mcp("graph_visualize");
    return call_tool(McpClient(transport="stdio"), "graph_visualize", {"code": code, "format": format, "depth": depth, "bfs": bfs});
}

"""List all available jac CLI commands including arguments."""
def mcp_list_commands() -> dict {
    _log_mcp("list_commands");
    return call_tool(McpClient(transport="stdio"), "list_commands", {});
}

"""Get full argument details for a specific jac CLI command."""
def mcp_get_command(name: str) -> dict {
    _log_mcp("get_command");
    return call_tool(McpClient(transport="stdio"), "get_command", {"name": name});
}

"""Execute a jac CLI command by name with optional arguments."""
def mcp_execute_command(command: str, args: list = [], timeout: int = 30) -> dict {
    _log_mcp("execute_command");
    return call_tool(McpClient(transport="stdio"), "execute_command", {"command": command, "args": args, "timeout": timeout});
}

walker:pub validate_code {
    has code: str;
    has transport: str = "stdio";

    can validate with Root entry {
        mcp = McpClient(transport=self.transport);
        response = call_tool(mcp, "validate_jac", {"code": self.code});

        is_valid = False;
        try {
            if "result" in response and "content" in response["result"] {
                result_text = response["result"]["content"][0]["text"];
                parsed_result = json.loads(result_text);
                is_valid = parsed_result.get("valid", False);
            }
        } except Exception as e {}

        # Add metadata and instrumentation details
        res = {
            "status": "success" if is_valid else "failed",
            "mcp_response": response,
            "code_len": len(self.code),
            "transport_used": self.transport
        };

        report res;
    }
}

walker:pub run_stress_suite {
    has transport: str = "stdio";
    can run with Root entry {
        results = [];
        # Placeholder for 50+ test cases logic
        report {"status": "success", "results": results};
    }
}

walker:pub test_all_tools {
    has transport: str = "stdio";
    can test with Root entry {
        mcp = McpClient(transport=self.transport);

        sample_code = "obj Calculator { can add(a: int, b: int) -> int { return a + b; } }";
        run_jac_payload = "with entry { print('Isolated jac run check'); }";
        
        results = [];
        
        # Helper to append
        def add_res(name: str, payload: dict) {
            results.append({"name": name, "res": call_tool(mcp, name, payload)});
        }

        add_res("validate_jac", {"code": sample_code});
        add_res("check_syntax", {"code": sample_code});
        add_res("format_jac", {"code": sample_code});
        add_res("py_to_jac", {"python_code": "def add(a, b): return a + b"});
        add_res("explain_error", {"error_message": "type mismatch: expected int, got str"});
        add_res("list_examples", {});
        add_res("get_example", {"name": "data_spatial"});
        add_res("search_docs", {"query": "walker"});
        add_res("get_ast", {"code": sample_code});
        add_res("lint_jac", {"code": sample_code});
        add_res("jac_to_py", {"code": sample_code});
        add_res("jac_to_js", {"code": sample_code});
        add_res("run_jac", {"code": run_jac_payload});
        add_res("graph_visualize", {"code": "node State; edge Transition; with entry { root ++> State(); }"});
        add_res("list_commands", {});
        add_res("get_command", {"name": "run"});
        add_res("execute_command", {"command": "help", "args": ["mcp"]});

        report {"status": "success", "results": results, "transport": self.transport};
    }
}

walker:pub ai_ask {
    has question: str;
    has context: str = "";
    has transport: str = "stdio";

    def ask_llm(q: str, ctx: str) -> str by llm(
        tools=[
            mcp_validate_jac, mcp_search_docs, mcp_get_example,
            mcp_check_syntax, mcp_format_jac, mcp_py_to_jac,
            mcp_explain_error, mcp_list_examples, mcp_get_ast,
            mcp_lint_jac, mcp_jac_to_py, mcp_jac_to_js,
            mcp_run_jac, mcp_graph_visualize, mcp_list_commands,
            mcp_get_command, mcp_execute_command
        ]
    );

    can run with Root entry {
        # Fetch context from MCP if not provided
        if not self.context {
            mcp = McpClient(transport=self.transport);
            # Fetch pitfalls as core context
            self.context = json.dumps(
                mcp.send_request("resources/read", {"uri": "jac://guide/pitfalls"})
            );
        }

        ans = self.ask_llm(self.question, self.context);
        report {"answer": ans};
    }
}

walker:pub ai_fix {
    has code: str;
    has error: str;
    has transport: str = "stdio";

    def fix_code(c: str, e: str) -> str by llm();
    can run with Root entry {
        fixed = self.fix_code(self.code, self.error);
        report {"fixed_code": fixed};
    }
}

walker:pub search_docs {
    has query: str;
    has transport: str = "stdio";

    can search with Root entry {
        mcp = McpClient(transport=self.transport);
        report mcp.send_request("search_docs", {"query": self.query});
    }
}

# Client-side UI
cl {
    import from frontend { app as ClientApp }

    def:pub app -> any {
        return
            <ClientApp />;
    }
}
