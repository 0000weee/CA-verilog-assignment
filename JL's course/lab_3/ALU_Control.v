module ALU_Control(
    input [6:0] funct7,
    input [2:0] funct3,
    input [1:0] ALUOp_i,
    output reg [2:0] ALUControl_o
);
    
always @(funct7 or funct3 or ALUOp_i) begin
    
    //R-type
    if(ALUOp_i[1:0] == 2'b10) begin
        case({funct7,funct3})
            10'b0000000111 : ALUControl_o = 3'b111; // and
            10'b0000000100 : ALUControl_o = 3'b110; // xor
            10'b0000000001 : ALUControl_o = 3'b101; // sll
            10'b0000000000 : ALUControl_o = 3'b100; // add
            10'b0100000000 : ALUControl_o = 3'b011; // sub
            10'b0000001000 : ALUControl_o = 3'b010; // mul
        endcase
    end    
    else if(ALUOp_i[1:0] == 2'b11) begin
        ALUControl_o = 3'b011;
    end    
    //I-type
    else begin
        case(funct3)
            3'b000 : ALUControl_o = 3'b001; // addi
            3'b101 : ALUControl_o = 3'b000; // srai
        endcase
    end
		
end
endmodule
