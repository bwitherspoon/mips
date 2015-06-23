/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module control (
    input      [5:0] opcode,
    input      [5:0] funct,
    input            reg_s_t_equal,

    output reg [3:0] alu_op,
    output reg [1:0] alu_a_sel,
    output reg       alu_b_sel,
    output reg [3:0] mem_we,
    output reg       reg_d_we,
    output reg       reg_d_addr_sel,
    output reg       reg_d_data_sel,
    output reg       pc_we
);

    initial begin // nop
        alu_op = `ALU_SLL;
        alu_a_sel = `ALU_A_SEL_RS;
        alu_b_sel = `ALU_B_SEL_RT;
        pc_we = 1'b0;
        mem_we = 4'h0;
        reg_d_addr_sel = `REG_D_ADDR_SEL_RT;
        reg_d_data_sel = `REG_D_DATA_SEL_ALU;
        reg_d_we = 1'b0;
    end

    always @*
        case (opcode)
            `OPCODE_RTYPE: begin
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_B_SEL_RT;
                pc_we = 1'b0;
                mem_we = 4'h0;
                reg_d_addr_sel = `REG_D_ADDR_SEL_RD;
                reg_d_data_sel = `REG_D_DATA_SEL_ALU;
                reg_d_we = 1'b1;
                case (funct)
                    `FUNCT_ADD: begin
                        alu_op = `ALU_ADD;
                    end
                    `FUNCT_SUB: begin
                        alu_op = `ALU_SUB;
                    end
                    `FUNCT_AND: begin
                        alu_op = `ALU_AND;
                    end
                    `FUNCT_OR: begin
                        alu_op = `ALU_OR;
                    end
                    `FUNCT_SLT: begin
                        alu_op = `ALU_SLT;
                    end
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
                        alu_op = 4'bxxxx;
                        reg_d_we = 1'b0;
`ifndef SYNTHESIS
                        $display("ERROR: [%0d] Invalid function: 0x%h", $time, funct);
`endif
                    end
                endcase
            end
            `OPCODE_ADDI: begin
                alu_op = `ALU_ADD;
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_B_SEL_IMM;
                pc_we = 1'b0;
                mem_we = 4'h0;
                reg_d_addr_sel = `REG_D_ADDR_SEL_RT;
                reg_d_data_sel = `REG_D_DATA_SEL_ALU;
                reg_d_we = 1;
            end
            `OPCODE_LUI: begin
                alu_op = `ALU_SLL;
                alu_a_sel = `ALU_A_SEL_16;
                alu_b_sel = `ALU_B_SEL_IMM;
                pc_we = 1'b0;
                mem_we = 4'h0;
                reg_d_addr_sel = `REG_D_ADDR_SEL_RT;
                reg_d_data_sel = `REG_D_DATA_SEL_ALU;
                reg_d_we = 1;
            end
            `OPCODE_LW: begin
                alu_op = `ALU_ADD;
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_B_SEL_IMM;
                pc_we = 1'b0;
                mem_we = 4'h0;
                reg_d_addr_sel = `REG_D_ADDR_SEL_RT;
                reg_d_data_sel = `REG_D_DATA_SEL_MEM;
                reg_d_we = 1'b1;
            end
            `OPCODE_SW: begin
                alu_op = `ALU_ADD;
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_B_SEL_IMM;
                pc_we = 1'b0;
                mem_we = 4'hF;
                reg_d_addr_sel = 1'bx;
                reg_d_data_sel = 1'bx;
                reg_d_we = 1'b0;
            end
            `OPCODE_BEQ: begin
                alu_op = `ALU_SUB;
                alu_a_sel = `ALU_A_SEL_RS;
                alu_b_sel = `ALU_B_SEL_IMM;
                pc_we = reg_s_t_equal;
                mem_we = 4'h0;
                reg_d_addr_sel = 1'bx;
                reg_d_data_sel = 1'bx;
                reg_d_we = 1'b0;
            end
            default: begin // invalid
                alu_op = 4'bxxxx;
                alu_a_sel = 1'bx;
                alu_b_sel = 1'bx;
                pc_we = 1'b0;
                mem_we = 4'b0;
                reg_d_addr_sel = 1'bx;
                reg_d_data_sel = 1'bx;
                reg_d_we = 1'b0;
`ifndef SYNTHESIS
                $display("ERROR: [%0d] Invalid CPU opcode: 0x%h", $time, opcode);
`endif
            end
        endcase
endmodule
