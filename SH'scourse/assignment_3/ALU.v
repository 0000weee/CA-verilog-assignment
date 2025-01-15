module ALU( 
    input signed [63:0] data1_i,
    input signed [63:0] data2_i,
    input [2:0] ALUCtrl_i,
    output reg signed [63:0] data_o,
    output zero_o
);

assign zero_o = (data_o == 0) ? 1'b1 : 1'b0;

always @(data1_i or data2_i or ALUCtrl_i) begin
    case(ALUCtrl_i)
        3'b000: data_o = (data1_i + data2_i); // Addition with wrap-around
        3'b001: data_o = (data1_i - data2_i); // Subtraction with wrap-around
        3'b010: data_o = data1_i & data2_i; // Bitwise AND
        3'b011: data_o = data1_i | data2_i; // Bitwise OR
        3'b100: data_o = data1_i ^ data2_i; // Bitwise XOR
        3'b101: data_o = data1_i << data2_i[5:0]; // Left Shift
        3'b110: data_o = data1_i >>> data2_i[5:0]; // Arithmetic Right Shift
        3'b111: data_o = data1_i >> data2_i[5:0]; // Logical Right Shift
        default: data_o = 0; // Default value
    endcase
end

endmodule