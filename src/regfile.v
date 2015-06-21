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

    reg [WORD_SIZE-1:0] regs [0:2**ADDR_SIZE-2];

    wire s_zero = s_addr == {ADDR_SIZE{1'b0}};
    wire t_zero = t_addr == {ADDR_SIZE{1'b0}};
    wire d_zero = d_addr == {ADDR_SIZE{1'b0}};

`ifndef SYNTHESIS
    integer i;
    initial for (i = 0; i < 2**ADDR_SIZE-1; i = i + 1) regs[i] = 0;
`ifdef __ICARUS__
    wire [WORD_SIZE-1:0] regs_ [0:2**ADDR_SIZE-1];
    genvar k;
    for (k = 0; k < 2**ADDR_SIZE; k = k + 1) begin : gen_regs
            assign regs_[k] = regs[k];
    end
`endif // __ICARUS__
`endif // SYNTHESIS

    always @(posedge clk)
        if (d_we && ~d_zero)
            regs[d_addr - 1] <= d_data;

    assign s_data = s_zero ? {WORD_SIZE{1'b0}} : regs[s_addr - 1];
    assign t_data = t_zero ? {WORD_SIZE{1'b0}} : regs[t_addr - 1];

endmodule
