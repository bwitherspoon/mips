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
            `ALU_AND:  result = a & b;
            `ALU_OR:   result = a | b;
            `ALU_ADD:  result = $signed(a) + $signed(b);
            `ALU_ADDU: result = a + b;
            `ALU_SUB:  result = $signed(a) - $signed(b);
            `ALU_SUBU: result = a - b;
            `ALU_SLT:  result = $signed(a) < $signed(b) ? 1 : 0;
            `ALU_NOR:  result = ~(a | b);
            `ALU_SLL:  result = b << a;
            `ALU_SRA:  result = $signed(b) >>> a;
            `ALU_SRL:  result = b >> a;
            default: begin
                result = 32'bX;
`ifndef SYNTHESIS
                $display("%0d: Invalid ALU opcode: 0x%h", $time, opcode);
`endif
            end
        endcase

endmodule
