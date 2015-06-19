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
    input      [WORD_SIZE-1:0] alu_data_mem,
    input                      reg_d_we_mem,
    input      [4:0]           reg_d_addr_mem,
    input                      reg_d_data_sel_mem,
    input      [WORD_SIZE-1:0] reg_t_data_mem,
    input                      mem_we_mem,
    // mem -> wb
    output reg [WORD_SIZE-1:0] alu_data_wb,
    output reg [WORD_SIZE-1:0] mem_data_wb,
    output reg                 reg_d_we_wb,
    output reg [4:0]           reg_d_addr_wb,
    output reg                 reg_d_data_sel_wb
);

    wire [ADDR_SIZE-1:0] addr = alu_data_mem[ADDR_SIZE-1:0];
    wire                 io   = alu_data_mem == 32'hffffffff;

    reg [WORD_SIZE-1:0] gpio_reg = {WORD_SIZE{1'b0}};

    reg [WORD_SIZE-1:0] mem [0:2**ADDR_SIZE-1];

    integer i;
    initial for (i = 0; i < 2**ADDR_SIZE; i = i + 1) mem[i] = 0;

`ifdef __ICARUS__
    wire [WORD_SIZE-1:0] mem_ [0:2**ADDR_SIZE-1];
    genvar k;
    for (k = 0; k < 2**ADDR_SIZE; k = k + 1) begin : gen_mem
            assign mem_[k] = mem[k];
    end
`endif

    assign gpio = gpio_reg;

    always @(posedge clk)
        if (io)
            gpio_reg <= reg_t_data_mem;
        else if (mem_we_mem)
            mem[addr] <= reg_t_data_mem;

    // Pipeline registers
    always @(posedge clk) begin
        alu_data_wb    <= alu_data_mem;
        mem_data_wb    <= io ? gpio : mem[addr];
        reg_d_we_wb       <= reg_d_we_mem;
        reg_d_addr_wb     <= reg_d_addr_mem;
        reg_d_data_sel_wb <= reg_d_data_sel_mem;
    end

endmodule
