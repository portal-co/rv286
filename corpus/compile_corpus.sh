#!/bin/bash
# Compilation script for RiscV test corpus using LLVM tools
# Compiles RV32I, RV64I, and extension tests

set -e

CLANG="${CLANG:-clang}"
LLVM_OBJCOPY="${LLVM_OBJCOPY:-llvm-objcopy}"

echo "=== RiscV Test Corpus Compilation ==="
echo "Using LLVM toolchain: $CLANG"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

compile_test() {
    local src="$1"
    local arch="$2"
    local abi="$3"
    local output="${src%.s}"
    
    echo -n "Compiling $(basename "$src")... "
    
    if $CLANG --target=riscv32 -march="$arch" -mabi="$abi" \
        -nostdlib -static -Wl,-e_start \
        "$src" -o "$output" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC}"
        return 1
    fi
}

# Compile RV32I tests
echo ""
echo "=== Compiling RV32I Tests ==="
success=0
total=0
for test in corpus/rv32i/*.s; do
    total=$((total + 1))
    if compile_test "$test" "rv32i" "ilp32"; then
        success=$((success + 1))
    fi
done
echo "RV32I: $success/$total tests compiled successfully"

# Compile RV32IM tests
echo ""
echo "=== Compiling RV32IM Tests ==="
im_success=0
im_total=0
for test in corpus/rv32im/*.s; do
    im_total=$((im_total + 1))
    if compile_test "$test" "rv32im" "ilp32"; then
        im_success=$((im_success + 1))
    fi
done
echo "RV32IM: $im_success/$im_total tests compiled successfully"

# Compile RV32IMA tests
echo ""
echo "=== Compiling RV32IMA Tests ==="
ima_success=0
ima_total=0
for test in corpus/rv32ima/*.s; do
    ima_total=$((ima_total + 1))
    if compile_test "$test" "rv32ima" "ilp32"; then
        ima_success=$((ima_success + 1))
    fi
done
echo "RV32IMA: $ima_success/$ima_total tests compiled successfully"

# Compile RV64I tests
echo ""
echo "=== Compiling RV64I Tests ==="
rv64_success=0
rv64_total=0
for test in corpus/rv64i/*.s; do
    rv64_total=$((rv64_total + 1))
    if compile_test "$test" "rv64i" "lp64"; then
        rv64_success=$((rv64_success + 1))
    fi
done
echo "RV64I: $rv64_success/$rv64_total tests compiled successfully"

# Compile RV64IM tests
echo ""
echo "=== Compiling RV64IM Tests ==="
rv64im_success=0
rv64im_total=0
for test in corpus/rv64im/*.s; do
    rv64im_total=$((rv64im_total + 1))
    if compile_test "$test" "rv64im" "lp64"; then
        rv64im_success=$((rv64im_success + 1))
    fi
done
echo "RV64IM: $rv64im_success/$rv64im_total tests compiled successfully"

# Compile RV64IMA tests
echo ""
echo "=== Compiling RV64IMA Tests ==="
rv64ima_success=0
rv64ima_total=0
if [ -d corpus/rv64ima ] && [ "$(ls -A corpus/rv64ima/*.s 2>/dev/null)" ]; then
    for test in corpus/rv64ima/*.s; do
        [ -f "$test" ] || continue
        rv64ima_total=$((rv64ima_total + 1))
        if compile_test "$test" "rv64ima" "lp64"; then
            rv64ima_success=$((rv64ima_success + 1))
        fi
    done
    echo "RV64IMA: $rv64ima_success/$rv64ima_total tests compiled successfully"
else
    echo "RV64IMA: No tests found (directory empty or doesn't exist)"
fi

# Summary
echo ""
echo "=== Compilation Summary ==="
total_success=$((success + im_success + ima_success + rv64_success + rv64im_success + rv64ima_success))
total_tests=$((total + im_total + ima_total + rv64_total + rv64im_total + rv64ima_total))
echo "Total: $total_success/$total_tests tests compiled successfully"

if [ $total_success -eq $total_tests ]; then
    echo -e "${GREEN}All tests compiled successfully!${NC}"
    exit 0
else
    echo -e "${YELLOW}Some tests failed to compile${NC}"
    exit 1
fi
