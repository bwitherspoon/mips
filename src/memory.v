/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module memory
#(
    parameter ADDR_SIZE = 10,
    parameter WORD_SIZE = 32
)(
    input                      clk,
    // mem -> gpio
    inout      [WORD_SIZE-1:0] gpio,
    // mem -> ex
    input      [WORD_SIZE-1:0] alu_data_ex_mem,
    input                      rd_en_ex_mem,
    input      [4:0]           rd_addr_ex_mem,
    input                      rd_data_sel_ex_mem,
    input      [WORD_SIZE-1:0] rt_data_ex_mem,
    input                      mem_en_ex_mem,
    // mem -> wb
    output reg [WORD_SIZE-1:0] alu_data_mem_wb,
    output reg [WORD_SIZE-1:0] mem_data_mem_wb,
    output reg                 rd_en_mem_wb,
    output reg [4:0]           rd_addr_mem_wb,
    output reg                 rd_data_sel_mem_wb
);

    wire [ADDR_SIZE-1:0] addr = alu_data_ex_mem[ADDR_SIZE-1:0];
    wire                 io   = alu_data_ex_mem == 32'hffffffff;

    reg [WORD_SIZE-1:0] gpio_reg = {WORD_SIZE{1'b0}};

    reg [WORD_SIZE-1:0] mem [0:2**ADDR_SIZE-1];

    integer i;
    initial begin
        for (i = 0; i < 2**ADDR_SIZE; i = i + 1)
            mem[i] = 0;
        rd_en_mem_wb = 0;
    end

`ifndef SYNTHESIS
    wire [WORD_SIZE-1:0] mem_ [0:2**ADDR_SIZE-1];
    genvar k;
    for (k = 0; k < 2**ADDR_SIZE; k = k + 1) begin : gen_mem
            assign mem_[k] = mem[k];
    end
`endif

    assign gpio = gpio_reg;

    always @(posedge clk)
        if (io)
            gpio_reg <= rt_data_ex_mem;
        else if (mem_en_ex_mem)
            mem[addr] <= rt_data_ex_mem;

    // Pipeline registers
    always @(posedge clk) begin
        alu_data_mem_wb    <= alu_data_ex_mem;
        mem_data_mem_wb    <= io ? gpio : mem[addr];
        rd_en_mem_wb       <= rd_en_ex_mem;
        rd_addr_mem_wb     <= rd_addr_ex_mem;
        rd_data_sel_mem_wb <= rd_data_sel_ex_mem;
    end

endmodule
