/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module execute (
    input             clk,
    // id -> ex
    input      [3:0]  alu_op_ex,
    input             alu_a_sel_ex,
    input             alu_b_sel_ex,
    input      [31:0] imm_ex,
    input      [3:0]  mem_we_ex,
    input             reg_d_we_ex,
    input      [4:0]  reg_d_addr_ex,
    input             reg_d_data_sel_ex,
    input      [31:0] reg_s_data_ex,
    input      [31:0] reg_t_data_ex,
    // ex -> mem
    output reg [31:0] alu_data_mem,
    output reg        reg_d_we_mem,
    output reg [4:0]  reg_d_addr_mem,
    output reg        reg_d_data_sel_mem,
    output reg [31:0] reg_t_data_mem,
    output reg [3:0]  mem_we_mem
);

    wire [31:0] shamt = {27'h0000000, imm_ex[10:6]};
    wire [31:0] alu_a = alu_a_sel_ex ? shamt  : reg_s_data_ex;
    wire [31:0] alu_b = alu_b_sel_ex ? imm_ex : reg_t_data_ex;
    wire [31:0] alu_data;

    alu alu(
        .opcode(alu_op_ex),
        .a(alu_a),
        .b(alu_b),
        .result(alu_data)
    );

    // Pipeline registers
    always @(posedge clk) begin
        alu_data_mem       <= alu_data;
        mem_we_mem         <= mem_we_ex;
        reg_d_we_mem       <= reg_d_we_ex;
        reg_d_addr_mem     <= reg_d_addr_ex;
        reg_d_data_sel_mem <= reg_d_data_sel_ex;
        reg_t_data_mem     <= reg_t_data_ex;
    end

endmodule
