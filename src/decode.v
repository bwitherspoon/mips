/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`include "timescale.vh"

module decode (
    input [31:0] ir_i,
    input rd_sel_i,

    output [5:0]  opcode_o,
    output [4:0]  rs_o,
    output [4:0]  rt_o,
    output [4:0]  rd_o,
    output [4:0]  shamt_o,
    output [5:0]  funct_o,
    output [31:0] imm_o
);
    wire [4:0] rs = ir_i[25:21]; // first source register
    wire [4:0] rt = ir_i[20:16]; // second source register
    wire [4:0] rd = ir_i[15:11]; // destination register

    assign opcode_o = ir_i[31:26]; // opcode
    assign shamt_o = ir_i[10:6];   // shift amount (R-type)
    assign funct_o = ir_i[5:0];    // function code (R-type)
    assign imm_o = {{16{ir_i[15]}}, ir_i[15:0]}; // immediate (I-type)

    assign rs_o = rs;
    assign rt_o = rt;
    assign rd_o = rd_sel_i ? rd : rt;

endmodule
