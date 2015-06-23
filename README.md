MIPS
====

A single-issue RISC processor with a classic 5-stage pipeline in Verilog (IEEE
Std 1365-2005). The processor implements a subset of the MIPS R2000 instruction
set architecture.

Formats
-------

### R-type

| 31-26  | 25-21 |  20-16 | 15-11 |  10-6 |  5-0  |
|:------:|:-----:|:------:|:-----:|:-----:|:-----:|
| opcode |  rs   |   rt   |  rd   | shamt | funct |

### I-type

|  31-26  | 25-21 | 20-16 |        15-0           |
|:-------:|:-----:|:-----:|:---------------------:|
| opcode  |  rs   |  rt   |         imm           |

### J-type

|  31-26  |               25-0                    |
|:-------:|:-------------------------------------:|
| opcode  |               imm                     |


Instructions
------------

### Arithmetic

 Description            | Instruction      | Operation                | Format
------------------------|------------------|--------------------------|---------
 Add                    | add  rd,rs,rt    | rd = rs + rt             | R-type
 Add immediate          | addi rt,rs,C     | rt = rs + C              | I-type
 Subtract               | sub  rd,rs,rt    | rd = rs - rt             | R-type
 Load upper immediate   | lui  rt,imm      | rt = imm << 16           | I-type

### Logical

 Description            | Instruction      | Operation                | Format
------------------------|------------------|--------------------------|---------
 AND                    | and  rd,rs,rt    | rd = rs & rt             | R-type
 OR                     | or   rd,rs,rt    | rd = rs \| rt            | R-type
 XOR Immediate          | xori rt,rs,imm   | rt = rs ^ imm            | I-type

### Shifts

 Description            | Instruction      | Operation                | Format
------------------------|------------------|--------------------------|---------
 Shift left logical     | sll  rd,rt,shamt | rd = rt << shamt         | R-type
 Shift right arithmetic | sra  rd,rt,shamt | rd = rt >>> shamt        | R-type
 Shift right logical    | srl  rd,rt,shamt | rd = rt >> shamt         | R-type

### Comparision

 Description            | Instruction      | Operation                | Format
------------------------|------------------|--------------------------|---------
 Set on less then       | slt  rd,rs,rt    | rd = (rs < rt) ? 1 : 0   | R-type

### Branch and Jump

 Description       | Instruction  | Operation                         | Format
-------------------|--------------|-----------------------------------|---------
 Branch on equal   | beq rs,rt,C  | pc = (rs == rt) ? pc + 4 * C : pc | I-type
 Jump              | j   C        | pc = C * 4                        | J-type

### Load and Store

 Description            | Instruction  | Operation                    | Format
------------------------|--------------|------------------------------|---------
 Load word              | lw  rt,C(rs) | rt = M[rs + C]               | I-type
 Store word             | sw  rt,C(rs) | M[rs + C] = rt               | I-type

