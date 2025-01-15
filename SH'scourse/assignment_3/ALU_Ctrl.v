module ALU_Control(
    input [6:0] funct7,
    input [2:0] funct3,
    input [1:0] ALUOp_i,
    output reg [2:0] ALUCtrl_o
);
    
always @(funct7 or funct3 or ALUOp_i) begin
    
    //R-type
    if(ALUOp_i[1:0] == 2'b10) begin
        case({funct7,funct3})
            10'b0000000000 : ALUCtrl_o = 3'b000; // add
            10'b0100000000 : ALUCtrl_o = 3'b001; // sub
            10'b0000000111 : ALUCtrl_o = 3'b010; // and
            10'b0000000110 : ALUCtrl_o = 3'b011; // or
            10'b0000000100 : ALUCtrl_o = 3'b100; // xor
            10'b0000000001 : ALUCtrl_o = 3'b101; // sll
            10'b0100000101 : ALUCtrl_o = 3'b110; // sra
            10'b0000000101 : ALUCtrl_o = 3'b111; // srl

        endcase
    end    
    //I-type
    else begin
        case(funct3)
            3'b000 : ALUCtrl_o = 3'b000; // addi
            3'b100 : ALUCtrl_o = 3'b100; // xori
            3'b110 : ALUCtrl_o = 3'b011; // ori
            3'b111 : ALUCtrl_o = 3'b010; // andi
            3'b001 : ALUCtrl_o = 3'b101; // slli
            3'b101 : begin
                    if(funct7[6:1]== 6'b000000)
                        ALUCtrl_o = 3'b111; // srli
                    if(funct7[6:1]== 6'b010000)
                        ALUCtrl_o = 3'b110; // srai
                    end
        endcase
    end
		
end
endmodule
