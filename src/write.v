/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module write
#(
    parameter ADDR_SIZE = 5,
    parameter WORD_SIZE = 32
)(
    // mem -> wb
    input [WORD_SIZE-1:0] alu_data_mem_wb,
    input [WORD_SIZE-1:0] mem_data_mem_wb,
    input                 rd_en_mem_wb,
    input [ADDR_SIZE-1:0] rd_addr_mem_wb,
    input                 rd_data_sel_mem_wb,
    // wb -> reg
    output                 rd_en,
    output [ADDR_SIZE-1:0] rd_addr,
    output [WORD_SIZE-1:0] rd_data
);
    assign rd_en = rd_en_mem_wb;
    assign rd_addr = rd_addr_mem_wb;
    assign rd_data = rd_data_sel_mem_wb ? mem_data_mem_wb : alu_data_mem_wb;
endmodule
