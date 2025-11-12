# RV32I NOP and Hint Instructions Test
# Reference: RISC-V Unprivileged ISA Specification, Section 2.8
# "The NOP instruction does not change any user-visible state"

.globl _start
.section .text

_start:
    # Section 2.8: NOP Instruction
    # "The NOP instruction does not change any user-visible state, except
    # for advancing the pc and incrementing any applicable performance
    # counters. NOP is encoded as ADDI x0, x0, 0."
    nop
    nop
    nop
    
    # Test that NOP truly doesn't affect registers
    li a0, 42
    nop
    mv a1, a0               # a1 should still be 42
    
    # Multiple NOPs in sequence
    li t0, 1
    nop
    nop
    nop
    nop
    nop
    li t1, 2
    add t2, t0, t1          # t2 = 3
    
    # Section 2.8: Hint Instructions
    # "A small number of RISC-V instructions have been allocated to the
    # HINT space, which can be used to convey information to the
    # microarchitecture. The instructions typically perform a NOP-like
    # operation if not supported by the implementation."
    
    # These are encoded as various register-immediate instructions with x0 as destination
    # They should behave as NOPs
    addi x0, x0, 1          # Hint: could signal performance hints
    addi x0, a0, 0          # Hint
    ori x0, a1, 0           # Hint
    
    # Test that hints don't affect actual computation
    li s0, 100
    addi x0, s0, 5          # This is a hint, s0 unchanged
    mv s1, s0               # s1 = 100
    
    # Test zero register behavior
    # "Register x0 is hardwired with all bits equal to 0. Writes to x0
    # are ignored, and reads from x0 always return 0."
    li a0, 999
    addi x0, a0, 0          # Attempt to write to x0 (ignored)
    mv a1, x0               # a1 = 0 (x0 always returns 0)
    
    # More zero register tests
    add x0, a0, a0          # Writing to x0 is ignored
    or x0, a0, a0           # Writing to x0 is ignored
    sub x0, a0, a0          # Writing to x0 is ignored
    
    # Reading from x0
    add a2, x0, a0          # a2 = 0 + a0 = a0
    sub a3, a0, x0          # a3 = a0 - 0 = a0
    or a4, x0, a0           # a4 = 0 | a0 = a0
    and a5, x0, a0          # a5 = 0 & a0 = 0
    
    # Test NOP equivalents
    addi x0, x0, 0          # Official NOP encoding
    addi x1, x1, 0          # MV-like NOP (no-op copy)
    
    # Test with branches that shouldn't be taken
    li t0, 5
    li t1, 10
    beq t0, t1, skip_nops   # Should not branch
    nop
    nop
    nop
skip_nops:
    
    # Test alignment and spacing with NOPs
    li s2, 1
    nop
    li s3, 2
    nop
    nop
    li s4, 3
    nop
    nop
    nop
    li s5, 4
    
    # Verify all values are correct
    add s6, s2, s3          # s6 = 3
    add s7, s4, s5          # s7 = 7
    add s8, s6, s7          # s8 = 10
    
    # Exit
    li a7, 93               # sys_exit
    li a0, 0
    ecall
