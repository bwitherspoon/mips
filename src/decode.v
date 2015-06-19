/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module decode (
    input             clk,

    input      [31:0] pc_if_id,
    input      [31:0] ir_if_id,
    input      [31:0] rs_data,
    input      [31:0] rt_data,

    output     [31:0] addr,
    output     [4:0]  rs_addr,
    output     [4:0]  rt_addr,
    output            jump,

    output reg [3:0]  alu_op_id_ex,
    output reg        alu_a_sel_id_ex,
    output reg        alu_b_sel_id_ex,
    output reg        mem_en_id_ex,
    output reg [31:0] imm_id_ex,
    output reg        rd_en_id_ex,
    output reg [4:0]  rd_addr_id_ex,
    output reg        rd_data_sel_id_ex,
    output reg [31:0] rs_data_id_ex,
    output reg [31:0] rt_data_id_ex
);

    wire [3:0]  alu_op;
    wire        alu_a_sel;
    wire        alu_b_sel;
    wire        mem_en;
    wire [31:0] imm;
    wire        rd_en;
    wire [4:0]  rd_addr;
    wire        rd_addr_sel;
    wire        rd_data_sel;
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
        .mem_en(mem_en),
        .jump(jump),
        .rd_addr_sel(rd_addr_sel),
        .rd_data_sel(rd_data_sel),
        .rd_en(rd_en)
    );

    // Fields
    assign rs_addr = ir_if_id[25:21];                         // first source register
    assign rt_addr = ir_if_id[20:16];                         // second source register
    assign rd_addr = rd_addr_sel ? ir_if_id[15:11] : rt_addr; // destination register

    assign opcode = ir_if_id[31:26];                          // opcode field
    assign funct = ir_if_id[5:0];                             // function field
    assign imm = {{16{ir_if_id[15]}}, ir_if_id[15:0]};        // immediate field

    // Handle branch and jump instructions early in the pipeline
    assign addr = $signed(pc_if_id) + $signed(imm);
    assign equal = rs_data == rt_data;

    // Pipeline registers
    always @(posedge clk) begin
        alu_op_id_ex      <= alu_op;
        alu_a_sel_id_ex   <= alu_a_sel;
        alu_b_sel_id_ex   <= alu_b_sel;
        mem_en_id_ex      <= mem_en;
        imm_id_ex         <= imm;
        rd_en_id_ex       <= rd_en;
        rd_addr_id_ex     <= rd_addr;
        rs_data_id_ex     <= rs_addr == 5'd0 ? 32'd0 : rs_data;
        rt_data_id_ex     <= rt_addr == 5'd0 ? 32'd0 : rt_data;
        rd_data_sel_id_ex <= rd_data_sel;
    end

endmodule
