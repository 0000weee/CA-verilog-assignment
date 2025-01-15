module ALU(
    input signed [31:0] data1_i,
    input signed [31:0] data2_i,
    input [2:0] ALUControl_i,
    output  reg signed [31 : 0] data_o,
	output          zero_o
);

assign zero_o = (data_o == 0)? 1'b1 : 1'b0;

always @(data1_i or data2_i or ALUControl_i) begin
    case(ALUControl_i)
        3'b111: data_o = $signed(data1_i & data2_i); // Bitwise AND
        3'b110: data_o = $signed(data1_i ^ data2_i); // Bitwise XOR
        3'b101: data_o = $signed(data1_i << data2_i); // Shift Left Logical
        3'b100: data_o = $signed(data1_i + data2_i); // Addition
        3'b011: data_o = $signed(data1_i - data2_i); // Subtraction
        3'b010: data_o = $signed(data1_i * data2_i); // Multiplication
        3'b001: data_o = $signed(data1_i + data2_i); // Addi 
        3'b000: data_o = $signed(data1_i >>> data2_i[4:0]); // Shift Right Arithmetic
        default: data_o = 0; // Default value
    endcase
end

endmodule