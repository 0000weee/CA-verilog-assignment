`timescale 1ns / 1ps

module ALU_tb;

    // Inputs
    reg signed [31:0] data1_i;
    reg signed [31:0] data2_i;
    reg [2:0] ALUCtrl_i;

    // Outputs
    wire signed [31:0] data_o;
    wire zero_o;

    // Instantiate the ALU module
    ALU uut (
        .data1_i(data1_i),
        .data2_i(data2_i),
        .ALUCtrl_i(ALUCtrl_i),
        .data_o(data_o),
        .zero_o(zero_o)
    );

    // Testbench procedure
    initial begin
        $dumpfile("ALU_test.vcd"); // 指定波形檔案名稱
        $dumpvars(0, ALU_tb); // 記錄所有信號變化

        // Test Addition
        data1_i = 32'hFFFFFFFF; // 2^32-1
        data2_i = 32'h00000001; // 1
        ALUCtrl_i = 3'b000; // Addition
        #10;
        $display("Addition: %d + %d = %d, Zero: %b", data1_i, data2_i, data_o, zero_o);

        // Test Subtraction
        data1_i = 32'h00000000; // 32
        data2_i = 32'h00000001; // 32
        ALUCtrl_i = 3'b001; // Subtraction
        #10;
        $display("Subtraction: %d - %d = %d, Zero: %b", data1_i, data2_i, data_o, zero_o);

        // Test Bitwise AND
        data1_i = 32'h000000FF;
        data2_i = 32'h0000000F;
        ALUCtrl_i = 3'b010; // AND
        #10;
        $display("AND: %h & %h = %h, Zero: %b", data1_i, data2_i, data_o, zero_o);

        // Test Bitwise OR
        data1_i = 32'h000000F0;
        data2_i = 32'h0000000F;
        ALUCtrl_i = 3'b011; // OR
        #10;
        $display("OR: %h | %h = %h, Zero: %b", data1_i, data2_i, data_o, zero_o);

        // Test Bitwise XOR
        data1_i = 32'h000000F0;
        data2_i = 32'h0000000F;
        ALUCtrl_i = 3'b100; // XOR
        #10;
        $display("XOR: %h ^ %h = %h, Zero: %b", data1_i, data2_i, data_o, zero_o);

        // Test Left Shift
        data1_i = 32'h00000001;
        data2_i = 32'h00000002; // Shift by 2
        ALUCtrl_i = 3'b101; // Left Shift
        #10;
        $display("Left Shift: %h << %d = %h, Zero: %b", data1_i, data2_i, data_o, zero_o);

        // Test Arithmetic Right Shift
        data1_i = 32'hFFFFFFF0; // -16 in 2's complement
        data2_i = 32'h00000002; // Shift by 2
        ALUCtrl_i = 3'b110; // Arithmetic Right Shift
        #10;
        $display("Arithmetic Right Shift: %h >>> %d = %h, Zero: %b", data1_i, data2_i, data_o, zero_o);

        // Test Logical Right Shift
        data1_i = 32'hFFFFFFF0; // -16 in 2's complement
        data2_i = 32'h00000002; // Shift by 2
        ALUCtrl_i = 3'b111; // Logical Right Shift
        #10;
        $display("Logical Right Shift: %h >> %d = %h, Zero: %b", data1_i, data2_i, data_o, zero_o);

        // Default case
        data1_i = 32'h00000010;
        data2_i = 32'h00000010;
        ALUCtrl_i = 3'bxxx; // Invalid operation
        #10;
        $display("Default case: %h, Zero: %b", data_o, zero_o);

        $stop;
    end

endmodule
