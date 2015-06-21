/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module fetch
#(
    parameter ADDR_WIDTH = 9,
    parameter WORD_WIDTH = 32,
    parameter BOOT_ADDR  = 32'h00000000
)(
    input                       clk,
    input                       rst,
    input                       jump,
    input      [WORD_WIDTH-1:0] target,
    input      [WORD_WIDTH-1:0] data,
    output     [ADDR_WIDTH-1:0] addr,
    output reg [WORD_WIDTH-1:0] pc,
    output reg [WORD_WIDTH-1:0] ir
);

    initial pc = BOOT_ADDR;

    assign addr = rst ? BOOT_ADDR[ADDR_WIDTH-1:0] : pc[ADDR_WIDTH-1:0];

    always @(posedge clk) begin
        ir <= rst ? {WORD_WIDTH{1'b0}} : data;
        pc <= rst ? BOOT_ADDR + 1 : jump ? target : pc + 1;
    end

endmodule
