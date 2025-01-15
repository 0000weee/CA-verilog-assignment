module Control
(
	Op_i,
	NoOP,
	ALUOp_o,
	ALUSrc_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	RegWrite_o,
	MemtoReg_o,
);

input  [6 : 0] Op_i;
input          NoOP;
output reg [1 : 0] ALUOp_o;
output reg     ALUSrc_o;
output reg     Branch_o;
output reg     MemRead_o;
output reg     MemWrite_o;
output reg     RegWrite_o;
output reg     MemtoReg_o;



always@(NoOP or Op_i)begin
	if(NoOP)begin
		ALUOp_o <= 2'b0;
		ALUSrc_o <= 1'b0;
		Branch_o <= 1'b0;
		MemRead_o <=1'b0;
		MemWrite_o <= 1'b0;
		RegWrite_o <= 1'b0;
		MemtoReg_o <= 1'b0;
	end	
	else begin
		if(Op_i==7'b0110011)begin//R formate
		ALUOp_o <= 2'b10;
		ALUSrc_o <= 1'b0;
		Branch_o <= 1'b0;
		MemRead_o <=1'b0;
		MemWrite_o <= 1'b0;
		RegWrite_o <= 1'b1;
		MemtoReg_o <= 1'b0;
		end	

		else if(Op_i==7'b0000011)begin //ld
		ALUOp_o <= 2'b00;
		ALUSrc_o <= 1'b1;
		Branch_o <= 1'b0;
		MemRead_o <=1'b1;
		MemWrite_o <= 1'b0;
		RegWrite_o <= 1'b1;
		MemtoReg_o <= 1'b1;
		end	
		else if(Op_i==7'b0100011)begin//sd
		ALUOp_o <= 2'b00;
		ALUSrc_o <= 1'b1;
		Branch_o <= 1'b0;
		MemRead_o <=1'b0;
		MemWrite_o <= 1'b1;
		RegWrite_o <= 1'b0;
		MemtoReg_o <= 1'b0;
		end	
		else if(Op_i==7'b1100011)begin//beq
		ALUOp_o <= 2'b11;
		ALUSrc_o <= 1'b0;
		Branch_o <= 1'b1;
		MemRead_o <=1'b0;
		MemWrite_o <= 1'b0;
		RegWrite_o <= 1'b0;
		MemtoReg_o <= 1'b0;
		end	
		else if(Op_i==7'b0010011)begin//addi srai
		ALUOp_o <= 2'b01;
		ALUSrc_o <= 1'b1;
		Branch_o <= 1'b0;
		MemRead_o <=1'b0;
		MemWrite_o <= 1'b0;
		RegWrite_o <= 1'b1;
		MemtoReg_o <= 1'b0;
		end	
		else begin
			ALUOp_o <= 2'b0;
			ALUSrc_o <= 1'b0;
			Branch_o <= 1'b0;
			MemRead_o <=1'b0;
			MemWrite_o <= 1'b0;
			RegWrite_o <= 1'b0;
			MemtoReg_o <= 1'b0;
		end
	end	
end

endmodule