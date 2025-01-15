`timescale 1ns / 1ps

module Registers_tb;

    // Inputs
    reg rst_i;
    reg clk_i;
    reg [4:0] RS1addr_i;
    reg [4:0] RS2addr_i;
    reg [4:0] RDaddr_i;
    reg [31:0] RDdata_i;
    reg RegWrite_i;

    // Outputs
    wire signed [31:0] RS1data_o;
    wire signed [31:0] RS2data_o;

    // Instantiate the Registers module
    Registers uut (
        .rst_i(rst_i),
        .clk_i(clk_i),
        .RS1addr_i(RS1addr_i),
        .RS2addr_i(RS2addr_i),
        .RDaddr_i(RDaddr_i),
        .RDdata_i(RDdata_i),
        .RegWrite_i(RegWrite_i),
        .RS1data_o(RS1data_o),
        .RS2data_o(RS2data_o)
    );

    // Clock generation
    initial clk_i = 0;
    always #5 clk_i = ~clk_i; // 10ns clock period

    // Testbench procedure
    initial begin
        $dumpfile("Registers_test.vcd"); // 指定波形檔案名稱
        $dumpvars(0, Registers_tb); // 記錄所有信號變化
        $display("Starting Registers Testbench...");
        
        // Reset the registers
        rst_i = 0;
        RegWrite_i = 0;
        RDaddr_i = 5'b0;
        RDdata_i = 32'b0;
        #10; // Wait for reset
        
        rst_i = 1; // Release reset
        #10;

        // Test 1: Write to a register and read it back
        RDaddr_i = 5'd1; // Write to register 1
        RDdata_i = 32'hDEADBEEF;
        RegWrite_i = 1;
        #10;

        RS1addr_i = 5'd1; // Read register 1
        RegWrite_i = 0;
        #10;
        $display("Test 1: Write/Read register 1. RS1data_o = %h (Expected: DEADBEEF)", RS1data_o);

        // Test 2: Write to multiple registers
        RDaddr_i = 5'd2;
        RDdata_i = 32'h12345678;
        RegWrite_i = 1;
        #10;

        RDaddr_i = 5'd3;
        RDdata_i = 32'hABCDEF01;
        #10;

        RS1addr_i = 5'd2;
        RS2addr_i = 5'd3;
        RegWrite_i = 0;
        #10;
        $display("Test 2: RS1data_o = %h (Expected: 12345678), RS2data_o = %h (Expected: ABCDEF01)", RS1data_o, RS2data_o);

        // Test 3: Write to register 0 (should not change)
        RDaddr_i = 5'b0; // Attempt to write to register 0
        RDdata_i = 32'hFFFFFFFF;
        RegWrite_i = 1;
        #10;

        RS1addr_i = 5'b0; // Read register 0
        RegWrite_i = 0;
        #10;
        $display("Test 3: Write/Read register 0. RS1data_o = %h (Expected: 00000000)", RS1data_o);

        // Test 4: Reset and verify all registers are cleared
        rst_i = 0; // Assert reset
        #10;
        rst_i = 1; // Release reset
        #10;

        RS1addr_i = 5'd1;
        RS2addr_i = 5'd2;
        #10;
        $display("Test 4: After reset, RS1data_o = %h (Expected: 00000000), RS2data_o = %h (Expected: 00000000)", RS1data_o, RS2data_o);

        $display("Registers Testbench Completed.");
        $stop;
    end

endmodule
