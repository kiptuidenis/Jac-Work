import from mcp_client { McpClient }

walker test_client {
    has transport: str;
    
    can test with Root entry {
        print(f"Testing transport: {self.transport}");
        mcp = McpClient(transport=self.transport);
        
        print("Calling list_tools...");
        res = mcp.send_request("tools/list", {});
        with open("tools_output.json", "w") as f {
            json.dump(res, f, indent=2);
        }
        print("Done. Wrote to tools_output.json");
    }
}
