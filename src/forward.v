/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

`include "defines.vh"

module forward #(
    parameter ADDR_WIDTH = 5
)(
    // ex -> fw
    input  [ADDR_WIDTH-1:0] reg_s_addr_ex,
    input  [ADDR_WIDTH-1:0] reg_t_addr_ex,
    // mem -> fw
    input                   reg_d_we_mem,
    input  [ADDR_WIDTH-1:0] reg_d_addr_mem,
    // wb -> fw
    input                   reg_d_we_wb,
    input  [ADDR_WIDTH-1:0] reg_d_addr_wb,
    // fw -> ex
    output reg [1:0]        reg_s_data_sel,
    output reg [1:0]        reg_t_data_sel
);

    wire mem = reg_d_we_mem == 1 && reg_d_addr_mem != 0;
    wire wb  = reg_d_we_wb  == 1 && reg_d_addr_wb  != 0;

    always @*
        if (mem && reg_d_addr_mem == reg_s_addr_ex)
            reg_s_data_sel = `REG_S_DATA_SEL_MEM;
        else if (wb && reg_d_addr_wb == reg_s_addr_ex)
            reg_s_data_sel = `REG_S_DATA_SEL_WB;
        else
            reg_s_data_sel = `REG_S_DATA_SEL_EX;

    always @*
        if (mem && reg_d_addr_mem == reg_t_addr_ex)
            reg_t_data_sel = `REG_T_DATA_SEL_MEM;
        else if (wb && reg_d_addr_wb == reg_t_addr_ex)
            reg_t_data_sel = `REG_T_DATA_SEL_WB;
        else
            reg_t_data_sel = `REG_T_DATA_SEL_EX;

endmodule
