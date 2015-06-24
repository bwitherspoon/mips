/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module write #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    // mem -> wb
    input  [DATA_WIDTH-1:0] alu_data_wb,
    input  [DATA_WIDTH-1:0] mem_data_wb,
    input                   reg_d_data_sel_wb,
    // wb -> reg
    output [DATA_WIDTH-1:0] reg_d_data_wb
);

    assign reg_d_data_wb = reg_d_data_sel_wb ? mem_data_wb : alu_data_wb;

endmodule
