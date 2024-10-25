
.text
.globl get_bits, set_bits, reset_bits

# Function to extract a series of bits
# a0 = number, a1 = start position, a2 = size of bits
get_bits:
    sllv $t0, $a0, $a1         # Shift left by start position
    srlv $v0, $t0, $a2         # Shift right by size of bits
    jr $ra

# Function to set a series of bits
# a0 = number, a1 = start position, a2 = size of bits
set_bits:
    li $t1, 1
    sllv $t1, $t1, $a2         # Create mask of ones for the bits
    sllv $t1, $t1, $a1         # Align the mask to the starting position
    or $v0, $a0, $t1           # Set the bits
    jr $ra

# Function to reset (clear) a series of bits
# a0 = number, a1 = start position, a2 = size of bits
reset_bits:
    li $t1, 1
    sllv $t1, $t1, $a2
    sllv $t1, $t1, $a1
    not $t1, $t1               # Invert the mask
    and $v0, $a0, $t1          # Clear the bits
    jr $ra
