/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module memory
#(
    parameter ADDR_SIZE = 5,
    parameter WORD_SIZE = 32
)(
    input                  clk_i,
    input  [ADDR_SIZE-1:0] addr_i,
    input  [WORD_SIZE-1:0] data_i,
    input                  wen_i,
    output [WORD_SIZE-1:0] data_o
);
    // Async RAM memory
    reg [31:0] ram [0:2**ADDR_SIZE-1];

    integer i;
    initial
        for (i = 0; i < 2**ADDR_SIZE; i = i + 1)
            ram[i] = i;

    always @(posedge clk_i)
        if (wen_i)
            ram[addr_i] <= data_i;

    assign data_o = ram[addr_i];

endmodule
