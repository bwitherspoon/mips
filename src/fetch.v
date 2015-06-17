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
    input         clk_i,
    input         rst_i,
    input         pc_load_i,
    input  [WORD_SIZE-1:0] pc_data_i,
    output [WORD_SIZE-1:0] pc_o,
    output [WORD_SIZE-1:0] ir_o
);
    reg [WORD_SIZE-1:0] pc = BOOT_ADDR;

    reg [WORD_SIZE-1:0] rom [0:2**ADDR_SIZE-1];

    initial $readmemb(PROG_CODE, rom, 0, 2**ADDR_SIZE-1);

    assign ir_o = rom[pc[ADDR_SIZE-1:0]];

    assign pc_o = pc;

    always @(posedge clk_i)
        pc <= rst_i ? BOOT_ADDR : pc_load_i ? pc_data_i : pc + 1;

endmodule
