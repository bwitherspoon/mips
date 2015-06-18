/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module regfile
#(
    parameter ADDR_SIZE = 5,
    parameter WORD_SIZE = 32
)(
    input clk,

    input  [ADDR_SIZE-1:0] rs_addr,
    output [WORD_SIZE-1:0] rs_data,

    input  [ADDR_SIZE-1:0] rt_addr,
    output [WORD_SIZE-1:0] rt_data,

    input                  rd_en,
    input  [ADDR_SIZE-1:0] rd_addr,
    input  [WORD_SIZE-1:0] rd_data
);
    // Registers
    reg [WORD_SIZE-1:0] regs [0:2**ADDR_SIZE-1];

    integer i;
    initial for (i = 0; i < 2**ADDR_SIZE; i = i + 1) regs[i] = 0;

`ifndef SYNTHESIS
    wire [WORD_SIZE-1:0] regs_ [0:2**ADDR_SIZE-1];
    genvar k;
    for (k = 0; k < 2**ADDR_SIZE; k = k + 1) begin : gen_regs
            assign regs_[k] = regs[k];
    end
`endif

    always @(posedge clk)
        if (rd_en)
            regs[rd_addr] <= rd_data;

    assign rs_data = regs[rs_addr];
    assign rt_data = regs[rt_addr];

endmodule
