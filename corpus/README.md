# RiscV Assembly Test Corpus

A comprehensive test corpus of RiscV assembly programs for testing RiscV compilers, emulators, and recompilers like rv286.

## Overview

This corpus contains hand-written assembly tests targeting different RiscV instruction set configurations:
- **RV32I**: 32-bit base integer instruction set
- **RV64I**: 64-bit base integer instruction set  
- **RV32IM**: 32-bit with M extension (multiply/divide)
- **RV64IM**: 64-bit with M extension
- **RV32IMA**: 32-bit with M and A extensions (atomic operations)
- **RV64IMA**: 64-bit with M and A extensions

All tests are compiled using LLVM/Clang toolchain and include verbatim citations from the [RISC-V Unprivileged ISA Specification](https://docs.riscv.org/reference/isa/unpriv/unpriv-index.html) as comments.

## Test Organization

### RV32I Tests (corpus/rv32i/)
- **01_integer_computational.s**: Tests all integer computational instructions
  - Register-immediate operations (ADDI, SLTI, SLTIU, ANDI, ORI, XORI)
  - Shift operations (SLLI, SRLI, SRAI)
  - Upper immediate operations (LUI, AUIPC)
  - Register-register operations (ADD, SUB, SLL, SRL, SRA, SLT, SLTU, AND, OR, XOR)
  
- **02_control_transfer.s**: Tests control flow instructions
  - Unconditional jumps (JAL, JALR)
  - Conditional branches (BEQ, BNE, BLT, BLTU, BGE, BGEU)
  - Forward and backward branches
  
- **03_load_store.s**: Tests memory access instructions
  - Load operations (LW, LH, LHU, LB, LBU)
  - Store operations (SW, SH, SB)
  - Sign extension vs zero extension
  - Positive and negative offsets
  
- **04_edge_cases.s**: Tests boundary conditions and corner cases
  - Arithmetic overflow/underflow
  - Maximum/minimum values
  - Division by zero
  - Zero register behavior
  - Maximum shift amounts
  
- **05_simple_program.s**: Practical program examples
  - Recursive factorial calculation
  - Fibonacci sequence
  - Array sum
  - Demonstrates real-world instruction combinations

### RV32IM Tests (corpus/rv32im/)
- **01_multiply_divide.s**: Tests M extension instructions
  - Multiplication operations (MUL, MULH, MULHU, MULHSU)
  - Division operations (DIV, DIVU, REM, REMU)
  - Overflow and division by zero cases
  - Signed vs unsigned operations

### RV32IMA Tests (corpus/rv32ima/)
- **01_atomic_operations.s**: Tests A extension instructions
  - Load-reserved/store-conditional (LR.W, SC.W)
  - Atomic memory operations (AMOSWAP, AMOADD, AMOXOR, AMOAND, AMOOR)
  - Atomic min/max (AMOMIN, AMOMAX, AMOMINU, AMOMAXU)
  - Memory ordering annotations (acquire/release)
  - Fence instructions

### RV64I Tests (corpus/rv64i/)
- **01_basic_64bit.s**: Tests 64-bit specific instructions
  - 64-bit register operations
  - Word operations (ADDIW, SLLIW, SRLIW, SRAIW, ADDW, SUBW, SLLW, SRLW, SRAW)
  - 64-bit loads and stores (LD, SD, LWU)
  - Sign extension behavior in 64-bit mode

## Compilation

### Prerequisites
- LLVM/Clang with RiscV target support (version 10.0 or later)
- The tests have been written to compile with the LLVM toolchain

### Building the Corpus
```bash
cd corpus
./compile_corpus.sh
```

This will compile all tests and produce ELF binaries ready for execution or recompilation.

### Manual Compilation Examples
```bash
# RV32I test
clang --target=riscv32 -march=rv32i -mabi=ilp32 -nostdlib -static \
  rv32i/01_integer_computational.s -o rv32i/01_integer_computational

# RV32IM test
clang --target=riscv32 -march=rv32im -mabi=ilp32 -nostdlib -static \
  rv32im/01_multiply_divide.s -o rv32im/01_multiply_divide

# RV64I test  
clang --target=riscv64 -march=rv64i -mabi=lp64 -nostdlib -static \
  rv64i/01_basic_64bit.s -o rv64i/01_basic_64bit
```

## Testing with rv286

The rv286 recompiler currently supports RV32I. To test the RV32I corpus:

```bash
# From the repository root
for test in corpus/rv32i/0*; do
    if [ -f "$test" ] && [ ! "${test%.s}" = "$test" ]; then
        continue  # Skip .s files
    fi
    echo "Testing $test"
    python rv286.py "$test" > /tmp/test.asm
    nasm -f elf32 /tmp/test.asm -o /tmp/test.o
    ld -melf_i386 /tmp/test.o -o /tmp/test.x86
    # Run and compare output
done
```

## Specification References

All tests include citations from the RISC-V Unprivileged ISA Specification:
- **Chapter 2**: RV32I Base Integer Instruction Set
- **Chapter 5**: RV64I Base Integer Instruction Set  
- **Chapter 7**: "M" Standard Extension for Integer Multiplication and Division
- **Chapter 8**: "A" Standard Extension for Atomic Instructions

Each instruction test is documented with relevant specification quotes to ensure correctness.

## Test Status

| ISA Variant | Tests | Status | rv286 Support |
|-------------|-------|--------|---------------|
| RV32I       | 5     | ✓      | ✓             |
| RV32IM      | 1     | ✓      | ✗             |
| RV32IMA     | 1     | ✓      | ✗             |
| RV64I       | 1     | ✓      | ✗             |
| RV64IM      | 0     | -      | ✗             |
| RV64IMA     | 0     | -      | ✗             |

## Known Issues

When testing with rv286, any failures will be documented here:

### Test Results
(To be filled in after running tests)

## Future Work

- Add more complex RV64I tests
- Add RV64IM and RV64IMA tests
- Add tests for CSR instructions
- Add tests for trap handling
- Add performance benchmarks
- Add tests for compressed instructions (C extension)
- Add tests for floating-point extensions (F, D)

## Contributing

When adding new tests:
1. Follow the naming convention: `XX_description.s`
2. Include specification citations as comments
3. Document the purpose and expected behavior
4. Test compilation with LLVM tools
5. Update this README with test descriptions

## License

This corpus is provided as part of the rv286 project. See the repository LICENSE file for details.
