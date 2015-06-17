/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module write
#(
    parameter ADDR_SIZE = 5,
    parameter WORD_SIZE = 32
)(
    input [WORD_SIZE-1:0] alu_data,
    input [WORD_SIZE-1:0] mem_data,
    input                 rd_data_sel,

    output [ADDR_SIZE-1:0] mem_addr,
    output [WORD_SIZE-1:0] rd_data
);
    // Writeback stage
    assign mem_addr = alu_data[ADDR_SIZE-1:0];

    assign rd_data = rd_data_sel ? mem_data : alu_data;
endmodule
