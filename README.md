MIPS I
======

Formats
-------

* R-type

```
  31-26   25-21  20-16  15-11   10-6     5-0
+--------+------+------+------+-------+-------+
| opcode |  rs  |  rt  |  rd  | shamt | funct |
+--------+------+-------+-----+-------+-------+
```

* I-type

```
  31-26   25-21  20-16          15-0
+--------+------+------+----------------------+
| opcode |  rs  |  rt  |         imm          |
+--------+------+------+----------------------+
```

* J-type

```
  31-26                 25-31
+--------+------------------------------------+
| opcode |               imm                  |
+--------+------------------------------------+
```

Instructions
------------

### Load and Store

 Description      | Instruction  | Operation                         | Format
------------------|--------------|-----------------------------------|---------
 Load word        | lw  rt,C(rs) | rt = M[rs + C]                    | I-type
 Store word       | sw  rt,C(rs) | M[rs + C] = rt                    | I-type

### Arithmetic and Logic

 Description      | Instruction  | Operation                         | Format
------------------|--------------|-----------------------------------|---------
 Add              | add rd,rs,rt | rd = rs + rt                      | R-type
 Subtract         | sub rd,rs,rt | rd = rs - rt                      | R-type
 And              | and rd,rs,rt | rd = rs & rt                      | R-type
 Or               | or  rd,rs,rt | rd = rs | rt                      | R-type
 Set on less then | slt rd,rs,rt | rd = (rs < rt) ? 1 : 0            | R-type

### Branch and Jump

 Description      | Instruction  | Operation                         | Format
------------------|--------------|-----------------------------------|---------
 Branch on equal  | beq rs,rt,C  | pc = (rs == rt) ? pc + 4*C : pc   | I-type
 Jump             | j   C        | pc = C * 4                        | J-type

