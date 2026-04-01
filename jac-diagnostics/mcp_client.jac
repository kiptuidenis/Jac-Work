"""Enhanced Jac-MCP Client.

Supports multiple transports (stdio, sse, streamable-http) and 
full MCP lifecycle (tools, resources, prompts).
"""
import from typing { Any }
import json;
import subprocess;
import sys;
import time;
import re;

obj McpClient {
    has transport: str = "stdio";
    has url: str = "http://127.0.0.1:3001/mcp/";
    has timeout: int = 30;
    has _id_counter: int = 1;
    has _session_id: str = None;
    has _initialized: bool = False;

    """Send a request via the configured transport."""
    def send_request(method: str, params: dict = {}) -> dict {
        if self.transport == "stdio" {
            # stdio is one-shot in our current implementation, 
            # so it always initializes inside _send_stdio
            return self._send_stdio(method, params);
        } elif self.transport == "sse" {
            return self._send_sse_oneshot(method, params);
        } elif self.transport in ["streamable-http", "http"] {
            return self._send_http_stateful(method, params);
        }
        return {"error": f"Unsupported transport: {self.transport}"};
    }

    """Internal: Send request via stdio."""
    def _send_stdio(method: str, params: dict) -> dict {
        try {
            proc = subprocess.Popen(
                ["jac", "mcp", "--transport", "stdio"],
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                bufsize=1
            );

            # 1. Initialize
            self._write_msg(proc, "initialize", {
                "protocolVersion": "2024-11-05",
                "capabilities": {},
                "clientInfo": {"name": "jac-diagnostics", "version": "1.0.0"}
            });
            init_res = self._read_msg(proc);
            
            # 2. Initialized
            self._write_msg(proc, "notifications/initialized", {}, True);

            # 3. Actual Call
            self._write_msg(proc, method, params);
            res = self._read_msg(proc);

            proc.terminate();
            return res;
        } except Exception as e {
            return {"error": str(e)};
        }
    }

    """Internal: One-shot SSE request."""
    def _send_sse_oneshot(method: str, params: dict) -> dict {
        msg = {
            "jsonrpc": "2.0",
            "method": method,
            "params": params,
            "id": self._id_counter
        };
        self._id_counter += 1;

        try {
            import requests;
            import sseclient;
            import urllib.parse;
            import json;

            sse_url = self.url.replace("/mcp/", "/sse") if "/mcp" in self.url else self.url + "sse";
            response = requests.get(sse_url, stream=True, timeout=self.timeout);
            client = sseclient.SSEClient(response);
            
            post_url = None;
            state = "wait_endpoint";
            
            for event in client.events() {
                if state == "wait_endpoint" {
                    if event.event == "endpoint" {
                        post_url = event.data;
                        if not post_url.startswith("http") {
                            parsed = urllib.parse.urlparse(self.url);
                            post_url = f"{parsed.scheme}://{parsed.netloc}{post_url}";
                        }
                        # Handshake 1: Initialize
                        init_msg = {
                            "jsonrpc": "2.0",
                            "method": "initialize",
                            "params": {"protocolVersion": "2024-11-05", "capabilities": {}, "clientInfo": {"name": "jac-diag", "version": "1.0"}},
                            "id": self._id_counter
                        };
                        requests.post(post_url, json=init_msg, timeout=self.timeout);
                        state = "wait_init_res";
                    }
                } elif state == "wait_init_res" {
                    if event.event == "message" {
                        data = json.loads(event.data);
                        if data.get("id") == init_msg["id"] {
                            self._id_counter += 1;
                            # Handshake 2: Initialized notification
                            notif_msg = {
                                "jsonrpc": "2.0",
                                "method": "notifications/initialized",
                                "params": {}
                            };
                            requests.post(post_url, json=notif_msg, timeout=self.timeout);
                            # Actual request
                            post_res = requests.post(post_url, json=msg, timeout=self.timeout);
                            if post_res.status_code not in [200, 202] {
                                return {"error": f"Failed to post to SSE endpoint: {post_res.status_code}"};
                            }
                            state = "wait_message_res";
                        }
                    }
                } elif state == "wait_message_res" {
                    if event.event == "message" {
                        data = json.loads(event.data);
                        if data.get("id") == msg["id"] {
                            return data;
                        }
                    }
                }
            }
            
            return {"error": "No matching message received on SSE stream"};
        } except Exception as e {
            return {"error": f"SSE Error: {str(e)}"};
        }
    }

    """Internal: Send request via HTTP with handshake if needed."""
    def _send_http_stateful(method: str, params: dict) -> dict {
        if not self._initialized and method != "initialize" {
            # print("[McpClient] No session ID or not initialized, performing handshake...");
            init_res = self._send_http_raw("initialize", {
                "protocolVersion": "2024-11-05",
                "capabilities": {},
                "clientInfo": {"name": "jac-diagnostics", "version": "1.0.0"}
            });
            if "error" in init_res {
                return init_res;
            }
            # Handshake successful, session ID should be set now
            # Send initialized notification
            self._send_http_raw("notifications/initialized", {}, True);
            self._initialized = True;
        }
        return self._send_http_raw(method, params);
    }

    """Internal: Raw HTTP request via requests, captures session ID."""
    def _send_http_raw(method: str, params: dict, is_notification: bool = False) -> dict {
        msg = {
            "jsonrpc": "2.0",
            "method": method,
            "params": params
        };
        if not is_notification {
            msg["id"] = self._id_counter;
            self._id_counter += 1;
        }

        try {
            headers = {
                "Content-Type": "application/json",
                "Accept": "application/json"
            };
            if self._session_id {
                headers["mcp-session-id"] = self._session_id;
            }

            import requests;
            response = requests.post(self.url, json=msg, headers=headers, timeout=self.timeout);
            
            if "mcp-session-id" in response.headers {
                self._session_id = response.headers["mcp-session-id"];
            }

            body = response.text;
            if response.status_code >= 400 {
                return {"error": f"HTTP {response.status_code}: {body}"};
            }
            
            if not body.strip() {
                if is_notification {
                    return {"success": True};
                }
                return {"error": f"Empty response. Status: {response.status_code}"};
            }

            return response.json();
        } except Exception as e {
            return {"error": str(e)};
        }
    }

    def _write_msg(proc: Any, method: str, params: dict, is_notification: bool = False) -> None {
        msg = {
            "jsonrpc": "2.0",
            "method": method,
            "params": params
        };
        if not is_notification {
            msg["id"] = self._id_counter;
            self._id_counter += 1;
        }
        proc.stdin.write(json.dumps(msg) + "\n");
        proc.stdin.flush();
    }

    def _read_msg(proc: Any) -> dict {
        line = proc.stdout.readline();
        if not line {
            err = proc.stderr.read();
            return {"error": f"No response from server. Stderr: {err}"};
        }
        return json.loads(line);
    }
}

# Helper methods to match MCP spec
def list_tools(mcp: McpClient) -> dict {
    return mcp.send_request("tools/list", {});
}

def call_tool(mcp: McpClient, name: str, args: dict) -> dict {
    return mcp.send_request("tools/call", {"name": name, "arguments": args});
}

def list_resources(mcp: McpClient) -> dict {
    return mcp.send_request("resources/list", {});
}

def read_resource(mcp: McpClient, uri: str) -> dict {
    return mcp.send_request("resources/read", {"uri": uri});
}

def list_prompts(mcp: McpClient) -> dict {
    return mcp.send_request("prompts/list", {});
}

def get_prompt(mcp: McpClient, name: str, args: dict) -> dict {
    return mcp.send_request("prompts/get", {"name": name, "arguments": args});
}
