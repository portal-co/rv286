#!/bin/bash
# Test RV32I corpus with rv286 recompiler
# Note: rv286 only supports RV32I, so this script only tests RV32I binaries
# Other ISA variants (RV32IM, RV32IMA, RV64I, etc.) are not tested with rv286

set -e

echo "=== Testing RV32I Corpus with rv286 ==="
echo "Note: Only testing RV32I (rv286 does not support other ISA variants)"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

success=0
total=0
failures=()

for test in corpus/rv32i/0*; do
    # Skip .s source files
    if [ "${test%.s}" != "$test" ]; then
        continue
    fi
    
    if [ ! -f "$test" ]; then
        continue
    fi
    
    testname=$(basename "$test")
    total=$((total + 1))
    
    echo -n "Testing $testname... "
    
    # Try to recompile with rv286
    output_x86="${test}.x86"
    if ./rv286.sh "$test" "$output_x86" 2>/tmp/rv286_error_$$.txt >/dev/null; then
        if [ -f "$output_x86" ]; then
            echo -e "${GREEN}✓ Recompiled${NC}"
            success=$((success + 1))
            rm -f "$output_x86"  # Clean up
        else
            echo -e "${YELLOW}⚠ Recompiled but no output${NC}"
            failures+=("$testname: no output file")
            cat /tmp/rv286_error_$$.txt
        fi
    else
        echo -e "${RED}✗ Failed${NC}"
        failures+=("$testname: recompilation failed")
        if [ -f /tmp/rv286_error_$$.txt ]; then
            echo -e "${BLUE}Error output:${NC}"
            cat /tmp/rv286_error_$$.txt
        fi
    fi
    
    rm -f /tmp/rv286_error_$$.txt
done

echo ""
echo "=== Test Summary ==="
echo "Successful: $success/$total"

if [ ${#failures[@]} -gt 0 ]; then
    echo ""
    echo "Failures:"
    for failure in "${failures[@]}"; do
        echo "  - $failure"
    done
    exit 1
else
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
