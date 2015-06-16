/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`include "timescale.vh"

module regfile
#(
    parameter ADDR_SIZE = 5,
    parameter WORD_SIZE = 32
)(
    input clk_i,

    input  [ADDR_SIZE-1:0] rs_i,
    output [WORD_SIZE-1:0] rs_data_o,

    input  [ADDR_SIZE-1:0] rt_i,
    output [WORD_SIZE-1:0] rt_data_o,

    input                  rd_en_i,
    input  [ADDR_SIZE-1:0] rd_i,
    input  [WORD_SIZE-1:0] rd_data_i
);

    reg [WORD_SIZE-1:0] ram [0:2**ADDR_SIZE-1];

    integer i;
    initial
        for (i = 0; i < 2**ADDR_SIZE; i = i + 1)
            ram[i] = 0;

    always @(posedge clk_i)
        if (rd_en_i)
            ram[rd_i] <= rd_data_i;

    assign rs_data_o = ram[rs_i];
    assign rt_data_o = ram[rt_i];

endmodule
