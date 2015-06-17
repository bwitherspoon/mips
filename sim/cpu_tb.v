`timescale 1ns / 1ps

module cpu_tb;

    localparam CLOCKPERIOD = 100; // 100 MHz

    reg clk = 1;
    reg rst;

    cpu cpu (
        .clk(clk),
        .rst(rst)
    );

    always #(CLOCKPERIOD/2) clk <= ~clk;

    initial begin
        $dumpvars(1, cpu, cpu.decode.control, cpu.execute.alu);
        rst = 1;
        #(CLOCKPERIOD+1) rst = 0;
        #(64*CLOCKPERIOD);
        $display("All tests succeeded.");
        $finish;
    end

endmodule

