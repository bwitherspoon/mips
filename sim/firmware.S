addi  1,0,0x4080
addi  2,0,0x1010
addi  3,0,0x0808
addi  4,0,0x300A
addi  5,0,0x70F0
sw    1,0,0xA
add   6,1,2      ; 0x5090
sub   7,3,4      ; 0x5076
and   8,5,5      ; 0x70F0
nop
lw    0,0,0xA    ; 0x0000
lw    1,0,0x1A   ; 0x4080
beq   3,3,5
nop
nop
nop
sw    2,0,0x6
nop
nop
nop
nop
nop
