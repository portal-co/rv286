# RV32I Simple Practical Program
# A simple program that computes factorial and fibonacci
# Tests combination of instructions in real-world scenarios

.globl _start
.section .text

_start:
    # Compute factorial of 5 (5! = 120)
    li a0, 5
    jal ra, factorial
    # Result in a0
    mv s0, a0               # Save result
    
    # Compute fibonacci of 10
    li a0, 10
    jal ra, fibonacci
    # Result in a0
    mv s1, a0               # Save result
    
    # Test array sum
    la a0, test_array
    li a1, 5                # Array length
    jal ra, array_sum
    mv s2, a0               # Save result
    
    # Exit with result code
    li a7, 93               # sys_exit
    mv a0, s0               # Exit with factorial result
    ecall

# Factorial function
# Input: a0 = n
# Output: a0 = n!
factorial:
    # Save return address and argument
    addi sp, sp, -8
    sw ra, 4(sp)
    sw a0, 0(sp)
    
    # Base case: if n <= 1, return 1
    li t0, 1
    ble a0, t0, fact_base
    
    # Recursive case: n * factorial(n-1)
    addi a0, a0, -1
    jal ra, factorial       # Recursive call
    
    # Multiply result by n (using repeated addition for RV32I)
    lw t0, 0(sp)            # Load original n
    mv t1, a0               # Save result from recursive call
    mv a0, zero             # Initialize result
fact_mult_loop:
    beq t0, zero, fact_mult_done
    add a0, a0, t1          # Add result n times
    addi t0, t0, -1
    j fact_mult_loop
fact_mult_done:
    
    # Restore and return
    lw ra, 4(sp)
    addi sp, sp, 8
    jalr zero, ra, 0

fact_base:
    li a0, 1
    lw ra, 4(sp)
    addi sp, sp, 8
    jalr zero, ra, 0

# Fibonacci function
# Input: a0 = n
# Output: a0 = fib(n)
fibonacci:
    # Save registers
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw a0, 0(sp)
    
    # Base cases
    li t0, 1
    ble a0, t0, fib_base
    
    # Recursive case: fib(n-1) + fib(n-2)
    addi a0, a0, -1
    jal ra, fibonacci       # fib(n-1)
    mv s0, a0               # Save fib(n-1)
    
    lw a0, 0(sp)
    addi a0, a0, -2
    jal ra, fibonacci       # fib(n-2)
    mv s1, a0               # Save fib(n-2)
    
    add a0, s0, s1          # fib(n-1) + fib(n-2)
    
    # Restore and return
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    addi sp, sp, 16
    jalr zero, ra, 0

fib_base:
    lw a0, 0(sp)
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    addi sp, sp, 16
    jalr zero, ra, 0

# Array sum function
# Input: a0 = array pointer, a1 = length
# Output: a0 = sum
array_sum:
    mv t0, zero             # sum = 0
    mv t1, zero             # i = 0
sum_loop:
    bge t1, a1, sum_done
    slli t2, t1, 2          # t2 = i * 4 (word offset)
    add t3, a0, t2          # t3 = &array[i]
    lw t4, 0(t3)            # t4 = array[i]
    add t0, t0, t4          # sum += array[i]
    addi t1, t1, 1          # i++
    j sum_loop
sum_done:
    mv a0, t0
    jalr zero, ra, 0

.section .data
test_array:
    .word 1, 2, 3, 4, 5
