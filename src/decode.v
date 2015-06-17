/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module decode (
    input [31:0] ir,
    input rd_addr_sel,

    output [5:0]  opcode,
    output [4:0]  rs,
    output [4:0]  rt,
    output [4:0]  rd,
    output [4:0]  shamt,
    output [5:0]  funct,
    output [31:0] imm
);
    assign rs = ir[25:21]; // first source register
    assign rt = ir[20:16]; // second source register
    assign rd = rd_addr_sel ? ir[15:11] : rt; // destination register

    assign opcode = ir[31:26]; // opcode
    assign shamt = ir[10:6];   // shift amount (R-type)
    assign funct = ir[5:0];    // function code (R-type)
    assign imm = {{16{ir[15]}}, ir[15:0]}; // immediate (I-type)

endmodule
