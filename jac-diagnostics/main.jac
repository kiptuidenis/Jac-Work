"""Jac-Diagnostics - Entry Point.

Combines server-side diagnostic endpoints with client-side UI.
"""

import from typing { Any }
import json;
import from mcp_client { McpClient, call_tool }
import from byllm.lib { Model }

glob llm = Model(model_name="gemini/gemini-2.5-flash");

# MCP Tool Bridges for LLM Function Calling
"""Validate Jac code for syntax and type errors."""
def mcp_validate_jac(code: str) -> dict {
    mcp = McpClient(transport="stdio");
    return call_tool(mcp, "validate_jac", {"code": code});
}

"""Search authoritative Jac documentation by keywords."""
def mcp_search_docs(query: str) -> dict {
    mcp = McpClient(transport="stdio");
    return call_tool(mcp, "search_docs", {"query": query});
}

"""Fetch a complete, working Jac code example by category name."""
def mcp_get_example(name: str) -> dict {
    mcp = McpClient(transport="stdio");
    return call_tool(mcp, "get_example", {"name": name});
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

        results = {};
        # 1. validate_jac
        results["validate_jac"] = call_tool(mcp, "validate_jac", {"code": sample_code});
        # 2. check_syntax
        results["check_syntax"] = call_tool(mcp, "check_syntax", {"code": sample_code});
        # 3. format_jac
        results["format_jac"] = call_tool(mcp, "format_jac", {"code": sample_code});
        # 4. py_to_jac (smoke test)
        results["py_to_jac"] = call_tool(mcp, "py_to_jac", {"python_code": "def add(a, b): return a + b"});
        # 5. list_examples
        results["list_examples"] = call_tool(mcp, "list_examples", {});
        # 6. search_docs (smoke test)
        results["search_docs"] = call_tool(mcp, "search_docs", {"query": "walker"});

        report {"status": "success", "results": results, "transport": self.transport};
    }
}

walker:pub ai_ask {
    has question: str;
    has context: str = "";
    has transport: str = "stdio";

    def ask_llm(q: str, ctx: str) -> str by llm(
        tools=[mcp_validate_jac, mcp_search_docs, mcp_get_example]
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
