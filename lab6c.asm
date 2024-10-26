.data
    returned: .asciiz 

.text
.globl main, decode_instruction, encode_instruction

# Decode an I-type instruction (addi, ori, etc.)
# a0 = memory address of the instruction
decode_instruction:
    lw $t0, 0($a0)             # Load instruction from memory
    srl $t1, $t0, 26           # Extract opcode (bits 31-26)
    andi $t1, $t1, 0x3F        # Mask to get the last 6 bits (opcode is 6 bits)
    li $v0, 34                 # Syscall for printing hex
    move $a0, $t1
    syscall                    # Print opcode

    srl $t2, $t0, 21           # Extract rs (bits 25-21)
    andi $t2, $t2, 0x1F        # Mask to get the last 5 bits (rs is 5 bits)
    move $a0, $t2
    syscall                    # Print rs

    srl $t3, $t0, 16           # Extract rt (bits 20-16)
    andi $t3, $t3, 0x1F        # Mask to get the last 5 bits (rt is 5 bits)
    move $a0, $t3
    syscall                    # Print rt

    andi $t4, $t0, 0xFFFF      # Extract immediate (bits 15-0)
    move $a0, $t4
    syscall                    # Print immediate

    jr $ra                     # Return from the function

# Encode an I-type instruction and return it
# a0 = opcode, a1 = rs, a2 = rt, a3 = immediate
encode_instruction:
    sll $t0, $a0, 26           # Shift opcode to the right position (bits 31-26)
    sll $t1, $a1, 21           # Shift rs to the right position (bits 25-21)
    sll $t2, $a2, 16           # Shift rt to the right position (bits 20-16)
    or $t0, $t0, $t1           # Combine opcode and rs
    or $t0, $t0, $t2           # Combine with rt
    or $t0, $t0, $a3           # Combine with immediate (bits 15-0)

    move $v0, $t0              # Move the result into $v0 for returning
    li $v0, 34                 # Syscall to print the result in hex
    move $a0, $t0
    syscall                    # Print the instruction in hex

    jr $ra                     # Return from the function

# Test program to decode and encode instructions
main:
    # Decode the first instruction in function "func" (addi v0, zero, 0x1337)
    la $a0, func               # Load the address of the "func" function
    jal decode_instruction      # Call decode_instruction

    # Encode the instruction addi v0, zero, 0x1234
    li $a0, 8                  # Set opcode (addi opcode = 8)
    li $a1, 0                  # Set rs (zero register = 0)
    li $a2, 2                  # Set rt (v0 register = 2)
    li $a3, 0x1234             # Set immediate value (0x1234)
    jal encode_instruction      # Call encode_instruction

    # Print string indicating function return
    la $a0, returned           # Load the address of the return string
    li $v0, 4                  # Syscall for printing string
    syscall                    # Print the string

    # Call the func function
    jal func

    # Print the return value from func
    move $a0, $v0
    li $v0, 34                 # Syscall to print the return value in hex
    syscall

    # Exit the program
    li $v0, 10                 # Syscall to exit
    syscall

# Function "func" - used to test decoding
func:
    addi $v0, $zero, 0x1337    # Simple addi instruction
    jr $ra                     # Return from the function
