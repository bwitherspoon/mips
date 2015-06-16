/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`include "timescale.vh"
`include "defines.vh"

module alu
#(
    parameter WORD_SIZE = 32
)(
    input             [3:0]           opcode,
    input      signed [WORD_SIZE-1:0] a,
    input      signed [WORD_SIZE-1:0] b,
    output reg signed [WORD_SIZE-1:0] result,
    output                            zero
);

    initial result = 0;

    always @(opcode, a, b)
        case (opcode)
            `ALU_OP_AND: result = a & b;
            `ALU_OP_OR : result = a | b;
            `ALU_OP_ADD: result = a + b;
            `ALU_OP_SUB: result = a - b;
            `ALU_OP_SLT: result = a < b ? 1:0;
            `ALU_OP_NOR: result = ~(a | b);
            default             : result = 0;
        endcase

    assign zero = (result == 0);

endmodule
