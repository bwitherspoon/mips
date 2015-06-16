/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`include "timescale.vh"

module cpu (
    input clk_i,
    input rst_i
);
    // Control path
    wire [3:0]  alu_op;      // ctl -> ex
    wire        alu_sel;     // ctk -> ex
    wire        alu_zero;    // ex  -> ctl
    wire        mem_en;      // ctl -> mem
    wire        pc_load;     // ctl -> if
    wire        rd_en;       // ctl -> reg
    wire        rd_sel;      // ctl -> id
    wire        rd_data_sel; // ctl -> wb

    // Data path
    wire [31:0] alu_data;    // ex -> wb

    wire [5:0]  opcode;      // id -> ctl
    wire [4:0]  shamt;       // id -> ex
    wire [5:0]  funct;       // id -> ex
    wire [31:0] imm;         // id -> ex

    wire [31:0] pc;          // if -> ex
    wire [31:0] pc_data;     // ex -> if

    wire [31:0] ir;          // if -> id

    wire [4:0] rd;           // id -> reg
    wire [4:0] rs;           // id -> reg
    wire [4:0] rt;           // id -> reg

    wire [31:0] rd_data;     // wb -> reg
    wire [31:0] rs_data;     // reg -> ex
    wire [31:0] rt_data;     // reg -> ex, reg -> mem

    wire [4:0]  mem_addr;    // wb -> mem
    wire [31:0] mem_data;    // mem -> wb

    fetch fetch (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .pc_load_i(pc_load),
        .pc_data_i(pc_data),
        .pc_o(pc),
        .ir_o(ir)
    );

    control control (
        .opcode_i(opcode),
        .funct_i(funct),
        .alu_zero_i(alu_zero),
        .alu_op_o(alu_op),
        .alu_sel_o(alu_sel),
        .mem_en_o(mem_en),
        .pc_load_o(pc_load),
        .rd_sel_o(rd_sel),
        .rd_data_sel_o(rd_data_sel),
        .rd_en_o(rd_en)
    );

    decode decode (
        .ir_i(ir),
        .rd_sel_i(rd_sel),
        .opcode_o(opcode),
        .rd_o(rd),
        .rs_o(rs),
        .rt_o(rt),
        .shamt_o(shamt),
        .funct_o(funct),
        .imm_o(imm)
    );

    regfile regfile (
        .clk_i(clk_i),
        .rd_i(rd),
        .rd_data_i(rd_data),
        .rd_en_i(rd_en),
        .rs_i(rs),
        .rt_i(rt),
        .rs_data_o(rs_data),
        .rt_data_o(rt_data)
    );

    execute execute (
        .alu_op_i(alu_op),
        .alu_sel_i(alu_sel),
        .pc_i(pc),
        .shamt_i(shamt),
        .imm_i(imm),
        .rs_data_i(rs_data),
        .rt_data_i(rt_data),
        .alu_data_o(alu_data),
        .alu_zero_o(alu_zero),
        .pc_data_o(pc_data)
    );

    memory memory(
        .clk_i(clk_i),
        .addr_i(mem_addr),
        .data_i(rt_data),
        .wen_i(mem_en),
        .data_o(mem_data)
    );

    write write(
        .alu_data_i(alu_data),
        .mem_data_i(mem_data),
        .rd_data_sel_i(rd_data_sel),
        .mem_addr_o(mem_addr),
        .rd_data_o(rd_data)
    );

endmodule
