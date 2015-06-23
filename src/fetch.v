/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module fetch #(
    parameter ADDR_WIDTH = 9,
    parameter DATA_WIDTH = 32,
    parameter BOOT_ADDR  = 32'h00000000
)(
    input                       clk,
    input                       reset,
    input                       pc_we,
    input      [DATA_WIDTH-1:0] pc_data,
    input      [DATA_WIDTH-1:0] ram_data,
    output     [ADDR_WIDTH-1:0] ram_addr,
    output reg [DATA_WIDTH-1:0] pc,
    output reg [DATA_WIDTH-1:0] ir
);

    initial pc = BOOT_ADDR;
    initial ir = {DATA_WIDTH{1'b0}};

    assign ram_addr = reset ? BOOT_ADDR[ADDR_WIDTH-1:0] : pc[ADDR_WIDTH-1:0];

    always @(posedge clk)
        pc <= reset ? BOOT_ADDR + 1 : pc_we ? pc_data : pc + 1;

    always @(posedge clk)
        ir <= reset ? {DATA_WIDTH{1'b0}} : ram_data;

endmodule
