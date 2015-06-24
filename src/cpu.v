/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module cpu (
    input        clk,
    input        reset,
    inout [31:0] gpio
);
    /*
     *  Control path
     */

    // id -> ex
    wire [3:0]  alu_op_ex;
    wire [1:0]  alu_a_sel_ex;
    wire [1:0]  alu_b_sel_ex;
    // id -> mem
    wire [3:0]  mem_we_ex;
    wire [3:0]  mem_we_mem;
    // id -> if
    wire        pc_we_id;
    // id -> wb
    wire        reg_d_we_ex;
    wire        reg_d_we_mem;
    wire        reg_d_we_wb;
    wire        reg_d_data_sel_ex;
    wire        reg_d_data_sel_mem;
    wire        reg_d_data_sel_wb;

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
    wire [31:0] pc_data_id;
    // id -> reg
    wire [4:0]  reg_d_addr_ex;
    wire [4:0]  reg_d_addr_mem;
    wire [4:0]  reg_d_addr_wb;
    wire [4:0]  reg_s_addr_id;
    wire [4:0]  reg_t_addr_id;
    // wb -> reg
    wire [31:0] reg_d_data_wb;
    // reg -> id
    wire [31:0] reg_s_data_id;
    wire [31:0] reg_t_data_id;
    // ex -> mem
    wire [31:0] alu_data_mem;
    wire [31:0] reg_t_data_mem;
    // mem -> wb
    wire [31:0] alu_data_wb;
    wire [31:0] mem_data_wb;
    // mem -> ram
    wire [3:0]  ram_we_mem;
    wire [8:0]  ram_addr_mem;
    wire [31:0] ram_wdata_mem;
    // ram -> mem
    wire [31:0] ram_rdata_mem;
    // if -> ram
    wire [8:0]  ram_addr_if;
    wire [31:0] ram_rdata_if;

    fetch fetch (
        .clk(clk),
        .reset(reset),
        // id -> if
        .pc_we(pc_we_id),
        .pc_data(pc_data_id),
        // if -> ram
        .ram_addr(ram_addr_if),
        .ram_data(ram_rdata_if),
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
        .reg_s_data_id(reg_s_data_id),
        .reg_t_data_id(reg_t_data_id),
        // id -> if
        .pc_we_id(pc_we_id),
        .pc_data_id(pc_data_id),
        // id -> reg
        .reg_s_addr_id(reg_s_addr_id),
        .reg_t_addr_id(reg_t_addr_id),
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
        .d_we(reg_d_we_wb),
        .d_addr(reg_d_addr_wb),
        .d_data(reg_d_data_wb),
        // id -> reg
        .s_addr(reg_s_addr_id),
        .t_addr(reg_t_addr_id),
        // reg -> id
        .s_data(reg_s_data_id),
        .t_data(reg_t_data_id)
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

    memory memory (
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
        .reg_d_data_sel_wb(reg_d_data_sel_wb),
        // mem -> ram
        .ram_we_a(ram_we_mem),
        .ram_addr_a(ram_addr_mem),
        .ram_rdata_a(ram_rdata_mem),
        .ram_wdata_a(ram_wdata_mem)
    );

    ram ram (
        .clk(clk),
        .reset(reset),
        // mem -> ram
        .we_a(ram_we_mem),
        .addr_a(ram_addr_mem),
        .wdata_a(ram_wdata_mem),
        .rdata_a(ram_rdata_mem),
        // if -> ram
        .addr_b(ram_addr_if),
        .rdata_b(ram_rdata_if)
    );

    write write (
        // mem -> wb
        .alu_data_wb(alu_data_wb),
        .mem_data_wb(mem_data_wb),
        .reg_d_data_sel_wb(reg_d_data_sel_wb),
        // wb -> reg
        .reg_d_data_wb(reg_d_data_wb)
    );

endmodule
