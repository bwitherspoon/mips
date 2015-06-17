/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module cpu (
    input clk,
    input rst
);
    // Control path
    wire [3:0] alu_op;         // ctl -> ex
    wire       alu_sel;        // ctk -> ex
    wire       alu_zero;       // ex  -> ctl
    wire       mem_en;         // ctl -> mem
    wire       pc_load;        // ctl -> if
    wire       rd_en;       // ctl -> reg
    wire       rd_addr_sel; // ctl -> id
    wire       rd_data_sel; // ctl -> wb

    // Data path
    wire [31:0] alu_data;    // ex -> wb

    wire [5:0]  opcode;      // id -> ctl
    wire [4:0]  shamt;       // id -> ex
    wire [5:0]  funct;       // id -> ex
    wire [31:0] imm;         // id -> ex

    wire [31:0] pc;          // if -> ex
    wire [31:0] pc_addr;     // ex -> if

    wire [31:0] ir;          // if -> id

    wire [4:0] rd;           // id -> reg
    wire [4:0] rs;           // id -> reg
    wire [4:0] rt;           // id -> reg

    wire [31:0] rd_data;  // wb -> reg
    wire [31:0] rs_data;  // reg -> ex
    wire [31:0] rt_data;  // reg -> ex, reg -> mem

    wire [4:0]  mem_addr;    // wb -> mem
    wire [31:0] mem_data;    // mem -> wb

    fetch fetch (
        .clk(clk),
        .rst(rst),
        .load(pc_load),
        .addr(pc_addr),
        .pc(pc),
        .ir(ir)
    );

    control control (
        .opcode(opcode),
        .funct(funct),
        .alu_zero(alu_zero),
        .alu_op(alu_op),
        .alu_sel(alu_sel),
        .mem_en(mem_en),
        .pc_load(pc_load),
        .rd_addr_sel(rd_addr_sel),
        .rd_data_sel(rd_data_sel),
        .rd_en(rd_en)
    );

    decode decode (
        .ir(ir),
        .rd_addr_sel(rd_addr_sel),
        .opcode(opcode),
        .rd(rd),
        .rs(rs),
        .rt(rt),
        .shamt(shamt),
        .funct(funct),
        .imm(imm)
    );

    regfile regfile (
        .clk(clk),
        .rd_addr(rd),
        .rd_data(rd_data),
        .rd_en(rd_en),
        .rt_addr(rt),
        .rt_data(rt_data),
        .rs_addr(rs),
        .rs_data(rs_data)
    );

    execute execute (
        .alu_op(alu_op),
        .alu_sel(alu_sel),
        .pc(pc),
        .shamt(shamt),
        .imm(imm),
        .rs_data(rs_data),
        .rt_data(rt_data),
        .alu_data(alu_data),
        .alu_zero(alu_zero),
        .pc_addr(pc_addr)
    );

    memory memory(
        .clk(clk),
        .addr(mem_addr),
        .wdata(rd_data),
        .wen(mem_en),
        .rdata(mem_data)
    );

    write write(
        .alu_data(alu_data),
        .mem_data(mem_data),
        .rd_data_sel(rd_data_sel),
        .mem_addr(mem_addr),
        .rd_data(rd_data)
    );

endmodule
