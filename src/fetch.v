/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module fetch
#(
    parameter ADDR_SIZE = 10,
    parameter BOOT_ADDR = 32'h00000000,
    parameter PROG_FILE = "asm/firmware.hex",
    parameter WORD_SIZE = 32
)(
    input                      clk,
    input                      rst,
    input                      jump,
    input      [WORD_SIZE-1:0] addr,
    output reg [WORD_SIZE-1:0] pc_id,
    output reg [WORD_SIZE-1:0] ir_id
);

    reg [WORD_SIZE-1:0] rom [0:2**ADDR_SIZE-1];

    initial $readmemh(PROG_FILE, rom, 0, 2**ADDR_SIZE-1);

    initial pc_id = BOOT_ADDR;

    // Pipeline registers
    always @(posedge clk) begin
        ir_id <= rst ? {WORD_SIZE{1'b0}} : rom[pc_id[ADDR_SIZE-1:0]];
        pc_id <= rst ? BOOT_ADDR : jump ? addr : pc_id + 1;
    end

endmodule
