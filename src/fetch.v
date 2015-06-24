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
    output reg [DATA_WIDTH-1:0] pc_id,
    output reg [DATA_WIDTH-1:0] ir_id
);

    reg [DATA_WIDTH-1:0] pc = 0;

    initial pc_id = BOOT_ADDR;
    initial ir_id = 0;

    assign ram_addr = pc[ADDR_WIDTH-1:0];

    always @(posedge clk)
        if (reset) begin
            pc    <= BOOT_ADDR;
            pc_id <= 0;
            ir_id <= 0;;
        end else begin
            pc    <= pc_we ? pc_data : pc + 1;;
            pc_id <= pc;
            ir_id <= ram_data;
        end

endmodule
