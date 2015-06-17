/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module fetch
#(
    parameter ADDR_SIZE = 10,
    parameter BOOT_ADDR = 32'h00000000,
    parameter PROG_CODE = "rom.bin",
    parameter WORD_SIZE = 32
)(
    input                      clk,
    input                      rst,
    input                      load,
    input      [WORD_SIZE-1:0] addr,
    output reg [WORD_SIZE-1:0] pc,
    output     [WORD_SIZE-1:0] ir
);

    reg [WORD_SIZE-1:0] rom [0:2**ADDR_SIZE-1];

    initial $readmemb(PROG_CODE, rom, 0, 2**ADDR_SIZE-1);

    initial pc = BOOT_ADDR;

    assign ir = rom[pc[ADDR_SIZE-1:0]];

    always @(posedge clk)
        pc <= rst ? BOOT_ADDR : load ? addr : pc + 1;

endmodule
