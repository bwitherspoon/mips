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

    input  [ADDR_SIZE-1:0] s_addr,
    output [WORD_SIZE-1:0] s_data,

    input  [ADDR_SIZE-1:0] t_addr,
    output [WORD_SIZE-1:0] t_data,

    input                  d_we,
    input  [ADDR_SIZE-1:0] d_addr,
    input  [WORD_SIZE-1:0] d_data
);

    reg [WORD_SIZE-1:0] regs [0:2**ADDR_SIZE-1];

`ifndef SYNTHESIS
    integer i;
    initial for (i = 0; i < 2**ADDR_SIZE; i = i + 1) regs[i] = 0;

`ifdef __ICARUS__
    wire [WORD_SIZE-1:0] regs_ [0:2**ADDR_SIZE-1];
    genvar k;
    for (k = 0; k < 2**ADDR_SIZE; k = k + 1) begin : gen_regs
            assign regs_[k] = regs[k];
    end
`endif // __ICARUS__
`endif // SYNTHESIS

    always @(posedge clk)
        if (d_we)
            regs[d_addr] <= d_data;

    assign s_data = regs[s_addr];
    assign t_data = regs[t_addr];

endmodule
