/*
 * Copyright (c) 2015 Brett Witherspoon
 */

`timescale 1ns / 1ps

module ram #(
    parameter ADDR_WIDTH = 9,
    parameter DATA_WIDTH = 32,
    parameter DATA_BYTES = DATA_WIDTH / 8
)(
    input                       clk,
    input                       reset,
    // Port A
    input      [DATA_BYTES-1:0] we_a,
    input      [ADDR_WIDTH-1:0] addr_a,
    input      [DATA_WIDTH-1:0] wdata_a,
    output reg [DATA_WIDTH-1:0] rdata_a,
    // Port B
    input      [ADDR_WIDTH-1:0] addr_b,
    output reg [DATA_WIDTH-1:0] rdata_b
);

    reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

`ifdef __ICARUS__
    wire [DATA_WIDTH-1:0] mem_ [0:2**ADDR_WIDTH-1];
    genvar k;
    for (k = 0; k < 2**ADDR_WIDTH; k = k + 1) begin : genmem
            assign mem_[k] = mem[k];
    end
`endif

    // Port A
    integer i;
    always @(posedge clk) begin
        for (i = 0; i < DATA_BYTES; i = i + 1)
            if (we_a[i])
                mem[addr_a][8*i +: 8] <= wdata_a[8*i +: 8];
        rdata_a <= mem[addr_a];
    end

    // Port B
    always @(posedge clk)
        rdata_b <= reset ? 0 : mem[addr_b];

endmodule
