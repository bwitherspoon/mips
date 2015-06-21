/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module fetch
#(
    parameter ADDR_WIDTH = 9,
    parameter WORD_WIDTH = 32,
    parameter BOOT_ADDR  = 32'h00000000,
)(
    input                       clk,
    input                       rst,
    input                       jump,
    input      [WORD_WIDTH-1:0] target,
    input      [WORD_WIDTH-1:0] ram_rdata_b,
    output     [ADDR_WIDTH-1:0] ram_addr_b,
    output reg [WORD_WIDTH-1:0] pc_id,
    output     [WORD_WIDTH-1:0] ir_id
);

    initial pc_id = BOOT_ADDR;

    assign ram_addr_b = pc_id[ADDR_WIDTH-1:0];
    assign ir_id      = rst ? {WORD_WIDTH{1'b0}} : ram_rdata_b;

    always @(posedge clk)
        pc_id <= rst ? BOOT_ADDR : jump ? target : pc_id + 1;

endmodule
