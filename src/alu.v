/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module alu
#(
    parameter WORD_SIZE = 32
)(
    input      [3:0]           opcode,
    input      [WORD_SIZE-1:0] a,
    input      [WORD_SIZE-1:0] b,
    output reg [WORD_SIZE-1:0] result
);

    initial result = 0;

    always @*
        case (opcode)
            `ALU_OP_AND:  result = a & b;
            `ALU_OP_OR:   result = a | b;
            `ALU_OP_ADD:  result = $signed(a) + $signed(b);
            `ALU_OP_ADDU: result = a + b;
            `ALU_OP_SUB:  result = $signed(a) - $signed(b);
            `ALU_OP_SUBU: result = a - b;
            `ALU_OP_SLT:  result = a < b ? 1:0;
            `ALU_OP_NOR:  result = ~(a | b);
            default: begin
                result = 1'bX;
`ifndef SYNTHESIS
                $display("%0d: Invalid ALU opcode: 0x%h", $time, opcode);
`endif
            end
        endcase

endmodule
