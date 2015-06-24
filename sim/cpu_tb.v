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
        #(14*CLOCK_PERIOD);
        if (gpio != 32'hFFFFFFFF) begin
            $write("Arithmetic test 0 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'hFFFFFFFF, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'd1) begin
            $write("Arithmetic test 1 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'd1, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'd6) begin
            $write("Arithmetic test 2 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'd6, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'd7) begin
            $write("Arithmetic test 3 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'd7, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'hFFFFFF00) begin
            $write("Arithmetic test 4 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'hFF00, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'h700A) begin
            $write("Arithmetic test 5 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'h700A, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'd7) begin
            $write("Arithmetic test 6 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'd7, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'd1) begin
            $write("Arithmetic test 7 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'd1, gpio);
            $stop;
        end

        // Logical
        #(CLOCK_PERIOD);
        if (gpio != 32'd6) begin
            $write("Logical test 0 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'd1, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'd7) begin
            $write("Logical test 9 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'd7, gpio);
            $stop;
        end

        // Shift
        #(6*CLOCK_PERIOD);
        if (gpio != 32'hFFFFFF00) begin
            $write("Shift test 0 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'hFFFFFF00, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'hFFFFFFFF) begin
            $write("Shift test 1 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'hFFFFFFFF, gpio);
            $stop;
        end
        #(CLOCK_PERIOD);
        if (gpio != 32'h00FFFFFF) begin
            $write("Shift test 2 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'h00FFFFFF, gpio);
            $stop;
        end

        // Comparision

        // Branch

        // Jump`

        // Load
        #(10*CLOCK_PERIOD);
        if (gpio != 32'h00FF0000) begin
            $write("Load upper immediate test 0 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'h00FF0000, gpio);
            $stop;
        end

        // Arithemtic
        #(6*CLOCK_PERIOD);
        if (gpio != 32'h00FFF00C) begin
            $write("XOR immediate test 0 failed - ");
            $write("Expected: %h, Actual: %h\n", 32'h00FF0000, gpio);
            $stop;
        end

        // Store

        #(25*CLOCK_PERIOD);
        $display("PASSED");
        $finish;
    end

endmodule

