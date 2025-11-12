# RV64I Basic 64-bit Operations Test
# Reference: RISC-V Unprivileged ISA Specification, Chapter 5
# "RV64I is a 64-bit base integer instruction set"

.globl _start
.section .text

_start:
    # Chapter 5: RV64I Base Integer Instruction Set
    # "RV64I extends RV32I with 64-bit wide integer registers"
    
    # Section 5.1: Register State
    # "RV64I widens the integer registers to 64 bits (XLEN=64)"
    
    # Test 64-bit immediate loading
    li a0, 0x123456789ABCDEF0   # 64-bit immediate
    
    # Section 5.2: Integer Computational Instructions
    # "ADDIW is an RV64I-only instruction that adds the sign-extended
    # 12-bit immediate to register rs1 and produces the proper sign
    # extension of a 32-bit result in rd."
    li t0, 0x0000000080000000
    addiw t1, t0, 10            # Adds 10 to lower 32 bits, sign-extends
    
    # "SLLIW, SRLIW, and SRAIW are RV64I-only instructions that are
    # analogous to SLLI, SRLI, and SRAI, but operate on 32-bit values
    # and sign-extend their 32-bit results to 64 bits."
    li t2, 0x0000000012345678
    slliw t3, t2, 4             # Shift lower 32 bits left by 4
    
    li t4, 0x00000000F0000000
    srliw t5, t4, 4             # Logical shift right lower 32 bits
    
    li t6, 0x00000000F0000000
    sraiw a0, t6, 4             # Arithmetic shift right lower 32 bits
    
    # "ADDW and SUBW are RV64I-only instructions that add/subtract
    # the lower 32 bits and sign-extend the result to 64 bits."
    li a1, 0x0000000012345678
    li a2, 0x00000000FFFFFFFF
    addw a3, a1, a2             # Add lower 32 bits, sign-extend
    
    li a4, 0x00000000FFFFFFFF
    li a5, 0x0000000000000001
    subw a6, a4, a5             # Subtract lower 32 bits
    
    # "SLLW, SRLW, and SRAW are RV64I-only instructions that perform
    # 32-bit shifts and sign-extend the result."
    li s0, 0x0000000000000001
    li s1, 4
    sllw s2, s0, s1             # 32-bit left shift
    
    li s3, 0x00000000F0000000
    li s4, 4
    srlw s5, s3, s4             # 32-bit logical right shift
    
    li s6, 0x00000000F0000000
    sraw s7, s6, s4             # 32-bit arithmetic right shift
    
    # Section 5.3: Load and Store Instructions
    # "RV64I extends the load/store instructions to support 64-bit
    # values with LD and SD instructions."
    
    la s8, test_data_64
    
    # "LD loads a 64-bit value from memory into register rd."
    ld s9, 0(s8)                # Load doubleword
    
    # "LW loads a 32-bit value and sign-extends to 64 bits."
    lw s10, 0(s8)               # Load word, sign-extend to 64
    
    # "LWU loads a 32-bit value and zero-extends to 64 bits."
    lwu s11, 0(s8)              # Load word unsigned (zero-extend)
    
    # Test stores
    la t0, store_area_64
    
    # "SD stores a 64-bit value from register rs2 to memory."
    li t1, 0xFEDCBA9876543210
    sd t1, 0(t0)                # Store doubleword
    
    # Verify with load
    ld t2, 0(t0)                # Should be 0xFEDCBA9876543210
    
    # Test 32-bit stores in 64-bit mode
    li t3, 0xFFFFFFFFDEADBEEF
    sw t3, 8(t0)                # Store lower 32 bits
    lw t4, 8(t0)                # Load back (sign-extended)
    lwu t5, 8(t0)               # Load unsigned (zero-extended)
    
    # Test sign extension behavior
    li a0, 0x0000000080000000   # Positive in upper, negative in lower
    addiw a1, a0, 0             # Sign extend lower 32 bits
    # a1 should be 0xFFFFFFFF80000000
    
    # Test zero extension
    li a2, 0xFFFFFFFF80000000   # Negative 64-bit value
    la t0, test_word
    lwu a3, 0(t0)               # Zero-extended load
    lw a4, 0(t0)                # Sign-extended load
    
    # Test 64-bit arithmetic overflow
    li s0, 0x7FFFFFFFFFFFFFFF   # MAX_INT64
    addi s1, s0, 1              # Should wrap to MIN_INT64
    
    # Test with large 64-bit values
    li s2, 0x0123456789ABCDEF
    li s3, 0x0FEDCBA987654321
    add s4, s2, s3              # 64-bit addition
    sub s5, s3, s2              # 64-bit subtraction
    
    # Test shifts with 64-bit values
    li t0, 1
    li t1, 32
    sll t2, t0, t1              # Shift to bit 32
    
    li t3, 0x8000000000000000
    li t4, 63
    srl t5, t3, t4              # Shift to LSB
    
    # Exit
    li a7, 93                   # sys_exit
    li a0, 0
    ecall

.section .data
.align 8
test_data_64:
    .dword 0x123456789ABCDEF0
    .dword 0xFEDCBA9876543210

test_word:
    .word 0xDEADBEEF

.section .bss
.align 8
store_area_64:
    .skip 64
