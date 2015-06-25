/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module execute #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input                       clk,
    // id -> ex
    input      [3:0]            alu_op_ex,
    input      [1:0]            alu_a_sel_ex,
    input      [1:0]            alu_b_sel_ex,
    input      [15:0]           imm_ex,
    input      [3:0]            mem_we_ex,
    input                       reg_d_we_ex,
    input      [ADDR_WIDTH-1:0] reg_s_addr_ex,
    input      [ADDR_WIDTH-1:0] reg_t_addr_ex,
    input      [ADDR_WIDTH-1:0] reg_d_addr_ex,
    input                       reg_d_data_sel_ex,
    input      [DATA_WIDTH-1:0] reg_s_data_ex,
    input      [DATA_WIDTH-1:0] reg_t_data_ex,
    // mem -> ex
    input      [DATA_WIDTH-1:0] reg_d_data_mem,
    // wb -> ex
    input                       reg_d_we_wb,
    input      [ADDR_WIDTH-1:0] reg_d_addr_wb,
    input      [DATA_WIDTH-1:0] reg_d_data_wb,
    // ex -> mem
    output reg [DATA_WIDTH-1:0] alu_data_mem,
    output reg                  reg_d_we_mem,
    output reg [ADDR_WIDTH-1:0] reg_d_addr_mem,
    output reg                  reg_d_data_sel_mem,
    output reg [DATA_WIDTH-1:0] reg_t_data_mem,
    output reg [3:0]            mem_we_mem
);

    wire [DATA_WIDTH-1:0] shamt = {27'h0000000, imm_ex[10:6]};
    wire [DATA_WIDTH-1:0] imms  = {{16{imm_ex[15]}}, imm_ex};
    wire [DATA_WIDTH-1:0] immu  = {16'b0, imm_ex};

    reg  [DATA_WIDTH-1:0] reg_s_data;
    reg  [DATA_WIDTH-1:0] reg_t_data;
    wire [1:0]            reg_s_data_sel;
    wire [1:0]            reg_t_data_sel;

    wire [DATA_WIDTH-1:0] alu_data;
    reg  [DATA_WIDTH-1:0] alu_a;
    reg  [DATA_WIDTH-1:0] alu_b;

    alu #(.DATA_WIDTH(DATA_WIDTH)) alu (
        .opcode(alu_op_ex),
        .a(alu_a),
        .b(alu_b),
        .result(alu_data)
    );

    forward #(.ADDR_WIDTH(ADDR_WIDTH)) forward (
        .reg_s_addr_ex(reg_s_addr_ex),
        .reg_t_addr_ex(reg_t_addr_ex),
        .reg_d_we_mem(reg_d_we_mem),
        .reg_d_addr_mem(reg_d_addr_mem),
        .reg_d_we_wb(reg_d_we_wb),
        .reg_d_addr_wb(reg_d_addr_wb),
        .reg_s_data_sel(reg_s_data_sel),
        .reg_t_data_sel(reg_t_data_sel)
    );

    always @*
        case (reg_t_data_sel)
            `REG_T_DATA_SEL_EX:  reg_t_data = reg_t_data_ex;
            `REG_T_DATA_SEL_MEM: reg_t_data = reg_d_data_mem;
            `REG_T_DATA_SEL_WB:  reg_t_data = reg_d_data_wb;
            default:             reg_t_data = {DATA_WIDTH{1'bx}};
        endcase

    always @*
        case (reg_s_data_sel)
            `REG_S_DATA_SEL_EX:  reg_s_data = reg_s_data_ex;
            `REG_S_DATA_SEL_MEM: reg_s_data = reg_d_data_mem;
            `REG_S_DATA_SEL_WB:  reg_s_data = reg_d_data_wb;
            default:             reg_s_data = {DATA_WIDTH{1'bx}};
        endcase

    always @*
        case (alu_a_sel_ex)
            `ALU_A_SEL_RS:    alu_a = reg_s_data;
            `ALU_A_SEL_SHAMT: alu_a = shamt;
            `ALU_A_SEL_16:    alu_a = 'd16;
            default:          alu_a = {DATA_WIDTH{1'bx}};
        endcase

    always @*
        case (alu_b_sel_ex)
            `ALU_B_SEL_RT:   alu_b = reg_t_data;
            `ALU_B_SEL_IMMS: alu_b = imms;
            `ALU_B_SEL_IMMU: alu_b = immu;
            default:         alu_b = {DATA_WIDTH{1'bx}};
        endcase

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
