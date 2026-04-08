#!/bin/bash

# Configuration
TEST_DIRS=("language_basics" "types_and_values" "variables_and_scope" "operators" "control_flow")
BASE_LOG_DIR="error_logs"

echo "======================================"
echo "Running All Jaseci Breakage Tests"
echo "======================================"

for TEST_DIR in "${TEST_DIRS[@]}"; do
    LOG_DIR="$BASE_LOG_DIR/$TEST_DIR"
    mkdir -p "$LOG_DIR"
    
    echo "--- Section: $TEST_DIR ---"
    
    for file in "$TEST_DIR"/*.jac; do
        if [ ! -f "$file" ]; then continue; fi
        filename=$(basename -- "$file")
        echo "Running test: $filename"
        
        # Execute jac run and capture stderr & stdout to the log file.
        if [ -f ".venv/bin/jac" ]; then
            .venv/bin/jac run "$file" > "$LOG_DIR/${filename}.log" 2>&1
        elif [ -f "../jac-diagnostics/jac-env/bin/jac" ]; then
            ../jac-diagnostics/jac-env/bin/jac run "$file" > "$LOG_DIR/${filename}.log" 2>&1
        else
            jac run "$file" > "$LOG_DIR/${filename}.log" 2>&1
        fi
        
        echo " -> Log produced: $LOG_DIR/${filename}.log"
    done
done

echo ""
echo "All files executed! Logs stored in $BASE_LOG_DIR"
