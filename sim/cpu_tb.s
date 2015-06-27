# Arithmetic
addi $t0, $zero, 0xFFFF
addi $t1, $zero, 0x0001
addi $t2, $zero, 0x0006
addi $t3, $zero, 0x0007
addi $t4, $zero, 0xFF00
addi $t5, $zero, 0x700A
add  $t6, $t1,   $t2
sub  $t7, $t3,   $t2
# Logical
and  $t8, $t2,   $t3
or   $t9, $t2,   $t3
# Store
sw   $t0, 0($t0)
sw   $t1, 0($t0)
sw   $t2, 0($t0)
sw   $t3, 0($t0)
sw   $t4, 0($t0)
sw   $t5, 0($t0)
sw   $t6, 0($t0)
sw   $t7, 0($t0)
sw   $t8, 0($t0)
sw   $t9, 0($t0)
# Shifts
sll  $t6, $t0,   0x8
sra  $t7, $t4,   0x8
srl  $t8, $t4,   0x8
nop
nop
# Store
sw   $t6, 0($t0)
sw   $t7, 0($t0)
sw   $t8, 0($t0)
# Comparision
slt  $t9, $t2,   $t3
# Branch
beq  $t4, $t4,   0xC
# Jump
# Load immediate
lui  $t4, 0x00FF
nop
nop
nop
nop
nop
sw   $t4, 0($t0)
xori $t4,$t4,0xF00C
nop
nop
nop
nop
sw   $t4, 0($t0)
