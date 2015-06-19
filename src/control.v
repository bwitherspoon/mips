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
    output reg alu_a_sel,
    output reg alu_b_sel,
    output reg mem_we,
    output reg reg_d_we,
    output reg reg_d_addr_sel,
    output reg reg_d_data_sel,
    output reg jump
);

    initial begin
        alu_op = `ALU_SLL;
        alu_a_sel = `ALU_A_SEL_RS;
        alu_b_sel = `ALU_A_SEL_RT;
        jump = 0;
        mem_we = 0;
        reg_d_addr_sel = `REG_D_ADDR_SEL_RT;
        reg_d_data_sel = `REG_D_DATA_SEL_ALU;
        reg_d_we = 0;
    end

    always @*
        case (opcode)
            `OPCODE_RTYPE: begin
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_A_SEL_RT;
                jump = 0;
                mem_we = 0;
                reg_d_addr_sel = `REG_D_ADDR_SEL_RD;
                reg_d_data_sel = `REG_D_DATA_SEL_ALU;
                reg_d_we = 1;
                case (funct)
                    `FUNCT_ADD:
                        alu_op = `ALU_ADD;
                    `FUNCT_SUB:
                        alu_op = `ALU_SUB;
                    `FUNCT_AND:
                        alu_op = `ALU_AND;
                    `FUNCT_OR:
                        alu_op = `ALU_OR;
                    `FUNCT_SLT:
                        alu_op = `ALU_SLT;
                    `FUNCT_SLL: begin
                        alu_op = `ALU_SLL;
                        alu_a_sel = `ALU_A_SEL_SHAMT;
                    end
                    `FUNCT_SRA: begin
                        alu_op = `ALU_SRA;
                        alu_a_sel = `ALU_A_SEL_SHAMT;
                    end
                    `FUNCT_SRL: begin
                        alu_op = `ALU_SRL;
                        alu_a_sel = `ALU_A_SEL_SHAMT;
                    end
                    default: begin
                        alu_op = `ALU_SLL;
                        reg_d_we = 0;
`ifndef SYNTHESIS
                        $display("%0d: Invalid function field value: 0x%h", $time, funct);
`endif
                    end
                endcase
            end
            `OPCODE_ADDI: begin
                alu_op = `ALU_ADD;
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_B_SEL_IMM;
                jump = 0;
                mem_we = 0;
                reg_d_addr_sel = `REG_D_ADDR_SEL_RT;
                reg_d_data_sel = `REG_D_DATA_SEL_ALU;
                reg_d_we = 1;
            end
            `OPCODE_LW: begin
                alu_op = `ALU_ADD;
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_B_SEL_IMM;
                jump = 0;
                mem_we = 0;
                reg_d_addr_sel = `REG_D_ADDR_SEL_RT;
                reg_d_data_sel = `REG_D_DATA_SEL_MEM;
                reg_d_we = 1;
            end
            `OPCODE_SW: begin
                alu_op = `ALU_ADD;
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_B_SEL_IMM;
                jump = 0;
                mem_we = 1;
                reg_d_addr_sel = 1'bX;
                reg_d_data_sel = 1'bX;
                reg_d_we = 0;
            end
            `OPCODE_BEQ: begin
                alu_op = `ALU_SUB;
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_B_SEL_IMM;
                jump = equal;
                mem_we = 0;
                reg_d_addr_sel = 1'bX;
                reg_d_data_sel = 1'bX;
                reg_d_we = 0;
            end
            default: begin // invalid (nop)
                alu_op = `ALU_SLL;
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_A_SEL_RT;
                jump = 0;
                mem_we = 0;
                reg_d_addr_sel = `REG_D_ADDR_SEL_RT;
                reg_d_data_sel = `REG_D_DATA_SEL_ALU;
                reg_d_we = 0;
`ifndef SYNTHESIS
                $display("%0d: Invalid opcode: 0x%h", $time, opcode);
`endif
            end
        endcase
endmodule
