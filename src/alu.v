/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module alu #(
    parameter DATA_WIDTH = 32
)(
    input      [3:0]            opcode,
    input      [DATA_WIDTH-1:0] a,
    input      [DATA_WIDTH-1:0] b,
    output reg [DATA_WIDTH-1:0] result
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
            `ALU_XOR:  result = a ^ b;
            `ALU_NOR:  result = ~(a | b);
            `ALU_SLL:  result = b << a;
            `ALU_SRA:  result = $signed(b) >>> a;
            `ALU_SRL:  result = b >> a;
            default: begin
                result = {DATA_WIDTH{1'bx}};
`ifndef SYNTHESIS
                $display("ERROR: [%0d] Invalid ALU opcode: 0x%h", $time, opcode);
`endif
            end
        endcase

endmodule
