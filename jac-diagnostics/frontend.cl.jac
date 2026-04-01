"""Jac-Diagnostics Frontend Logic.

Reactive UI for the diagnostic dashboard.
"""

sv import from backend { 
    validate_code, 
    run_stress_suite, 
    test_all_tools,
    ai_ask
}

def:pub app -> any {
    has message: str = "Jac-Diagnostics Dashboard",
        jacCode: str = "",
        validationResult: dict = {},
        stressResult: dict = {},
        inventoryResult: dict = {},
        transport: str = "stdio",
        loading: bool = False,
        # AI State
        aiQuery: str = "",
        aiAnswer: str = "",
        aiLoading: bool = False;

    async def handleValidate -> None;
    async def handleRunStress -> None;
    async def handleRunInventory -> None;
    async def handleTransportChange(e: any) -> None;
    async def handleAiAsk -> None;

    # Event Handlers
    def onCodeChange(e: any) -> None {
        jacCode = e.target.value;
    }

    def onAiQueryChange(e: any) -> None {
        aiQuery = e.target.value;
    }

    def onAiKeyPress(e: any) -> None {
        if e.key == "Enter" {
            handleAiAsk();
        }
    }

    # Pre-computed conditional UI elements
    # 1. Validation Section
    valBtnText = "Communicating..." if loading else "Validate Jac";
    valView = <div></div>;
    if validationResult.status {
        bgColor = "#f0fdf4" if validationResult.status == "success" else "#fef2f2";
        textColor = "#166534" if validationResult.status == "success" else "#991b1b";
        valView = <div style={{"marginTop": "1.5rem", "padding": "1rem", "backgroundColor": bgColor, "borderRadius": "0.5rem", "border": "1px solid #e2e8f0"}}>
            <h3 style={{"fontSize": "0.875rem", "fontWeight": "700", "color": textColor, "marginBottom": "0.5rem"}}>
                Result: {validationResult.status} (via {validationResult.transport_used})
            </h3>
            <pre style={{"fontSize": "0.75rem", "color": "#1e293b", "whiteSpace": "pre-wrap"}}>
                {JSON.stringify(validationResult.mcp_response)}
            </pre>
        </div>;
    }

    # 2. Inventory Section
    invView = <div></div>;
    if inventoryResult.status {
        invView = <div style={{"marginTop": "1rem", "fontSize": "0.875rem", "color": "#166534", "padding": "0.5rem", "backgroundColor": "#f0fdf4", "borderRadius": "0.25rem"}}>
            Inventory Check: Verified.
        </div>;
    }

    # 3. AI Section
    aiBtnText = "Thinking..." if aiLoading else "Ask Assistant";
    aiChatView = <p style={{"color": "#94a3b8", "textAlign": "center", "marginTop": "2rem"}}>Ask Gemini about Jac syntax.</p>;
    if aiAnswer {
        aiChatView = <div style={{"fontSize": "0.9375rem", "lineHeight": "1.5", "color": "#334155"}}>
            <div style={{"fontWeight": "600", "marginBottom": "0.5rem", "color": "#4f46e5"}}>Gemini:</div>
            <div style={{"whiteSpace": "pre-wrap"}}>{aiAnswer}</div>
        </div>;
    }

    return 
        <div 
            style={{
                "padding": "2rem",
                "maxWidth": "80rem",
                "margin": "0 auto",
                "fontFamily": "system-ui, -apple-system, sans-serif",
                "backgroundColor": "#f8fafc",
                "minHeight": "100vh"
            }}
        >
            <header style={{"marginBottom": "2rem", "borderBottom": "2px solid #e2e8f0", "paddingBottom": "1rem", "display": "flex", "justifyContent": "space-between", "alignItems": "center"}}>
                <div>
                    <h1 style={{"fontSize": "2rem", "fontWeight": "800", "color": "#1e293b", "letterSpacing": "-0.025em"}}>{message}</h1>
                    <p style={{"color": "#64748b", "marginTop": "0.25rem"}}>Phase 2/3: Exhaustive Testing & AI Diagnostics</p>
                </div>
                <div style={{"display": "flex", "alignItems": "center", "gap": "1rem", "backgroundColor": "white", "padding": "0.5rem 1rem", "borderRadius": "0.5rem", "boxShadow": "0 1px 2px 0 rgba(0, 0, 0, 0.05)"}}>
                    <span style={{"fontSize": "0.875rem", "fontWeight": "600", "color": "#64748b"}}>Active Transport:</span>
                    <select 
                        value={transport}
                        onChange={handleTransportChange}
                        style={{"padding": "0.25rem 0.5rem", "borderRadius": "0.375rem", "border": "1px solid #cbd5e1", "fontSize": "0.875rem", "fontWeight": "600"}}
                    >
                        <option value="stdio">stdio (Local Pipe)</option>
                        <option value="sse">sse (Streaming)</option>
                        <option value="http">http (Request/Response)</option>
                    </select>
                </div>
            </header>
            
            <main 
                style={{
                    "display": "grid",
                    "gridTemplateColumns": "1fr 1fr",
                    "gap": "2rem"
                }}
            >
                <div style={{"display": "flex", "flexDirection": "column", "gap": "2rem"}}>
                    <section style={{"padding": "1.5rem", "backgroundColor": "white", "borderRadius": "1rem", "boxShadow": "0 4px 6px -1px rgba(0, 0, 0, 0.1)", "border": "1px solid #e2e8f0"}}>
                        <h2 style={{"fontSize": "1.25rem", "fontWeight": "700", "marginBottom": "1.25rem", "color": "#334155"}}>Compiler Sandbox</h2>
                        <textarea 
                            style={{
                                "width": "100%",
                                "height": "15rem",
                                "padding": "1rem",
                                "border": "1px solid #e2e8f0",
                                "borderRadius": "0.5rem",
                                "fontFamily": "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace",
                                "fontSize": "0.875rem",
                                "backgroundColor": "#f8fafc",
                                "color": "#1e293b"
                            }}
                            placeholder="Type Jac code here..."
                            value={jacCode}
                            onChange={onCodeChange}
                        ></textarea>
                        <div style={{"display": "flex", "gap": "1rem", "marginTop": "1rem"}}>
                            <button 
                                style={{
                                    "flex": "1",
                                    "padding": "0.75rem 1rem",
                                    "backgroundColor": "#4f46e5",
                                    "color": "white",
                                    "borderRadius": "0.5rem",
                                    "border": "none",
                                    "fontWeight": "600",
                                    "cursor": "pointer"
                                }}
                                onClick={handleValidate}
                                disabled={loading}
                            >
                                {valBtnText}
                            </button>
                        </div>
                        {valView}
                    </section>

                    <section style={{"padding": "1.5rem", "backgroundColor": "white", "borderRadius": "1rem", "boxShadow": "0 4px 6px -1px rgba(0, 0, 0, 0.1)", "border": "1px solid #e2e8f0"}}>
                        <h2 style={{"fontSize": "1.25rem", "fontWeight": "700", "marginBottom": "1.25rem", "color": "#334155"}}>Ecosystem Testing</h2>
                        <div style={{"display": "grid", "gridTemplateColumns": "1fr 1fr", "gap": "1rem"}}>
                            <button 
                                style={{
                                    "padding": "0.75rem",
                                    "border": "2px solid #4f46e5",
                                    "color": "#4f46e5",
                                    "backgroundColor": "white",
                                    "borderRadius": "0.5rem",
                                    "fontWeight": "600",
                                    "cursor": "pointer"
                                }}
                                onClick={handleRunInventory}
                            >
                                Test All 9 Tools
                            </button>
                            <button 
                                style={{
                                    "padding": "0.75rem",
                                    "border": "2px solid #64748b",
                                    "color": "#64748b",
                                    "backgroundColor": "white",
                                    "borderRadius": "0.5rem",
                                    "fontWeight": "600",
                                    "cursor": "pointer",
                                    "opacity": "0.5"
                                }}
                                disabled={True}
                            >
                                Stress Suite
                            </button>
                        </div>
                        {invView}
                    </section>
                </div>

                <div style={{"display": "flex", "flexDirection": "column", "gap": "2rem"}}>
                    <section style={{"padding": "1.5rem", "backgroundColor": "white", "borderRadius": "1rem", "boxShadow": "0 10px 15px -3px rgba(0, 0, 0, 0.1)", "border": "1px solid #e2e8f0", "height": "100%", "display": "flex", "flexDirection": "column"}}>
                        <h2 style={{"fontSize": "1.25rem", "fontWeight": "700", "marginBottom": "1.25rem", "color": "#4f46e5", "display": "flex", "alignItems": "center", "gap": "0.5rem"}}>
                            AI Diagnostic Assistant
                        </h2>
                        
                        <div style={{"flex": "1", "backgroundColor": "#f1f5f9", "borderRadius": "0.75rem", "padding": "1.25rem", "marginBottom": "1.25rem", "overflowY": "auto", "maxHeight": "30rem"}}>
                            {aiChatView}
                        </div>

                        <div style={{"display": "flex", "flexDirection": "column", "gap": "1rem"}}>
                            <input 
                                style={{
                                    "padding": "0.75rem 1rem",
                                    "border": "1px solid #e2e8f0",
                                    "borderRadius": "0.5rem",
                                    "fontSize": "0.875rem"
                                }}
                                placeholder="E.g., How do I declare a walker?"
                                value={aiQuery}
                                onChange={onAiQueryChange}
                                onKeyPress={onAiKeyPress}
                            />
                            <button 
                                style={{
                                    "padding": "0.75rem",
                                    "backgroundColor": "#1e293b",
                                    "color": "white",
                                    "borderRadius": "0.5rem",
                                    "fontWeight": "600",
                                    "cursor": "pointer"
                                }}
                                onClick={handleAiAsk}
                                disabled={aiLoading}
                            >
                                {aiBtnText}
                            </button>
                        </div>
                    </section>
                </div>
            </main>

            <footer style={{"marginTop": "3rem", "padding": "1.5rem", "borderTop": "1px solid #e2e8f0", "fontSize": "0.875rem", "color": "#64748b", "display": "flex", "justifyContent": "space-between"}}>
                <span>Connected via {transport}</span>
                <span>reports/ecosystem_errors.md</span>
            </footer>
        </div>;
}
