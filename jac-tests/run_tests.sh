#!/bin/bash

# Configuration
TEST_DIRS=("language_basics" "types_and_values" "variables_and_scope" "operators" "control_flow" "native")
BASE_LOG_DIR="error_logs"

echo "======================================"
echo "Running All Jaseci Breakage Tests"
echo "======================================"

for TEST_DIR in "${TEST_DIRS[@]}"; do
    LOG_DIR="$BASE_LOG_DIR/$TEST_DIR"
    mkdir -p "$LOG_DIR"
    
    echo "--- Section: $TEST_DIR ---"
    
    # Support both .jac and .na.jac
    for file in "$TEST_DIR"/*.jac "$TEST_DIR"/*.na.jac; do
        if [ ! -f "$file" ]; then continue; fi
        filename=$(basename -- "$file")
        
        # Skip .na.jac if it's an annex sibling
        if [[ "$filename" == *.na.jac ]] && [ -f "$TEST_DIR/${filename%.na.jac}.jac" ]; then
            continue
        fi

        echo "Running test: $filename"
        
        # Special case for nacompile test
        if [[ "$filename" == *"standalone"* ]]; then
             jac nacompile "$file" > "$LOG_DIR/${filename}_compile.log" 2>&1
             echo " -> Native compilation log: $LOG_DIR/${filename}_compile.log"
        fi

        # Execute jac run
        jac run "$file" > "$LOG_DIR/${filename}.log" 2>&1
        echo " -> Execution log: $LOG_DIR/${filename}.log"
    done
done
done

echo ""
echo "All files executed! Logs stored in $BASE_LOG_DIR"
