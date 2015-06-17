/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module regfile
#(
    parameter ADDR_SIZE = 5,
    parameter WORD_SIZE = 32
)(
    input clk_i,

    input  [ADDR_SIZE-1:0] rs_i,
    output [WORD_SIZE-1:0] rs_data_o,

    input  [ADDR_SIZE-1:0] rt_i,
    output [WORD_SIZE-1:0] rt_data_o,

    input                  rd_en_i,
    input  [ADDR_SIZE-1:0] rd_i,
    input  [WORD_SIZE-1:0] rd_data_i
);

    reg [WORD_SIZE-1:0] regs [0:2**ADDR_SIZE-1];

    integer i;
    initial for (i = 0; i < 2**ADDR_SIZE; i = i + 1) regs[i] = 0;

`ifndef SYNTHESIS
    wire [31:0] regs_ [0:2**ADDR_SIZE-1];
    genvar k;
    for (k = 0; k < 2*ADDR_SIZE; k = k + 1) begin : gen_regs
            assign regs_[k] = regs[k];
            initial $dumpvars(1, regs_[k]);
    end
`endif

    always @(posedge clk_i)
        if (rd_en_i)
            regs[rd_i] <= rd_data_i;

    assign rs_data_o = regs[rs_i];
    assign rt_data_o = regs[rt_i];

endmodule
