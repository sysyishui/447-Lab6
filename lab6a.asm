.text
.globl main, get_bits, set_bits, reset_bits

# Function to extract a series of bits
# a0 = number, a1 = start position, a2 = size of bits
get_bits:
    sllv $t0, $a0, $a1         # Shift left by start position
    srlv $v0, $t0, $a2         # Shift right by size of bits
    jr $ra                     # Return

# Function to set a series of bits
# a0 = number, a1 = start position, a2 = size of bits
set_bits:
    li $t1, 1
    sllv $t1, $t1, $a2         # Create mask of ones for the bits
    sllv $t1, $t1, $a1         # Align the mask to the starting position
    or $v0, $a0, $t1           # Set the bits
    jr $ra                     # Return

# Function to reset (clear) a series of bits
# a0 = number, a1 = start position, a2 = size of bits
reset_bits:
    li $t1, 1
    sllv $t1, $t1, $a2
    sllv $t1, $t1, $a1
    not $t1, $t1               # Invert the mask
    and $v0, $a0, $t1          # Clear the bits
    jr $ra                     # Return

# Main function to test get_bits, set_bits, and reset_bits
main:
    # Test get_bits
    li $a0, 0x12345678         # Load the number to inspect
    li $a1, 8                  # Starting position (bit 8)
    li $a2, 4                  # Size of bits (4 bits)
    jal get_bits               # Call get_bits function
    li $v0, 34                 # Print the result in hexadecimal
    move $a0, $v0
    syscall                    # Print the result

    # Test set_bits
    li $a0, 0x12345678         # Load the number to modify
    li $a1, 12                 # Starting position (bit 12)
    li $a2, 3                  # Size of bits (3 bits)
    jal set_bits               # Call set_bits function
    li $v0, 34                 # Print the result in hexadecimal
    move $a0, $v0
    syscall                    # Print the result

    # Test reset_bits
    li $a0, 0x12345678         # Load the number to modify
    li $a1, 16                 # Starting position (bit 16)
    li $a2, 5                  # Size of bits (5 bits)
    jal reset_bits             # Call reset_bits function
    li $v0, 34                 # Print the result in hexadecimal
    move $a0, $v0
    syscall                    # Print the result

    # Exit the program
    li $v0, 10                 # Exit syscall
    syscall
