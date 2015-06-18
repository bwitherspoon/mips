/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module control (
    input [5:0] opcode,
    input [5:0] funct,
    input       equal,

    output reg [3:0] alu_op,
    output reg alu_sel,
    output reg mem_en,
    output reg rd_en,
    output reg rd_addr_sel,
    output reg rd_data_sel,
    output reg jump
);

    initial begin // nop
        alu_op = `ALU_OP_ADD;
        alu_sel = 0;
        jump = 0;
        mem_en = 0;
        rd_addr_sel = 0;
        rd_data_sel = 0;
        rd_en = 0;
    end

    always @*
        case (opcode)
            `OPCODE_RTYPE: begin
                rd_en = 1;
                case (funct)
                    `FUNCT_ADD:
                        alu_op = `ALU_OP_ADD;
                    `FUNCT_SUB:
                        alu_op = `ALU_OP_SUB;
                    `FUNCT_AND:
                        alu_op = `ALU_OP_AND;
                    `FUNCT_OR:
                        alu_op = `ALU_OP_OR;
                    `FUNCT_SLT:
                        alu_op = `ALU_OP_SLT;
                    `FUNCT_NOP: begin
                        alu_op = `ALU_OP_AND;
                        rd_en = 0;
                    end
                    default: begin
                        alu_op = `ALU_OP_AND;
                        rd_en = 0;
`ifndef SYNTHESIS
                        $display("%0d: Invalid function field value: 0x%h", $time, funct);
`endif
                    end
                endcase
                mem_en = 0;
                alu_sel = `ALU_SEL_REG;
                jump = 0;
                rd_addr_sel = `RD_SEL_RD;
                rd_data_sel = `RD_DATA_SEL_ALU;
            end
            `OPCODE_ADDI: begin
                alu_op = `ALU_OP_ADD;
                alu_sel = `ALU_SEL_IMM;
                jump = 0;
                mem_en = 0;
                rd_addr_sel = `RD_SEL_RT;
                rd_data_sel = `RD_DATA_SEL_ALU;
                rd_en = 1;
            end
            `OPCODE_LW: begin
                alu_op = `ALU_OP_ADD;
                alu_sel = `ALU_SEL_IMM;
                jump = 0;
                mem_en = 0;
                rd_addr_sel = `RD_SEL_RT;
                rd_data_sel = `RD_DATA_SEL_MEM;
                rd_en = 1;
            end
            `OPCODE_SW: begin
                alu_op = `ALU_OP_ADD;
                alu_sel = `ALU_SEL_IMM;
                jump = 0;
                mem_en = 1;
                rd_addr_sel = 1'bX;
                rd_data_sel = 1'bX;
                rd_en = 0;
            end
            `OPCODE_BEQ: begin
                alu_op = `ALU_OP_SUB;
                alu_sel = `ALU_SEL_IMM;
                jump = equal;
                mem_en = 0;
                rd_addr_sel = 1'bX;
                rd_data_sel = 1'bX;
                rd_en = 0;
            end
            default: begin // invalid (nop)
                alu_op = `ALU_OP_AND;
                alu_sel = 0;
                jump = 0;
                mem_en = 0;
                rd_addr_sel = 0;
                rd_data_sel = 0;
                rd_en = 0;
`ifndef SYNTHESIS
                $display("%0d: Invalid opcode: 0x%h", $time, opcode);
`endif
            end
        endcase
endmodule
