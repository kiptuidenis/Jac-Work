"""Phase 1.5 Rigorous Transport Unit Tests

These tests isolate and pound the McpClient class to ensure it correctly returns
JSON-RPC formatted dictionary answers (e.g., {"error": "..."}) instead of crashing
the Python process when catastrophic network failures occur.
"""

import from mcp_client { McpClient }

test "McpClient Stdio Happy Path" {
    # Stdio spawns its own internal `jac mcp` process safely without needing external servers.
    client = McpClient(transport="stdio");
    res = client.send_request("tools/list", {});
    
    assert "result" in res, f"Stdio failed to return a valid JSON-RPC tools list. Got: {res}";
    assert "tools" in res["result"], "Result does not contain tools array";
    assert len(res["result"]["tools"]) > 0, "Stdio tool list was unexpectedly empty";
}

test "McpClient HTTP Missing Server (Connection Refused)" {
    # Hitting a dead port to prove the HTTP client gracefully catches the connection drop.
    client = McpClient(transport="http", url="http://127.0.0.1:9999/mcp/");
    res = client.send_request("tools/list", {});
    
    assert "error" in res, "Client failed to wrap the HTTP failure in a JSON-RPC error dict";
    assert "Connection refused" in res["error"] or "ConnectionError" in res["error"], f"Client caught wrong error type: {res['error']}";
}

test "McpClient HTTP Invalid Endpoint (404 Not Found)" {
    # Hitting an invalid URI to prove our new 404 parsing patches JSONDecodeError.
    client = McpClient(transport="http", url="http://127.0.0.1:3001/invalid_testing_uri_7283");
    res = client.send_request("tools/list", {});
    
    assert "error" in res, "Client failed to wrap the HTTP 404 failure in a JSON-RPC error dict";
    assert "HTTP 404" in res["error"], f"Client didn't properly extract the 404: {res['error']}";
}

test "McpClient Timeout Handling" {
    # Enforcing a 1-millisecond timeout to ensure Requests drops the connection natively
    # Blackhole IP 10.255.255.1 guarantees it hangs on connection.
    client = McpClient(transport="http", url="http://10.255.255.1/mcp/", timeout=0.001);
    res = client.send_request("tools/list", {});
    
    assert "error" in res, "Client failed to wrap the Timeout failure in a JSON-RPC error dict";
    assert "Timeout" in res["error"] or "Network is unreachable" in res["error"], f"Client caught wrong error type: {res['error']}";
}
