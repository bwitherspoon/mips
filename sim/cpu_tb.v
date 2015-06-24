`timescale 1ns / 1ps

module cpu_tb
#(
    parameter MEM_INIT_FILE = "cpu_tb.txt",
    parameter VAR_DUMP_FILE = "cpu_tb.vcd"
);

    localparam MEM_ADDR_WIDTH = 9;
    localparam REG_ADDR_WIDTH = 5;
    localparam CPU_DATA_WIDTH = 32;
    localparam CLOCK_PERIOD = 10; // 100 MHz

    task verify (
        input [63:0] name,
        input [31:0] expected,
        input [31:0] actual
    );
        if (expected != actual) begin
            $display("FAIL: %s - %h != %h", name, expected, actual);
            $stop;
        end else
            $display("PASS: %s", name);
    endtask

    integer i;

    reg clk = 1;
    reg reset;

    wire [31:0] gpio;

    cpu cpu (
        .clk(clk),
        .reset(reset),
        .gpio(gpio)
    );

    always #(CLOCK_PERIOD/2) clk <= ~clk;

    initial begin
        // Load memory and dump variables
        $readmemh(MEM_INIT_FILE, cpu.ram.mem, 0, 2**MEM_ADDR_WIDTH-1);
        $dumpfile(VAR_DUMP_FILE);
        $dumpvars(1, clk, reset, gpio);
        $dumpvars(1, cpu.pc_id, cpu.ir_id);
        for (i = 0; i < 2**MEM_ADDR_WIDTH; i = i + 1)
            $dumpvars(1, cpu.ram.mem_[i]);
        for (i = 0; i < 2**REG_ADDR_WIDTH; i = i + 1)
            $dumpvars(1, cpu.regfile.regs_[i]);

        // Reset
        reset = 1;
        #(CLOCK_PERIOD+1) reset = 0;

        // Arithmetic
        #(15*CLOCK_PERIOD) verify("addi 0", 32'hFFFFFFFF, gpio);
        #(CLOCK_PERIOD) verify("addi 1", 32'd1, gpio);
        #(CLOCK_PERIOD) verify("addi 2", 32'd6, gpio);
        #(CLOCK_PERIOD) verify("addi 3", 32'd7, gpio);
        #(CLOCK_PERIOD) verify("addi 4", 32'hFFFFFF00, gpio);
        #(CLOCK_PERIOD) verify("addr 5", 32'h700A, gpio);
        #(CLOCK_PERIOD) verify("add", 32'd7, gpio);
        #(CLOCK_PERIOD) verify("sub", 32'd1, gpio);

        // Logical
        #(CLOCK_PERIOD) verify("and", 32'd6, gpio);
        #(CLOCK_PERIOD) verify("or", 32'd7, gpio);

        // Shift
        #(6*CLOCK_PERIOD) verify("sll", 32'hFFFFFF00, gpio);
        #(CLOCK_PERIOD) verify("sra", 32'hFFFFFFFF, gpio);
        #(CLOCK_PERIOD) verify("srl", 32'h00FFFFFF, gpio);

        // Comparision

        // Branch

        // Jump`

        // Load
        #(10*CLOCK_PERIOD) verify("lui", 32'h00FF0000, gpio);

        // Arithemtic
        #(6*CLOCK_PERIOD) verify("xori", 32'h00FFF00C, gpio);

        // Store

        #(10*CLOCK_PERIOD);
        $finish;
    end

endmodule

