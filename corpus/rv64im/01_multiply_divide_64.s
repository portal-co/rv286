# RV64IM Multiply and Divide Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Chapter 7
# Tests 64-bit variants of M extension instructions

.globl _start
.section .text

_start:
    # Chapter 7.2: Multiplication Operations (64-bit)
    # "MULW is an RV64M-only instruction that multiples the lower 32 bits
    # of the source registers, placing the sign-extension of the lower
    # 32 bits of the result into the destination register."
    
    li a0, 0x00000000FFFFFFFF
    li a1, 2
    mulw a2, a0, a1         # Multiply lower 32 bits, sign-extend
    
    # Test with positive 32-bit values
    li t0, 100
    li t1, 200
    mulw t2, t0, t1         # t2 = 20000 (sign-extended to 64 bits)
    
    # Test with negative 32-bit values
    li t3, -10
    li t4, 20
    mulw t5, t3, t4         # t5 = -200 (sign-extended)
    
    # 64-bit multiplication with MUL
    li s0, 0x100000000
    li s1, 2
    mul s2, s0, s1          # s2 = 0x200000000
    
    # Test MULH with 64-bit values
    li s3, 0x7FFFFFFFFFFFFFFF   # Max positive int64
    li s4, 2
    mulh s5, s3, s4             # Upper 64 bits of signed multiply
    
    # Test MULHU with 64-bit values
    li s6, 0xFFFFFFFFFFFFFFFF   # Max unsigned int64
    li s7, 2
    mulhu s8, s6, s7            # Upper 64 bits of unsigned multiply
    
    # Test MULHSU with 64-bit values
    li s9, -1                   # -1 as signed
    li s10, 2
    mulhsu s11, s9, s10         # Upper 64 bits of signed×unsigned
    
    # Chapter 7.2: Division Operations (64-bit)
    # "DIVW and DIVUW perform 32-bit signed and unsigned division of the
    # 32-bit value in rs1 by the 32-bit value in rs2, sign-extending the
    # 32-bit result to 64 bits."
    
    # Basic 32-bit division
    li a3, 1000
    li a4, 10
    divw a5, a3, a4         # a5 = 100 (sign-extended)
    remw a6, a3, a4         # a6 = 0 (sign-extended)
    
    # Division with negative numbers
    li a7, -1000
    li t0, 10
    divw t1, a7, t0         # t1 = -100 (sign-extended)
    remw t2, a7, t0         # t2 = 0 (sign-extended)
    
    # Unsigned 32-bit division
    li t3, 0xFFFFFFFF       # Max uint32 in lower 32 bits
    li t4, 2
    divuw t5, t3, t4        # t5 = 0x7FFFFFFF (sign-extended)
    remuw t6, t3, t4        # t6 = 1 (sign-extended)
    
    # 64-bit division with DIV
    li s0, 0x100000000
    li s1, 2
    div s2, s0, s1          # s2 = 0x80000000
    rem s3, s0, s1          # s3 = 0
    
    # Test division by zero (32-bit)
    li s4, 100
    li s5, 0
    divw s6, s4, s5         # s6 = -1 (all bits set, sign-extended)
    divuw s7, s4, s5        # s7 = 0xFFFFFFFFFFFFFFFF
    remw s8, s4, s5         # s8 = 100 (sign-extended)
    remuw s9, s4, s5        # s9 = 100 (sign-extended)
    
    # Test division by zero (64-bit)
    li a0, 0x123456789ABCDEF0
    li a1, 0
    div a2, a0, a1          # a2 = -1 (all bits set)
    divu a3, a0, a1         # a3 = 0xFFFFFFFFFFFFFFFF
    rem a4, a0, a1          # a4 = 0x123456789ABCDEF0
    remu a5, a0, a1         # a5 = 0x123456789ABCDEF0
    
    # Test overflow in 32-bit division
    # MIN_INT32 / -1 should overflow
    li t0, 0x80000000       # MIN_INT32
    li t1, -1
    divw t2, t0, t1         # t2 = 0x80000000 (overflow case)
    remw t3, t0, t1         # t3 = 0
    
    # Test overflow in 64-bit division
    # MIN_INT64 / -1 should overflow
    li s10, 0x8000000000000000
    li s11, -1
    div t4, s10, s11        # t4 = 0x8000000000000000 (overflow)
    rem t5, s10, s11        # t5 = 0
    
    # Chained operations
    li a6, 1000
    li a7, 10
    divw t6, a6, a7         # t6 = 100
    li s0, 3
    divw s1, t6, s0         # s1 = 33
    remw s2, t6, s0         # s2 = 1
    
    # Test with large 64-bit values
    li s3, 0x1000000000000000
    li s4, 0x100000000
    div s5, s3, s4          # s5 = 0x10000000
    
    # Test unsigned operations with large values
    li s6, 0xFFFFFFFFFFFFFFFF
    li s7, 0x10
    divu s8, s6, s7
    remu s9, s6, s7
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall
