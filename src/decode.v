/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module decode (
    input             clk,

    input      [31:0] pc_id,
    input      [31:0] ir_id,
    input      [31:0] reg_s_data,
    input      [31:0] reg_t_data,

    output     [31:0] addr,
    output     [4:0]  reg_s_addr,
    output     [4:0]  reg_t_addr,
    output            jump,

    output reg [3:0]  alu_op_ex,
    output reg        alu_a_sel_ex,
    output reg        alu_b_sel_ex,
    output reg [3:0]  mem_we_ex,
    output reg [31:0] imm_ex,
    output reg        reg_d_we_ex,
    output reg [4:0]  reg_d_addr_ex,
    output reg        reg_d_data_sel_ex,
    output reg [31:0] reg_s_data_ex,
    output reg [31:0] reg_t_data_ex
);

    wire [3:0]  alu_op;
    wire        alu_a_sel;
    wire        alu_b_sel;
    wire [3:0]  mem_we;
    wire [31:0] imm;
    wire        reg_d_we;
    wire [4:0]  reg_d_addr;
    wire        reg_d_addr_sel;
    wire        reg_d_data_sel;
    wire [5:0]  opcode;
    wire [5:0]  funct;
    wire        equal;

    control control (
        .opcode(opcode),
        .funct(funct),
        .equal(equal),
        .alu_op(alu_op),
        .alu_a_sel(alu_a_sel),
        .alu_b_sel(alu_b_sel),
        .mem_we(mem_we),
        .jump(jump),
        .reg_d_addr_sel(reg_d_addr_sel),
        .reg_d_data_sel(reg_d_data_sel),
        .reg_d_we(reg_d_we)
    );

    assign reg_s_addr = ir_id[25:21];
    assign reg_t_addr = ir_id[20:16];
    assign reg_d_addr = reg_d_addr_sel ? ir_id[15:11] : reg_t_addr;

    assign opcode = ir_id[31:26];
    assign funct = ir_id[5:0];
    assign imm = {{16{ir_id[15]}}, ir_id[15:0]};

    // Handle branch and jump instructions early in the pipeline
    assign addr = $signed(pc_id) + $signed(imm);
    assign equal = reg_s_data == reg_t_data;

    // Pipeline registers
    always @(posedge clk) begin
        alu_op_ex         <= alu_op;
        alu_a_sel_ex      <= alu_a_sel;
        alu_b_sel_ex      <= alu_b_sel;
        mem_we_ex         <= mem_we;
        imm_ex            <= imm;
        reg_d_we_ex       <= reg_d_we;
        reg_d_addr_ex     <= reg_d_addr;
        reg_s_data_ex     <= reg_s_addr == 5'd0 ? 32'd0 : reg_s_data;
        reg_t_data_ex     <= reg_t_addr == 5'd0 ? 32'd0 : reg_t_data;
        reg_d_data_sel_ex <= reg_d_data_sel;
    end

endmodule
