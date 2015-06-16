MIPS I
======

Formats
-------

- R-type

      31-26   25-21  20-16  15-11   10-6     5-0
    +--------+------+------+------+-------+-------+
    | opcode |  rs  |  rt  |  rd  | shamt | funct |
    +--------+------+-------+-----+-------+-------+

- I-type

      31-26   25-21  20-16          15-0
    +--------+------+------+----------------------+
    | opcode |  rs  |  rt  |         imm          |
    +--------+------+------+----------------------+

- J-type

      31-26                 25-31
    +--------+------------------------------------+
    | opcode |               imm                  |
    +--------+------------------------------------+

Instructions
------------

 Catagory      | Description      | Assembly     | Operation                  | Format
---------------|------------------|--------------|----------------------------|---------
 Data transfer | Load word        | lw  $t,C($s) | $t = M[$s + C]             | I-type
 Data transfer | Store word       | sw  $t,C($s) | M[$s + C] = $t             | I-type
 Arthmetic     | Add              | add $d,$s,$t | $d = $s + $t               | R-type
 Arthmetic     | Subtract         | sub $d,$s,$t | $d = $s - $t               | R-type
 Logical       | And              | and $d,$s,$t | $d = $s & $t               | R-type
 Logical       | Or               | or  $d,$s,$t | $d = $s | $t               | R-type
 Comparison    | Set on less then | slt $d,$s,$t | $d = ($s < $t) ? 1 : 0;    | R-type
 Branch        | Branch on equal  | beq $s,$t,C  | if ($s == $t)              | I-type
               |                  |              |     PC = PC + 4 + C * 4    |
               |                  |              | else                       |
               |                  |              |     PC + 4                 |
 Jump          | Jump             | j   C        | PC = C * 4                 | J-type

