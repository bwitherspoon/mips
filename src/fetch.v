/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module fetch
#(
    parameter ADDR_SIZE = 10,
    parameter BOOT_ADDR = 32'h00000000,
    parameter PROG_CODE = "firmware.bin",
    parameter WORD_SIZE = 32
)(
    input                      clk,
    input                      rst,
    input                      jump,
    input      [WORD_SIZE-1:0] addr,
    output reg [WORD_SIZE-1:0] pc_if_id,
    output reg [WORD_SIZE-1:0] ir_if_id
);

    reg [WORD_SIZE-1:0] rom [0:2**ADDR_SIZE-1];

    initial $readmemb(PROG_CODE, rom, 0, 2**ADDR_SIZE-1);

    initial pc_if_id = BOOT_ADDR;

    // Pipeline registers
    always @(posedge clk) begin
        ir_if_id <= rom[pc_if_id[ADDR_SIZE-1:0]];
        pc_if_id <= rst ? BOOT_ADDR : jump ? addr : pc_if_id + 1;
    end

endmodule
