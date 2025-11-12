# RV32I Load and Store Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Section 2.6
# "Load and store instructions transfer values between registers and memory"

.globl _start
.section .text

_start:
    # Section 2.6: Load and Store Instructions
    # "RV32I provides load and store instructions for 8-bit (byte),
    # 16-bit (halfword), and 32-bit (word) values. Loads are encoded
    # in the I-type format and stores are S-type."
    
    # Initialize base address
    la s0, test_data
    
    # "LW loads a 32-bit value from memory into rd. The effective address
    # is obtained by adding register rs1 to the sign-extended 12-bit offset."
    lw t0, 0(s0)            # Load word at test_data
    lw t1, 4(s0)            # Load word at test_data+4
    
    # "LH loads a 16-bit value from memory, then sign-extends to 32-bits
    # before storing in rd."
    lh t2, 0(s0)            # Load halfword (sign-extended)
    lh t3, 2(s0)            # Load another halfword
    
    # "LHU loads a 16-bit value from memory but zero extends to 32 bits."
    lhu t4, 0(s0)           # Load halfword (zero-extended)
    
    # "LB loads an 8-bit value from memory, then sign-extends to 32-bits."
    lb t5, 0(s0)            # Load byte (sign-extended)
    lb t6, 1(s0)            # Load another byte
    
    # "LBU loads an 8-bit value from memory but zero extends to 32 bits."
    lbu a0, 0(s0)           # Load byte (zero-extended)
    
    # "SW, SH, and SB store 32-bit, 16-bit, and 8-bit values from the
    # low bits of register rs2 to memory. The effective address is
    # obtained by adding register rs1 to the sign-extended 12-bit offset."
    
    # Test stores
    la s1, store_area
    
    # Store word
    li a1, 0x12345678
    sw a1, 0(s1)
    
    # Store halfword
    li a2, 0xABCD
    sh a2, 4(s1)
    
    # Store byte
    li a3, 0xEF
    sb a3, 6(s1)
    
    # Verify stores by loading back
    lw a4, 0(s1)            # Should be 0x12345678
    lh a5, 4(s1)            # Should be 0xFFFFABCD (sign-extended)
    lhu a6, 4(s1)           # Should be 0x0000ABCD (zero-extended)
    lb a7, 6(s1)            # Should be 0xFFFFFFEF (sign-extended)
    lbu s2, 6(s1)           # Should be 0x000000EF (zero-extended)
    
    # Test with negative offsets
    la s3, middle_data
    lw s4, -4(s3)           # Load word before middle_data
    lw s5, 0(s3)            # Load word at middle_data
    lw s6, 4(s3)            # Load word after middle_data
    
    # Test boundary cases
    li t0, 0xFF
    sb t0, 7(s1)
    lb t1, 7(s1)            # Should be -1 (sign-extended)
    lbu t2, 7(s1)           # Should be 255 (zero-extended)
    
    # Test with zero register
    sw zero, 8(s1)
    lw s7, 8(s1)            # Should be 0
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall

.section .data
test_data:
    .word 0x12345678
    .word 0x9ABCDEF0
middle_data:
    .word 0x11111111
    .word 0x22222222
    .byte 0x80, 0x7F, 0xFF, 0x00
    
.section .bss
store_area:
    .skip 64
