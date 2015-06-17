/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module control (
    input [5:0] opcode,
    input [5:0] funct,
    input       alu_zero,

    output reg [3:0] alu_op,
    output reg alu_sel,
    output reg mem_en,
    output reg pc_load,
    output reg rd_addr_sel,
    output reg rd_data_sel,
    output reg rd_en
);

    initial begin // nop
        alu_op = `ALU_OP_AND;
        alu_sel = 0;
        pc_load = 0;
        mem_en = 0;
        rd_addr_sel = 0;
        rd_data_sel = 0;
        rd_en = 0;
    end

    always @*
        case (opcode)
            `OPCODE_RTYPE: begin
                case (funct)
                    `FUNCT_ADD: alu_op = `ALU_OP_ADD;
                    `FUNCT_SUB: alu_op = `ALU_OP_SUB;
                    `FUNCT_AND: alu_op = `ALU_OP_AND;
                    `FUNCT_OR : alu_op = `ALU_OP_OR;
                    `FUNCT_SLT: alu_op = `ALU_OP_SLT;
                    default   : alu_op = `ALU_OP_AND;
                endcase
                alu_sel = `ALU_SEL_REG;
                pc_load = 0;
                mem_en = 0;
                rd_addr_sel = `RD_SEL_RD;
                rd_data_sel = `RD_DATA_SEL_ALU;
                rd_en = 1;
            end
            `OPCODE_ADDI: begin
                alu_op = `ALU_OP_ADD;
                alu_sel = `ALU_SEL_IMM;
                pc_load = 0;
                mem_en = 0;
                rd_addr_sel = `RD_SEL_RT;
                rd_data_sel = `RD_DATA_SEL_ALU;
                rd_en = 1;
            end
            `OPCODE_LW: begin
                alu_op = `ALU_OP_ADD;
                alu_sel = `ALU_SEL_IMM;
                pc_load = 0;
                mem_en = 0;
                rd_addr_sel = `RD_SEL_RT;
                rd_data_sel = `RD_DATA_SEL_MEM;
                rd_en = 1;
            end
            `OPCODE_SW: begin
                alu_op = `ALU_OP_ADD;
                alu_sel = `ALU_SEL_IMM;
                pc_load = 0;
                mem_en = 1;
                rd_addr_sel = 1'bX;
                rd_data_sel = 1'bX;
                rd_en = 0;
            end
            `OPCODE_BEQ: begin
                alu_op = `ALU_OP_SUB;
                alu_sel = `ALU_SEL_IMM;
                pc_load = alu_zero;
                mem_en = 0;
                rd_addr_sel = 1'bX;
                rd_data_sel = 1'bX;
                rd_en = 0;
            end
            default: begin // invalid (nop)
                alu_op = `ALU_OP_AND;
                alu_sel = 0;
                pc_load = 0;
                mem_en = 0;
                rd_addr_sel = 0;
                rd_data_sel = 0;
                rd_en = 0;
            end
        endcase
endmodule
