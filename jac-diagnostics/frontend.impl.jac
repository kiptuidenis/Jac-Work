"""Implementations for the Jac-Diagnostics frontend component."""

impl app.handleValidate -> None {
    if not jacCode.trim() {
        return;
    }
    loading = True;
    try {
        response = root spawn validate_code(code=jacCode, transport=transport);
        validationResult = response.reports[0] if response.reports else {"status": "error", "message": "No response from server"};
    } except Exception as e {
        validationResult = {"status": "error", "message": str(e)};
    }
    loading = False;
}

impl app.handleRunStress -> None {
    loading = True;
    try {
        response = root spawn run_stress_suite(transport=transport);
        stressResult = response.reports[0] if response.reports else {"status": "error"};
    } except Exception as e {
        stressResult = {"status": "error"};
    }
    loading = False;
}

impl app.handleRunInventory -> None {
    loading = True;
    try {
        response = root spawn test_all_tools(transport=transport);
        inventoryResult = response.reports[0] if response.reports else {"status": "error"};
    } except Exception as e {
        inventoryResult = {"status": "error"};
    }
    loading = False;
}

impl app.handleAiAsk -> None {
    if not aiQuery.trim() {
        return;
    }
    aiLoading = True;
    try {
        response = root spawn ai_ask(question=aiQuery, transport=transport);
        # Renamed report to ai_report and replaced .get() with standard indexing
        # to avoid Jac keyword conflict and JS runtime errors.
        ai_report = response.reports[0] if response.reports else {};
        if "answer" in ai_report {
            aiAnswer = ai_report["answer"];
        } else {
            aiAnswer = "No answer received from Gemini.";
        }
    } except Exception as e {
        aiAnswer = f"Error: {str(e)}";
    }
    aiLoading = False;
}

impl app.handleTransportChange(e: any) -> None {
    transport = e.target.value;
}
