
.text
.globl decode_instruction, encode_instruction

# Function to decode an I-type instruction
# a0 = memory address of the instruction
decode_instruction:
    lw $t0, 0($a0)             # Load instruction from memory
    srl $t1, $t0, 26           # Extract opcode
    andi $t1, $t1, 0x3F        # Mask to get last 6 bits
    li $v0, 34                 # Syscall for printing hex
    move $a0, $t1
    syscall                    # Print opcode

    srl $t2, $t0, 21           # Extract rs
    andi $t2, $t2, 0x1F        # Mask to get last 5 bits
    move $a0, $t2
    syscall                    # Print rs

    srl $t3, $t0, 16           # Extract rt
    andi $t3, $t3, 0x1F        # Mask to get last 5 bits
    move $a0, $t3
    syscall                    # Print rt

    andi $t4, $t0, 0xFFFF      # Extract immediate
    move $a0, $t4
    syscall                    # Print immediate

    jr $ra

# Function to encode an I-type instruction
# a0 = opcode, a1 = rs, a2 = rt, a3 = immediate
encode_instruction:
    sll $t0, $a0, 26           # Shift opcode to the right position
    sll $t1, $a1, 21           # Shift rs
    sll $t2, $a2, 16           # Shift rt
    or $t0, $t0, $t1           # Combine opcode and rs
    or $t0, $t0, $t2           # Combine with rt
    or $t0, $t0, $a3           # Combine with immediate

    move $v0, $t0
    li $v0, 34                 # Syscall for printing hex
    move $a0, $t0
    syscall                    # Print instruction

    jr $ra
