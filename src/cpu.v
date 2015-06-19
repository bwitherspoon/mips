/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module cpu (
    input clk,
    input rst,
    inout [31:0] gpio
);
    /*
     *  Control path
     */

    // id -> ex
    wire [3:0] alu_op_ex;
    wire       alu_a_sel_ex;
    wire       alu_b_sel_ex;
    // id -> mem
    wire       mem_we_ex;
    wire       mem_we_mem;
    // id -> if
    wire       jump;
    // id -> reg
    wire       reg_d_we_ex;
    wire       reg_d_we_mem;
    wire       reg_d_we_wb;
    wire       reg_d_we;
    // id -> wb
    wire       reg_d_data_sel_ex;
    wire       reg_d_data_sel_mem;
    wire       reg_d_data_sel_wb;

    /*
     *  Data path
     */

    // id -> ex
    wire [31:0] imm_ex;
    wire [31:0] reg_s_data_ex;
    wire [31:0] reg_t_data_ex;
    // if -> id
    wire [31:0] pc_id;
    wire [31:0] ir_id;
    // id -> if
    wire [31:0] addr;
    // id -> reg
    wire [4:0]  reg_d_addr_ex;
    wire [4:0]  reg_d_addr_mem;
    wire [4:0]  reg_d_addr_wb;
    wire [4:0]  reg_d_addr;
    wire [4:0]  reg_s_addr;
    wire [4:0]  reg_t_addr;
    // wb -> reg
    wire [31:0] reg_d_data;
    // reg -> id
    wire [31:0] reg_s_data;
    wire [31:0] reg_t_data;
    // ex -> mem
    wire [31:0] alu_data_mem;
    wire [31:0] reg_t_data_mem;
    // mem -> wb
    wire [31:0] alu_data_wb;
    wire [31:0] mem_data_wb;

    fetch fetch (
        .clk(clk),
        .rst(rst),
        // id -> if
        .jump(jump),
        .addr(addr),
        // if -> id
        .pc_id(pc_id),
        .ir_id(ir_id)
    );

    decode decode (
        .clk(clk),
        // if -> id
        .pc_id(pc_id),
        .ir_id(ir_id),
        // reg -> id
        .reg_s_data(reg_s_data),
        .reg_t_data(reg_t_data),
        // id -> if
        .jump(jump),
        .addr(addr),
        // id -> reg
        .reg_s_addr(reg_s_addr),
        .reg_t_addr(reg_t_addr),
        // id -> ex
        .imm_ex(imm_ex),
        .reg_d_we_ex(reg_d_we_ex),
        .reg_d_addr_ex(reg_d_addr_ex),
        .reg_s_data_ex(reg_s_data_ex),
        .reg_t_data_ex(reg_t_data_ex),
        .reg_d_data_sel_ex(reg_d_data_sel_ex),
        .alu_op_ex(alu_op_ex),
        .alu_a_sel_ex(alu_a_sel_ex),
        .alu_b_sel_ex(alu_b_sel_ex),
        .mem_we_ex(mem_we_ex)
    );

    regfile regfile (
        .clk(clk),
        // wb -> reg
        .d_we(reg_d_we),
        .d_addr(reg_d_addr),
        .d_data(reg_d_data),
        // id -> reg
        .s_addr(reg_s_addr),
        .t_addr(reg_t_addr),
        // reg -> id
        .s_data(reg_s_data),
        .t_data(reg_t_data)
    );

    execute execute (
        .clk(clk),
        // id -> ex
        .alu_op_ex(alu_op_ex),
        .alu_a_sel_ex(alu_a_sel_ex),
        .alu_b_sel_ex(alu_b_sel_ex),
        .imm_ex(imm_ex),
        .mem_we_ex(mem_we_ex),
        .reg_d_we_ex(reg_d_we_ex),
        .reg_d_addr_ex(reg_d_addr_ex),
        .reg_d_data_sel_ex(reg_d_data_sel_ex),
        .reg_s_data_ex(reg_s_data_ex),
        .reg_t_data_ex(reg_t_data_ex),
        // ex -> mem
        .alu_data_mem(alu_data_mem),
        .reg_d_we_mem(reg_d_we_mem),
        .reg_d_addr_mem(reg_d_addr_mem),
        .reg_d_data_sel_mem(reg_d_data_sel_mem),
        .reg_t_data_mem(reg_t_data_mem),
        .mem_we_mem(mem_we_mem)
    );

    memory memory(
        .clk(clk),
        // mem -> gpio
        .gpio(gpio),
        // mem -> ex
        .alu_data_mem(alu_data_mem),
        .reg_d_we_mem(reg_d_we_mem),
        .reg_d_addr_mem(reg_d_addr_mem),
        .reg_d_data_sel_mem(reg_d_data_sel_mem),
        .reg_t_data_mem(reg_t_data_mem),
        .mem_we_mem(mem_we_mem),
        // mem -> wb
        .alu_data_wb(alu_data_wb),
        .mem_data_wb(mem_data_wb),
        .reg_d_we_wb(reg_d_we_wb),
        .reg_d_addr_wb(reg_d_addr_wb),
        .reg_d_data_sel_wb(reg_d_data_sel_wb)
    );

    write write(
        // mem -> wb
        .alu_data_wb(alu_data_wb),
        .mem_data_wb(mem_data_wb),
        .reg_d_we_wb(reg_d_we_wb),
        .reg_d_addr_wb(reg_d_addr_wb),
        .reg_d_data_sel_wb(reg_d_data_sel_wb),
        // wb -> reg
        .reg_d_we(reg_d_we),
        .reg_d_addr(reg_d_addr),
        .reg_d_data(reg_d_data)
    );

endmodule
