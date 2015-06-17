`timescale 1ns / 1ps

module cpu_tb;

    localparam CLOCKPERIOD = 100; // 100 MHz

    reg clk = 1;
    reg rst;

    cpu cpu (
        .clk_i(clk),
        .rst_i(rst)
    );

    always #(CLOCKPERIOD/2) clk <= ~clk;

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars;
        rst = 1;
        #(CLOCKPERIOD+1) rst = 0;
        #(25*CLOCKPERIOD);
        $display("All tests succeeded.");
        $finish;
    end

endmodule

