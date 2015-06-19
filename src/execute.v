/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module execute (
    input         clk,
    // id -> ex
    input  [3:0]  alu_op_id_ex,
    input         alu_a_sel_id_ex,
    input         alu_b_sel_id_ex,
    input  [31:0] imm_id_ex,
    input         mem_en_id_ex,
    input         rd_en_id_ex,
    input  [4:0]  rd_addr_id_ex,
    input         rd_data_sel_id_ex,
    input  [31:0] rs_data_id_ex,
    input  [31:0] rt_data_id_ex,
    // ex -> mem
    output reg [31:0] alu_data_ex_mem,
    output reg        rd_en_ex_mem,
    output reg [4:0]  rd_addr_ex_mem,
    output reg        rd_data_sel_ex_mem,
    output reg [31:0] rt_data_ex_mem,
    output reg        mem_en_ex_mem
);
    wire [31:0] shamt = {27'h0000000, imm_id_ex[10:6]};

    wire [31:0] alu_a = alu_a_sel_id_ex ? shamt     : rs_data_id_ex;
    wire [31:0] alu_b = alu_b_sel_id_ex ? imm_id_ex : rt_data_id_ex;
    wire [31:0] alu_data;

    alu alu(
        .opcode(alu_op_id_ex),
        .a(alu_a),
        .b(alu_b),
        .result(alu_data)
    );

    // Pipeline registers
    always @(posedge clk) begin
        alu_data_ex_mem <= alu_data;
        mem_en_ex_mem <= mem_en_id_ex;
        rd_en_ex_mem <= rd_en_id_ex;
        rd_addr_ex_mem <= rd_addr_id_ex;
        rd_data_sel_ex_mem <= rd_data_sel_id_ex;
        rt_data_ex_mem <= rt_data_id_ex;
    end

endmodule
