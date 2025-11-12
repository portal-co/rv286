# RV32I Edge Cases and Corner Cases Test
# Tests for overflow, underflow, and boundary conditions
# Reference: RISC-V Unprivileged ISA Specification, Section 2.4

.globl _start
.section .text

_start:
    # Section 2.4.1: "Arithmetic overflow is ignored and the result is
    # simply the low XLEN bits of the result"
    
    # Test integer overflow with ADDI
    li t0, 0x7FFFFFFF       # MAX_INT32
    addi t1, t0, 1          # Should wrap to 0x80000000 (MIN_INT32)
    
    # Test integer underflow with ADDI
    li t2, 0x80000000       # MIN_INT32
    addi t3, t2, -1         # Should wrap to 0x7FFFFFFF (MAX_INT32)
    
    # Test ADD overflow
    li a0, 0x7FFFFFFF
    li a1, 0x7FFFFFFF
    add a2, a0, a1          # Should produce negative result
    
    # Test SUB underflow
    li a3, 0x80000000
    li a4, 1
    sub a5, a3, a4          # Should wrap around
    
    # Test with zero register
    # "Register x0 is hardwired with all bits equal to 0"
    li t0, 42
    add t1, t0, zero        # t1 = t0
    add t2, zero, t0        # t2 = t0
    add t3, zero, zero      # t3 = 0
    
    # Test shift operations with edge values
    # Maximum shift amount (31 for RV32)
    li s0, 0x80000000
    li s1, 31
    srl s2, s0, s1          # Should shift to 1
    sra s3, s0, s1          # Should shift to -1 (all 1s)
    
    # Test shift by 0
    li s4, 0x12345678
    li s5, 0
    sll s6, s4, s5          # Should be unchanged
    
    # Test shifts that exceed 31 (should use only lower 5 bits)
    li t4, 0xFFFFFFFF
    li t5, 32               # Treated as 0
    sll t6, t4, t5          # Should be unchanged
    
    li a6, 0xFFFFFFFF
    li a7, 33               # Treated as 1
    sll s7, a6, a7          # Should be 0xFFFFFFFE
    
    # Test SLTI/SLTIU with boundary values
    li t0, 0
    slti t1, t0, 1          # t1 = 1 (0 < 1)
    slti t2, t0, 0          # t2 = 0 (0 == 0)
    slti t3, t0, -1         # t3 = 0 (0 > -1 signed)
    
    # Test unsigned comparison edge cases
    li s0, 0xFFFFFFFF       # -1 signed, max unsigned
    li s1, 0
    sltu s2, s1, s0         # s2 = 1 (0 < max unsigned)
    sltu s3, s0, s1         # s3 = 0 (max > 0)
    
    # Test SLT with negative numbers
    li a0, -1
    li a1, -2
    slt a2, a0, a1          # a2 = 0 (-1 > -2)
    slt a3, a1, a0          # a3 = 1 (-2 < -1)
    
    # Test XOR special cases
    li t0, 0x12345678
    xor t1, t0, t0          # Should be 0 (x XOR x = 0)
    xor t2, t0, zero        # Should be unchanged
    
    # Test immediate value edge cases
    # Maximum positive immediate for I-type (2047)
    addi s4, zero, 2047
    # Minimum negative immediate for I-type (-2048)
    addi s5, zero, -2048
    
    # Test LUI with maximum value
    lui s6, 0xFFFFF         # Upper 20 bits all 1s
    
    # Test AUIPC with maximum offset
    auipc s7, 0xFFFFF
    
    # Test branches with equal values
    li t0, 42
    li t1, 42
    beq t0, t1, eq_taken
    li t2, 0
    j eq_end
eq_taken:
    li t2, 1
eq_end:
    
    # Test BNE with equal values (should not branch)
    bne t0, t1, ne_taken
    li t3, 1                # Should execute
    j ne_end
ne_taken:
    li t3, 0
ne_end:
    
    # Test BGE with equal values (should branch)
    bge t0, t1, ge_taken
    li t4, 0
    j ge_end
ge_taken:
    li t4, 1
ge_end:
    
    # Test BGEU with equal values (should branch)
    bgeu t0, t1, geu_taken
    li t5, 0
    j geu_end
geu_taken:
    li t5, 1
geu_end:
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall
