# RV32IM Multiply and Divide Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Chapter 7
# "The 'M' standard extension for integer multiplication and division"

.globl _start
.section .text

_start:
    # Chapter 7: RV32M Standard Extension
    # "The RV32M extension adds instructions to multiply and divide values
    # held in the integer register file."
    
    # Section 7.1: Multiplication Operations
    # "MUL performs an XLEN-bit×XLEN-bit multiplication and places the
    # lower XLEN bits in the destination register."
    li a0, 10
    li a1, 20
    mul a2, a0, a1          # a2 = 200
    
    # Test with negative numbers
    li t0, -5
    li t1, 6
    mul t2, t0, t1          # t2 = -30
    
    # Test overflow case (result > 32 bits)
    li t3, 0x10000
    li t4, 0x10000
    mul t5, t3, t4          # t5 = 0 (lower 32 bits)
    
    # "MULH, MULHU, and MULHSU perform the same multiplication but
    # return the upper XLEN bits of the full 2×XLEN-bit product"
    
    # MULH: signed × signed, upper bits
    li s0, -5
    li s1, 6
    mulh s2, s0, s1         # s2 = upper 32 bits of (-5 * 6)
    
    # MULHU: unsigned × unsigned, upper bits
    li s3, 0xFFFFFFFF       # Max unsigned 32-bit
    li s4, 2
    mulhu s5, s3, s4        # s5 = upper 32 bits
    
    # "MULHSU performs a signed rs1 × unsigned rs2 multiplication"
    li s6, -1               # Signed -1
    li s7, 2                # Unsigned 2
    mulhsu s8, s6, s7       # s8 = upper 32 bits of signed×unsigned
    
    # Test large multiplication
    li a3, 0x7FFFFFFF       # Max positive int
    li a4, 2
    mul a5, a3, a4          # Lower bits
    mulh a6, a3, a4         # Upper bits
    
    # Section 7.2: Division Operations
    # "DIV and DIVU perform signed and unsigned integer division of
    # XLEN bits by XLEN bits. REM and REMU provide the remainder."
    
    # Basic division
    li t0, 100
    li t1, 10
    div t2, t0, t1          # t2 = 10
    rem t3, t0, t1          # t3 = 0
    
    # Division with remainder
    li t4, 100
    li t5, 7
    div t6, t4, t5          # t6 = 14
    rem a7, t4, t5          # a7 = 2
    
    # "The quotient of division by zero has all bits set, i.e. 2^XLEN−1
    # for unsigned division or −1 for signed division."
    li s0, 100
    li s1, 0
    div s2, s0, s1          # s2 = -1 (all bits set)
    divu s3, s0, s1         # s3 = 0xFFFFFFFF
    
    # "The remainder of division by zero equals the dividend."
    rem s4, s0, s1          # s4 = 100
    remu s5, s0, s1         # s5 = 100
    
    # Signed division with negative numbers
    li a0, -100
    li a1, 10
    div a2, a0, a1          # a2 = -10
    rem a3, a0, a1          # a3 = 0
    
    li a4, -100
    li a5, 7
    div a6, a4, a5          # a6 = -14
    rem a7, a4, a5          # a7 = -2 (remainder has sign of dividend)
    
    # Unsigned division
    li t0, 0xFFFFFFFF       # Max unsigned value
    li t1, 2
    divu t2, t0, t1         # t2 = 0x7FFFFFFF
    remu t3, t0, t1         # t3 = 1
    
    # Test overflow case for signed division
    # "The quotient of signed division with overflow is equal to the
    # dividend. The remainder of signed division with overflow is zero."
    # Overflow occurs with MIN_INT / -1
    li s6, 0x80000000       # MIN_INT
    li s7, -1
    div s8, s6, s7          # s8 = 0x80000000 (overflow)
    rem s9, s6, s7          # s9 = 0
    
    # More unsigned division tests
    li t4, 1000
    li t5, 3
    divu t6, t4, t5         # t6 = 333
    remu a0, t4, t5         # a0 = 1
    
    # Division resulting in zero
    li a1, 5
    li a2, 100
    div a3, a1, a2          # a3 = 0 (5 / 100 = 0)
    rem a4, a1, a2          # a4 = 5
    
    # Chained multiply and divide
    li s0, 10
    li s1, 5
    li s2, 3
    mul s3, s0, s1          # s3 = 50
    div s4, s3, s2          # s4 = 16
    rem s5, s3, s2          # s5 = 2
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall
