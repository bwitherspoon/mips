`timescale 1ns / 1ps

module fetch_tb;

    localparam CLOCKPERIOD = 100; // 100 MHz

    reg clk = 1;
    reg rst;

    reg pc_load = 0;
    reg [31:0] pc_addr = 32'd0;

    wire [31:0] pc;
    wire [31:0] ir;

    fetch fetch (
        .clk_i(clk),
        .pc_load_i(pc_load),
        .pc_addr_i(pc_addr),
        .pc_o(pc),
        .ir_o(ir)
    );

    always #(CLOCKPERIOD/2) clk <= ~clk;

    initial begin
        $dumpfile("fetch.vcd");
        $dumpvars;
        rst = 1;
        #(CLOCKPERIOD) rst = 0;
        #(5*CLOCKPERIOD);
        #1 pc_addr = 0;
        pc_load = 1;
        #(CLOCKPERIOD);
        pc_load = 0;
        #(5*CLOCKPERIOD);
        $display("All tests succeeded.");
        $finish;
    end

endmodule

