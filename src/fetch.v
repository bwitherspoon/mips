/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module fetch
#(
    parameter ADDR_WIDTH = 9,
    parameter DATA_WIDTH = 32,
    parameter BOOT_ADDR  = 32'h00000000
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  jump,
    input  wire [DATA_WIDTH-1:0] target,
    input  wire [DATA_WIDTH-1:0] data,
    output wire [ADDR_WIDTH-1:0] addr,
    output reg  [DATA_WIDTH-1:0] pc,
    output reg  [DATA_WIDTH-1:0] ir
);

    initial pc = BOOT_ADDR;
    initial ir = {DATA_WIDTH{1'b0}};

    assign addr = rst ? BOOT_ADDR[ADDR_WIDTH-1:0] : pc[ADDR_WIDTH-1:0];

    always @(posedge clk)
        pc <= rst ? BOOT_ADDR + 1 : jump ? target : pc + 1;

    always @(posedge clk)
        ir <= rst ? {DATA_WIDTH{1'b0}} : data;

endmodule
