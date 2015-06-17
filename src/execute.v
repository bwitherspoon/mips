/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module execute (
    input  [3:0]  alu_op,
    input         alu_sel,
    input  [31:0] pc,
    input  [4:0]  shamt,
    input  [31:0] imm,
    input  [31:0] rs_data,
    input  [31:0] rt_data,

    output [31:0] alu_data,
    output        alu_zero,
    output [31:0] pc_addr
);

    wire [31:0] alu_a = rs_data;
    wire [31:0] alu_b = alu_sel ? imm : rt_data;

    alu alu(
        .opcode(alu_op),
        .a(alu_a),
        .b(alu_b),
        .result(alu_data),
        .zero(alu_zero)
    );

    assign pc_addr = pc + imm;

endmodule
