`timescale 1ns / 1ps

module cpu_tb;

    localparam MEM_SIZE = 1024;
    localparam REG_SIZE = 32;
    localparam CLOCK_PERIOD = 10; // 100 MHz

    integer i;

    reg clk = 1;
    reg rst;

    wire [31:0] gpio;

    cpu cpu (
        .clk(clk),
        .rst(rst),
        .gpio(gpio)
    );

    always #(CLOCK_PERIOD/2) clk <= ~clk;

    initial begin
        $dumpfile("sim/cpu.vcd");
        $dumpvars(1, cpu.clk, cpu.rst, cpu.gpio);
        $dumpvars(1, cpu.pc_id, cpu.ir_id);
        for (i = 0; i < MEM_SIZE; i = i + 1)
            $dumpvars(1, cpu.memory.mem_[i]);
        for (i = 0; i < REG_SIZE; i = i + 1)
            $dumpvars(1, cpu.regfile.regs_[i]);

        rst = 1;
        #(CLOCK_PERIOD+1) rst = 0;
        #(16*CLOCK_PERIOD);

        $display("All tests succeeded.");
        $finish;
    end

endmodule

