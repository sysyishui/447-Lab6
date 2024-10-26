.data
    input_string: .asciiz 

.text
.globl main, invert_case

invert_case:
    loop:
        lb $t0, 0($a0)         # Load the byte (char) from the string
        beq $t0, $zero, done   # End if null terminator

       
        li $t1, 0x41           # ASCII value of 'A'
        li $t2, 0x5A           # ASCII value of 'Z'
        blt $t0, $t1, lower_case_check  # If less than 'A', check if lowercase
        bgt $t0, $t2, lower_case_check  # If greater than 'Z', check lowercase
        # Convert uppercase to lowercase
        ori $t0, $t0, 0x20      # Set bit 5 to 1 to convert to lowercase
        j store_char

    lower_case_check:
        li $t1, 0x61           # ASCII value of 'a'
        li $t2, 0x7A           # ASCII value of 'z'
        blt $t0, $t1, store_char  # If less than 'a', store without change
        bgt $t0, $t2, store_char  # If greater than 'z', store without change
        # Convert lowercase to uppercase
        andi $t0, $t0, 0xDF     # Reset bit 5 to 0 to convert to uppercase

    store_char:
        sb $t0, 0($a0)         # Store the modified char back to memory
        addi $a0, $a0, 1       # Move to the next character
        j loop

    done:
        jr $ra                 # Return from the function

# Main function to test invert_case
main:
    la $a0, input_string       # Load address of the string into $a0
    jal invert_case            # Call invert_case function

    # Print the modified string
    li $v0, 4                  # Syscall to print string
    la $a0, input_string       # Load the address of the string again
    syscall                    # Print the string

    # Exit the program
    li $v0, 10                 # Exit syscall
    syscall
