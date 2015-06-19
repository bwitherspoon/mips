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
    wire [3:0] alu_op_id_ex;
    wire       alu_a_sel_id_ex;
    wire       alu_b_sel_id_ex;
    // id -> mem
    wire       mem_en_id_ex;
    wire       mem_en_ex_mem;
    // id -> if
    wire       jump;
    // id -> reg
    wire       rd_en_id_ex;
    wire       rd_en_ex_mem;
    wire       rd_en_mem_wb;
    wire       rd_en;
    // id -> wb
    wire       rd_data_sel_id_ex;
    wire       rd_data_sel_ex_mem;
    wire       rd_data_sel_mem_wb;

    /*
     *  Data path
     */

    // id -> ex
    wire [31:0] imm_id_ex;
    wire [31:0] rs_data_id_ex;
    wire [31:0] rt_data_id_ex;
    // if -> id
    wire [31:0] pc_if_id;
    wire [31:0] ir_if_id;
    // id -> if
    wire [31:0] addr;
    // id -> reg
    wire [4:0] rd_addr_id_ex;
    wire [4:0] rd_addr_ex_mem;
    wire [4:0] rd_addr_mem_wb;
    wire [4:0] rd_addr;
    wire [4:0] rs_addr;
    wire [4:0] rt_addr;
    // wb -> reg
    wire [31:0] rd_data;
    // reg -> id
    wire [31:0] rs_data;
    wire [31:0] rt_data;
    // ex -> mem
    wire [31:0] alu_data_ex_mem;
    wire [31:0] rt_data_ex_mem;
    // mem -> wb
    wire [31:0] alu_data_mem_wb;
    wire [31:0] mem_data_mem_wb;

    fetch fetch (
        .clk(clk),
        .rst(rst),
        // id -> if
        .jump(jump),
        .addr(addr),
        // if -> id
        .pc_if_id(pc_if_id),
        .ir_if_id(ir_if_id)
    );

    decode decode (
        .clk(clk),
        // if -> id
        .pc_if_id(pc_if_id),
        .ir_if_id(ir_if_id),
        // reg -> id
        .rs_data(rs_data),
        .rt_data(rt_data),
        // id -> if
        .jump(jump),
        .addr(addr),
        // id -> reg
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        // id -> ex
        .imm_id_ex(imm_id_ex),
        .rd_en_id_ex(rd_en_id_ex),
        .rd_addr_id_ex(rd_addr_id_ex),
        .rs_data_id_ex(rs_data_id_ex),
        .rt_data_id_ex(rt_data_id_ex),
        .rd_data_sel_id_ex(rd_data_sel_id_ex),
        .alu_op_id_ex(alu_op_id_ex),
        .alu_a_sel_id_ex(alu_a_sel_id_ex),
        .alu_b_sel_id_ex(alu_b_sel_id_ex),
        .mem_en_id_ex(mem_en_id_ex)
    );

    regfile regfile (
        .clk(clk),
        // wb -> reg
        .rd_en(rd_en),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        // id -> reg
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        // reg -> id
        .rs_data(rs_data),
        .rt_data(rt_data)
    );

    execute execute (
        .clk(clk),
        // id -> ex
        .alu_op_id_ex(alu_op_id_ex),
        .alu_a_sel_id_ex(alu_a_sel_id_ex),
        .alu_b_sel_id_ex(alu_b_sel_id_ex),
        .imm_id_ex(imm_id_ex),
        .mem_en_id_ex(mem_en_id_ex),
        .rd_en_id_ex(rd_en_id_ex),
        .rd_addr_id_ex(rd_addr_id_ex),
        .rd_data_sel_id_ex(rd_data_sel_id_ex),
        .rs_data_id_ex(rs_data_id_ex),
        .rt_data_id_ex(rt_data_id_ex),
        // ex -> mem
        .alu_data_ex_mem(alu_data_ex_mem),
        .rd_en_ex_mem(rd_en_ex_mem),
        .rd_addr_ex_mem(rd_addr_ex_mem),
        .rd_data_sel_ex_mem(rd_data_sel_ex_mem),
        .rt_data_ex_mem(rt_data_ex_mem),
        .mem_en_ex_mem(mem_en_ex_mem)
    );

    memory memory(
        .clk(clk),
        // mem -> gpio
        .gpio(gpio),
        // mem -> ex
        .alu_data_ex_mem(alu_data_ex_mem),
        .rd_en_ex_mem(rd_en_ex_mem),
        .rd_addr_ex_mem(rd_addr_ex_mem),
        .rd_data_sel_ex_mem(rd_data_sel_ex_mem),
        .rt_data_ex_mem(rt_data_ex_mem),
        .mem_en_ex_mem(mem_en_ex_mem),
        // mem -> wb
        .alu_data_mem_wb(alu_data_mem_wb),
        .mem_data_mem_wb(mem_data_mem_wb),
        .rd_en_mem_wb(rd_en_mem_wb),
        .rd_addr_mem_wb(rd_addr_mem_wb),
        .rd_data_sel_mem_wb(rd_data_sel_mem_wb)
    );

    write write(
        // mem -> wb
        .alu_data_mem_wb(alu_data_mem_wb),
        .mem_data_mem_wb(mem_data_mem_wb),
        .rd_en_mem_wb(rd_en_mem_wb),
        .rd_addr_mem_wb(rd_addr_mem_wb),
        .rd_data_sel_mem_wb(rd_data_sel_mem_wb),
        // wb -> reg
        .rd_en(rd_en),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

endmodule
