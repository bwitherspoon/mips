/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module execute #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 32
)(
    input                      clk,
    // id -> ex
    input      [3:0]            alu_op_ex,
    input      [1:0]            alu_a_sel_ex,
    input      [1:0]            alu_b_sel_ex,
    input      [DATA_WIDTH-1:0] imm_ex,
    input      [3:0]            mem_we_ex,
    input                       reg_d_we_ex,
    input      [ADDR_WIDTH-1:0] reg_d_addr_ex,
    input                       reg_d_data_sel_ex,
    input      [DATA_WIDTH-1:0] reg_s_data_ex,
    input      [DATA_WIDTH-1:0] reg_t_data_ex,
    // ex -> mem
    output reg [DATA_WIDTH-1:0] alu_data_mem,
    output reg                  reg_d_we_mem,
    output reg [ADDR_WIDTH-1:0] reg_d_addr_mem,
    output reg                  reg_d_data_sel_mem,
    output reg [DATA_WIDTH-1:0] reg_t_data_mem,
    output reg [3:0]            mem_we_mem
);

    wire [DATA_WIDTH-1:0] shamt = {27'h0000000, imm_ex[10:6]};
    wire [DATA_WIDTH-1:0] alu_data;
    reg  [DATA_WIDTH-1:0] alu_a;
    reg  [DATA_WIDTH-1:0] alu_b;

    alu #(.DATA_WIDTH(DATA_WIDTH)) alu (
        .opcode(alu_op_ex),
        .a(alu_a),
        .b(alu_b),
        .result(alu_data)
    );

    always @*
        case (alu_a_sel_ex)
            `ALU_A_SEL_RS:    alu_a = reg_s_data_ex;
            `ALU_A_SEL_SHAMT: alu_a = shamt;
            `ALU_A_SEL_16:    alu_a = 32'h10;
            default:          alu_a = {32{1'bx}};
        endcase

    always @*
        case (alu_b_sel_ex)
            `ALU_B_SEL_RT:   alu_b = reg_t_data_ex;
            `ALU_B_SEL_IMM:  alu_b = imm_ex;
            `ALU_B_SEL_IMMU: alu_b = {16'h0000, imm_ex[15:0]};
            default:         alu_b = {32{1'bx}};
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
