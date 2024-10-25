
.text
.globl invert_case

# Function to invert case of letters
# a0 = address of the string
invert_case:
    loop:
        lb $t0, 0($a0)         # Load the byte (char)
        beq $t0, $zero, done   # End if null terminator

        # Check if character is uppercase
        li $t1, 0x41
        li $t2, 0x5A
        blt $t0, $t1, lower_case_check
        bgt $t0, $t2, lower_case_check
        # Convert uppercase to lowercase
        ori $t0, $t0, 0x20
        j store_char

        # Check if character is lowercase
    lower_case_check:
        li $t1, 0x61
        li $t2, 0x7A
        blt $t0, $t1, store_char
        bgt $t0, $t2, store_char
        # Convert lowercase to uppercase
        andi $t0, $t0, 0xDF

    store_char:
        sb $t0, 0($a0)         # Store the modified char back to memory
        addi $a0, $a0, 1       # Move to the next character
        j loop

    done:
        jr $ra
