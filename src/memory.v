/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module memory #(
    parameter ADDR_WIDTH = 9,
    parameter DATA_WIDTH = 32,
    parameter REGS_DEPTH = 5
)(
    input                         clk,
    // mem -> gpio
    inout      [DATA_WIDTH-1:0]   gpio,
    // ex -> mem
    input      [DATA_WIDTH-1:0]   alu_data_mem,
    input                         reg_d_we_mem,
    input      [REGS_DEPTH-1:0]   reg_d_addr_mem,
    input                         reg_d_data_sel_mem,
    input      [DATA_WIDTH-1:0]   reg_t_data_mem,
    input      [DATA_WIDTH/8-1:0] mem_we_mem,
    // mem -> wb
    output reg [DATA_WIDTH-1:0]   alu_data_wb,
    output reg [DATA_WIDTH-1:0]   mem_data_wb,
    output reg                    reg_d_we_wb,
    output reg [REGS_DEPTH-1:0]   reg_d_addr_wb,
    output reg                    reg_d_data_sel_wb,
    // mem -> ram
    output     [DATA_WIDTH/8-1:0] ram_we_a,
    output     [ADDR_WIDTH-1:0]   ram_addr_a,
    output     [DATA_WIDTH-1:0]   ram_wdata_a,
    input      [DATA_WIDTH-1:0]   ram_rdata_a
);

    wire io = (alu_data_mem == 32'hffffffff) && (| mem_we_mem);

    reg [DATA_WIDTH-1:0] gpio_reg = {DATA_WIDTH{1'b0}};

    assign gpio = gpio_reg;

    assign ram_we_a    = io ? 4'h0 : mem_we_mem;
    assign ram_addr_a  = alu_data_mem[ADDR_WIDTH-1:0];
    assign ram_wdata_a = reg_t_data_mem;

    always @(posedge clk)
        if (io)
            gpio_reg <= reg_t_data_mem;

    // Pipeline registers
    always @(posedge clk) begin
        alu_data_wb       <= alu_data_mem;
        mem_data_wb       <= io ? gpio : ram_rdata_a;
        reg_d_we_wb       <= reg_d_we_mem;
        reg_d_addr_wb     <= reg_d_addr_mem;
        reg_d_data_sel_wb <= reg_d_data_sel_mem;
    end

endmodule
