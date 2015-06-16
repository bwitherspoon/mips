/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`include "timescale.vh"
`include "defines.vh"

module control (
    input [5:0] opcode_i,
    input [5:0] funct_i,
    input       alu_zero_i,

    output reg [3:0] alu_op_o,
    output reg alu_sel_o,
    output reg mem_en_o,
    output reg pc_load_o,
    output reg rd_sel_o,
    output reg rd_data_sel_o,
    output reg rd_en_o
);

    reg [3:0] alu_op_funct;

    initial begin
        alu_op_o = `ALU_OP_AND;
        alu_sel_o = 0;
        pc_load_o = 0;
        mem_en_o = 0;
        rd_sel_o = 0;
        rd_data_sel_o = 0;
        rd_en_o = 0;
    end

    always @(*)
        case (funct_i)
            `FUNCT_ADD: alu_op_funct = `ALU_OP_ADD;
            `FUNCT_SUB: alu_op_funct = `ALU_OP_SUB;
            `FUNCT_AND: alu_op_funct = `ALU_OP_AND;
            `FUNCT_OR : alu_op_funct = `ALU_OP_OR;
            `FUNCT_SLT: alu_op_funct = `ALU_OP_SLT;
            default   : alu_op_funct = `ALU_OP_AND;
        endcase

    always @(*)
        case (opcode_i)
            `OPCODE_RTYPE: begin
                alu_op_o = alu_op_funct;
                alu_sel_o = `ALU_SEL_REG;
                pc_load_o = 0;
                mem_en_o = 0;
                rd_sel_o = `RD_SEL_RD;
                rd_data_sel_o = `RD_DATA_SEL_ALU;
                rd_en_o = 1;
            end
            `OPCODE_ADDI: begin
                alu_op_o = `ALU_OP_ADD;
                alu_sel_o = `ALU_SEL_IMM;
                pc_load_o = 0;
                mem_en_o = 0;
                rd_sel_o = `RD_SEL_RT;
                rd_data_sel_o = `RD_DATA_SEL_ALU;
                rd_en_o = 1;
            end
            `OPCODE_LW: begin
                alu_op_o = `ALU_OP_ADD;
                alu_sel_o = `ALU_SEL_IMM;
                pc_load_o = 0;
                mem_en_o = 0;
                rd_sel_o = `RD_SEL_RT;
                rd_data_sel_o = `RD_DATA_SEL_MEM;
                rd_en_o = 1;
            end
            `OPCODE_SW: begin
                alu_op_o = `ALU_OP_ADD;
                alu_sel_o = `ALU_SEL_IMM;
                pc_load_o = 0;
                mem_en_o = 1;
                rd_sel_o = `RD_SEL_RT;            // dont care
                rd_data_sel_o = `RD_DATA_SEL_MEM; // dont care
                rd_en_o = 0;
            end
            `OPCODE_BEQ: begin
                alu_op_o = `ALU_OP_SUB;
                alu_sel_o = `ALU_SEL_IMM;
                pc_load_o = alu_zero_i;
                mem_en_o = 0;
                rd_sel_o = `RD_SEL_RT;            // dont care
                rd_data_sel_o = `RD_DATA_SEL_ALU; // dont care
                rd_en_o = 0;
            end
            default: begin // invalid
                alu_op_o = `ALU_OP_AND;
                alu_sel_o = 0;
                pc_load_o = 0;
                mem_en_o = 0;
                rd_sel_o = 0;
                rd_data_sel_o = 0;
                rd_en_o = 0;
            end
        endcase
endmodule
