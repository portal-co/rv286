# RV32I Integer Computational Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Section 2.4
# "RV32I provides 47 instructions, consisting of integer computational
# instructions, control transfer instructions, and load/store instructions"

.globl _start
.section .text

_start:
    # Section 2.4.1: Integer Register-Immediate Instructions
    # "ADDI adds the sign-extended 12-bit immediate to register rs1.
    # Arithmetic overflow is ignored and the result is simply the low
    # XLEN bits of the result."
    li a0, 10
    addi a1, a0, 5          # a1 = 15
    addi a2, a0, -3         # a2 = 7
    addi a3, zero, 42       # a3 = 42 (pseudo-instruction using addi)
    
    # "SLTI (set less than immediate) places the value 1 in register rd
    # if register rs1 is less than the sign-extended immediate when both
    # are treated as signed numbers, else 0 is written to rd."
    li t0, -5
    slti t1, t0, 0          # t1 = 1 (negative < 0)
    slti t2, a0, 5          # t2 = 0 (10 >= 5)
    
    # "SLTIU is similar but compares the values as unsigned numbers"
    sltiu t3, t0, 10        # t3 = 0 (unsigned -5 is large)
    li t4, 5
    sltiu t5, t4, 10        # t5 = 1 (5 < 10 unsigned)
    
    # "ANDI, ORI, XORI are logical operations that perform bitwise AND,
    # OR, and XOR on register rs1 and the sign-extended 12-bit immediate"
    li s0, 0xFF
    andi s1, s0, 0x0F       # s1 = 0x0F
    ori s2, s0, 0x700       # s2 = 0x7FF (12-bit immediate limit)
    xori s3, s0, 0xAA       # s3 = 0x55
    
    # "SLLI is a logical left shift (zeros are shifted into the lower bits)"
    li s4, 1
    slli s5, s4, 4          # s5 = 16
    
    # "SRLI is a logical right shift (zeros are shifted into the upper bits)"
    li s6, 0x80000000
    srli s7, s6, 4          # s7 = 0x08000000
    
    # "SRAI is an arithmetic right shift (the original sign bit is copied
    # into the vacated upper bits)"
    srai s8, s6, 4          # s8 = 0xF8000000 (sign extended)
    
    # "LUI (load upper immediate) places the 20-bit U-immediate into
    # bits 31–12 of register rd and places zero in the lowest 12 bits."
    lui s9, 0x12345         # s9 = 0x12345000
    
    # "AUIPC (add upper immediate to pc) forms a 32-bit offset from
    # the 20-bit U-immediate, filling in the lowest 12 bits with zeros,
    # adds this offset to the pc, then places the result in register rd."
    auipc s10, 0            # s10 = PC
    
    # Section 2.4.2: Integer Register-Register Operations
    # "ADD performs the addition of rs1 and rs2. SUB performs the
    # subtraction of rs2 from rs1. Overflows are ignored and the result
    # is the low XLEN bits of the result."
    li t0, 100
    li t1, 50
    add t2, t0, t1          # t2 = 150
    sub t3, t0, t1          # t3 = 50
    
    # "SLL, SRL, and SRA perform logical left, logical right, and
    # arithmetic right shifts on the value in register rs1 by the shift
    # amount held in the lower 5 bits of register rs2."
    li t4, 1
    li t5, 3
    sll t6, t4, t5          # t6 = 8
    
    li a4, 0x80000000
    srl a5, a4, t5          # a5 = 0x10000000
    sra a6, a4, t5          # a6 = 0xF0000000
    
    # "SLT and SLTU perform signed and unsigned compares respectively"
    li a0, -5
    li a1, 10
    slt a2, a0, a1          # a2 = 1 (-5 < 10 signed)
    sltu a3, a0, a1         # a3 = 0 (unsigned -5 > 10)
    
    # "AND, OR, and XOR perform bitwise logical operations"
    li t0, 0xF0
    li t1, 0x0F
    and t2, t0, t1          # t2 = 0x00
    or t3, t0, t1           # t3 = 0xFF
    xor t4, t0, t1          # t4 = 0xFF
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall
