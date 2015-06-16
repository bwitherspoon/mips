/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`include "timescale.vh"

module execute (
    input  [3:0]  alu_op_i,
    input         alu_sel_i,
    input  [31:0] pc_i,
    input  [4:0]  shamt_i,
    input  [31:0] imm_i,
    input  [31:0] rs_data_i,
    input  [31:0] rt_data_i,

    output [31:0] alu_data_o,
    output        alu_zero_o,
    output [31:0] pc_data_o
);

    wire [31:0] alu_a = rs_data_i;
    wire [31:0] alu_b = alu_sel_i ? imm_i : rt_data_i;

    alu alu(
        .opcode(alu_op_i),
        .a(alu_a),
        .b(alu_b),
        .result(alu_data_o),
        .zero(alu_zero_o)
    );

    assign pc_data_o = pc_i + imm_i;

endmodule
