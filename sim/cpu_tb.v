`timescale 1ns / 1ps

module cpu_tb
#(
    parameter MEM_INIT_FILE = "cpu_tb.mem",
    parameter VAR_DUMP_FILE = "cpu_tb.vcd"
);

    localparam MEM_ADDR_WIDTH = 9;
    localparam REG_ADDR_WIDTH = 5;
    localparam CPU_DATA_WIDTH = 32;
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
        $readmemh(MEM_INIT_FILE, cpu.ram.mem, 0, 2**MEM_ADDR_WIDTH-1);
        $dumpfile(VAR_DUMP_FILE);
        $dumpvars(1, clk, rst, gpio);
        $dumpvars(1, cpu.pc_id, cpu.ir_id);
        for (i = 0; i < 2**MEM_ADDR_WIDTH; i = i + 1)
            $dumpvars(1, cpu.ram.mem_[i]);
        for (i = 0; i < 2**REG_ADDR_WIDTH; i = i + 1)
            $dumpvars(1, cpu.regfile.regs_[i]);

        rst = 1;
        #(CLOCK_PERIOD+1) rst = 0;
        #(32*CLOCK_PERIOD);

        $display("All tests succeeded.");
        $finish;
    end

endmodule

