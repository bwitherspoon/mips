/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module write
#(
    parameter ADDR_SIZE = 5,
    parameter WORD_SIZE = 32
)(
    input [WORD_SIZE-1:0] alu_data_i,
    input [WORD_SIZE-1:0] mem_data_i,
    input                 rd_data_sel_i,

    output [ADDR_SIZE-1:0] mem_addr_o,
    output [WORD_SIZE-1:0] rd_data_o
);
    // Writeback stage
    assign mem_addr_o = alu_data_i[ADDR_SIZE-1:0];

    assign rd_data_o = rd_data_sel_i ? mem_data_i : alu_data_i;
endmodule
