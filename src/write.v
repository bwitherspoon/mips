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
    input [WORD_SIZE-1:0]  alu_data_wb,
    input [WORD_SIZE-1:0]  mem_data_wb,
    input                  reg_d_we_wb,
    input [ADDR_SIZE-1:0]  reg_d_addr_wb,
    input                  reg_d_data_sel_wb,
    // wb -> reg
    output                 reg_d_we,
    output [ADDR_SIZE-1:0] reg_d_addr,
    output [WORD_SIZE-1:0] reg_d_data
);

    assign reg_d_we   = reg_d_we_wb;
    assign reg_d_addr = reg_d_addr_wb;
    assign reg_d_data = reg_d_data_sel_wb ? mem_data_wb : alu_data_wb;

endmodule
