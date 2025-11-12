# RV32I Pseudo Instructions Test
# Reference: RISC-V Assembly Programmer's Manual
# Tests common pseudo-instructions that map to base instructions

.globl _start
.section .text

_start:
    # Pseudo-instructions are convenience mnemonics for common instruction patterns
    # They are assembled into actual RV32I base instructions
    
    # NOP - no operation
    # Expands to: addi x0, x0, 0
    nop
    
    # LI - load immediate
    # Can expand to lui/addi or just addi depending on value
    li a0, 42               # Simple immediate
    li a1, 0x12345          # Larger immediate (uses lui + addi)
    li a2, -1               # Negative immediate
    li a3, 0                # Zero
    
    # MV - move/copy register
    # Expands to: addi rd, rs, 0
    mv t0, a0               # t0 = a0
    mv t1, a1               # t1 = a1
    
    # NOT - bitwise NOT
    # Expands to: xori rd, rs, -1
    li s0, 0x0F0F0F0F
    not s1, s0              # s1 = ~s0
    
    # NEG - negate
    # Expands to: sub rd, x0, rs
    li s2, 42
    neg s3, s2              # s3 = -42
    
    # SEQZ - set if equal to zero
    # Expands to: sltiu rd, rs, 1
    li t0, 0
    seqz t1, t0             # t1 = (t0 == 0) ? 1 : 0
    li t2, 5
    seqz t3, t2             # t3 = (t2 == 0) ? 1 : 0
    
    # SNEZ - set if not equal to zero
    # Expands to: sltu rd, x0, rs
    li t4, 0
    snez t5, t4             # t5 = (t4 != 0) ? 1 : 0
    li t6, 5
    snez a4, t6             # a4 = (t6 != 0) ? 1 : 0
    
    # SLTZ - set if less than zero
    # Expands to: slt rd, rs, x0
    li s4, -5
    sltz s5, s4             # s5 = (s4 < 0) ? 1 : 0
    li s6, 5
    sltz s7, s6             # s7 = (s6 < 0) ? 1 : 0
    
    # SGTZ - set if greater than zero
    # Expands to: slt rd, x0, rs
    li s8, 5
    sgtz s9, s8             # s9 = (s8 > 0) ? 1 : 0
    li s10, -5
    sgtz s11, s10           # s11 = (s10 > 0) ? 1 : 0
    
    # Branch pseudo-instructions
    
    # BEQZ - branch if equal to zero
    # Expands to: beq rs, x0, offset
    li a5, 0
    beqz a5, beqz_taken
    li a6, 1                # Should not execute
    j beqz_end
beqz_taken:
    li a6, 2
beqz_end:
    
    # BNEZ - branch if not equal to zero
    # Expands to: bne rs, x0, offset
    li a7, 5
    bnez a7, bnez_taken
    li s0, 1                # Should not execute
    j bnez_end
bnez_taken:
    li s0, 2
bnez_end:
    
    # BLEZ - branch if less than or equal to zero
    # Expands to: bge x0, rs, offset
    li s1, -5
    blez s1, blez_taken
    li s2, 1                # Should not execute
    j blez_end
blez_taken:
    li s2, 2
blez_end:
    
    # BGEZ - branch if greater than or equal to zero
    # Expands to: bge rs, x0, offset
    li s3, 5
    bgez s3, bgez_taken
    li s4, 1                # Should not execute
    j bgez_end
bgez_taken:
    li s4, 2
bgez_end:
    
    # BLTZ - branch if less than zero
    # Expands to: blt rs, x0, offset
    li s5, -5
    bltz s5, bltz_taken
    li s6, 1                # Should not execute
    j bltz_end
bltz_taken:
    li s6, 2
bltz_end:
    
    # BGTZ - branch if greater than zero
    # Expands to: blt x0, rs, offset
    li s7, 5
    bgtz s7, bgtz_taken
    li s8, 1                # Should not execute
    j bgtz_end
bgtz_taken:
    li s8, 2
bgtz_end:
    
    # BGT - branch if greater than (signed)
    # Expands to: blt rs2, rs1, offset
    li t0, 10
    li t1, 5
    bgt t0, t1, bgt_taken
    li t2, 1
    j bgt_end
bgt_taken:
    li t2, 2
bgt_end:
    
    # BLE - branch if less than or equal (signed)
    # Expands to: bge rs2, rs1, offset
    li t3, 5
    li t4, 10
    ble t3, t4, ble_taken
    li t5, 1
    j ble_end
ble_taken:
    li t5, 2
ble_end:
    
    # BGTU - branch if greater than (unsigned)
    # Expands to: bltu rs2, rs1, offset
    li t6, 0xFFFFFFFF       # Large unsigned value
    li a0, 100
    bgtu t6, a0, bgtu_taken
    li a1, 1
    j bgtu_end
bgtu_taken:
    li a1, 2
bgtu_end:
    
    # BLEU - branch if less than or equal (unsigned)
    # Expands to: bgeu rs2, rs1, offset
    li a2, 5
    li a3, 10
    bleu a2, a3, bleu_taken
    li a4, 1
    j bleu_end
bleu_taken:
    li a4, 2
bleu_end:
    
    # J - unconditional jump
    # Expands to: jal x0, offset
    j jump_target
    li a5, 1                # Should not execute
jump_target:
    li a5, 2
    
    # JR - jump register
    # Expands to: jalr x0, 0(rs)
    la t0, jr_target
    jr t0
    li a6, 1                # Should not execute
jr_target:
    li a6, 2
    
    # RET - return from subroutine
    # Expands to: jalr x0, 0(x1)
    jal ra, test_ret
    j after_ret
test_ret:
    li a7, 3
    ret                     # Returns to after jal
after_ret:
    
    # CALL - call far-away subroutine
    # Can expand to: auipc x1, offset[31:12]; jalr x1, x1, offset[11:0]
    # or just: jal x1, offset
    call test_call
    j after_call
test_call:
    li s9, 4
    ret
after_call:
    
    # TAIL - tail call
    # Similar to call but uses x6 instead of x1
    # For this test, we'll just use a simple version
    
    # LA - load address
    # Expands to: auipc rd, offset[31:12]; addi rd, rd, offset[11:0]
    la s10, test_data
    lw s11, 0(s10)
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall

.section .data
test_data:
    .word 0x12345678
