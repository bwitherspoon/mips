// CPU paramters
`define WORD_SIZE 32

// CPU opcodes
`define OPCODE_RTYPE 6'b000000
`define OPCODE_ADDI  6'b001000
`define OPCODE_LW    6'b100011
`define OPCODE_LUI   6'b001111
`define OPCODE_SW    6'b101011
`define OPCODE_BEQ   6'b000100
`define OPCODE_J     6'b000010

// CPU funct
`define FUNCT_ADD 6'h20
`define FUNCT_SUB 6'h22
`define FUNCT_AND 6'h24
`define FUNCT_OR  6'h25
`define FUNCT_SLT 6'h2a
`define FUNCT_SLL 6'h00
`define FUNCT_SRA 6'h03
`define FUNCT_SRL 6'h02

// ALU operations
`define ALU_AND  4'b0000
`define ALU_OR   4'b0001
`define ALU_ADD  4'b0010
`define ALU_ADDU 4'b0011
`define ALU_SUBU 4'b0100
`define ALU_SUB  4'b0110
`define ALU_SLT  4'b0111
`define ALU_NOR  4'b1100
`define ALU_SLL  4'b1101
`define ALU_SRA  4'b1110
`define ALU_SRL  4'b1111

`define ALU_A_SEL_REG   1'b0
`define ALU_A_SEL_SHAMT 1'b1

`define ALU_B_SEL_REG   1'b0
`define ALU_B_SEL_IMM   1'b1

// Register file control
`define RD_SEL_RT 1'b0
`define RD_SEL_RD 1'b1

`define RD_DATA_SEL_ALU 1'b0
`define RD_DATA_SEL_MEM 1'b1
