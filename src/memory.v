/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module memory
#(
    parameter ADDR_SIZE = 5,
    parameter WORD_SIZE = 32
)(
    input                  clk,
    input  [ADDR_SIZE-1:0] addr,
    input  [WORD_SIZE-1:0] wdata,
    input                  wen,
    output [WORD_SIZE-1:0] rdata
);

    reg [31:0] mem [0:2**ADDR_SIZE-1];

    integer i;
    initial for (i = 0; i < 2**ADDR_SIZE; i = i + 1) mem[i] = i;

`ifndef SYNTHESIS
    wire [31:0] mem_ [0:2**ADDR_SIZE-1];
    genvar k;
    for (k = 0; k < 2**ADDR_SIZE; k = k + 1) begin : gen_mem
            assign mem_[k] = mem[k];
            initial $dumpvars(1, mem_[k]);
    end
`endif

    always @(posedge clk)
        if (wen)
            mem[addr] <= wdata;

    assign rdata = mem[addr];

endmodule
