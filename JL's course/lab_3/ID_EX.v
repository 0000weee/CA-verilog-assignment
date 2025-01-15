module ID_EX
(
	clk_i,
    rst_i,
    RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o,
    MemRead_i,
	MemRead_o,
    MemWrite_i,
	MemWrite_o,
    ALUOp_i,
	ALUOp_o,
    ALUSrc_i,
	ALUSrc_o,
    rd1_i,
    rd1_o,
    rd2_i,
    rd2_o,
    imm_i,
	imm_o,
    funct7_i,
    funct7_o,
    funct3_i,
    funct3_o,
    rs1_i,
	rs1_o,
	rs2_i,
	rs2_o,
	RDaddr_i, 
	RDaddr_o,
	Branch_o,
	Branch_i,
	predict_i,
	predict_o,
	flush_i,
	pc4_i,
	pc4_o,
	branchtarget_i,
	branchtarget_o
);
	input  Branch_i, predict_i, flush_i;
	output reg Branch_o, predict_o;
	input  [31:0] branchtarget_i, pc4_i;
	output reg [31:0] branchtarget_o, pc4_o;
	input clk_i, rst_i;
    input RegWrite_i;
	output reg  RegWrite_o;
	input MemtoReg_i;
	output reg MemtoReg_o;
    input MemRead_i;
	output reg MemRead_o;
    input MemWrite_i;
	output reg MemWrite_o;
    input  [1:0] ALUOp_i;
	output reg [1:0] ALUOp_o;
    input ALUSrc_i;
	output reg ALUSrc_o;
    input  [31:0] rd1_i;
    output reg [31:0] rd1_o;
    input  [31:0] rd2_i;
    output reg [31:0] rd2_o;
    input  [31:0] imm_i;
	output reg [31:0] imm_o;
    input  [6:0] funct7_i;
    input  [2:0] funct3_i;
    output reg [6:0] funct7_o;
	output reg [2:0] funct3_o;
    input  [4:0] rs1_i;
	output reg [4:0] rs1_o;
	input  [4:0] rs2_i;
	output reg [4:0] rs2_o;
	input  [4:0] RDaddr_i;
	output reg [4:0] RDaddr_o;

 
always @(posedge clk_i or negedge rst_i)
begin
	if (!rst_i)
	begin
	    RegWrite_o <= 0;
		MemtoReg_o <= 0;
		MemRead_o  <= 0;
		MemWrite_o <= 0;
		ALUOp_o    <= 0;
		ALUSrc_o   <= 0;
		rd1_o      <= 0;
		rd2_o      <= 0;
		imm_o      <= 0;
		funct7_o   <= 0;
		funct3_o   <= 0;
		rs1_o 	   <= 0;
		rs2_o 	   <= 0;
		RDaddr_o   <= 0;
		Branch_o   <= 0;
		predict_o  <= 0;
		branchtarget_o <=0;
		pc4_o      <=0;
	end
	else begin
		if(flush_i)begin
		RegWrite_o <= 0;
		MemtoReg_o <= 0;
		MemRead_o  <= 0;
		MemWrite_o <= 0;
		ALUOp_o    <= 0;
		ALUSrc_o   <= 0;
		rd1_o      <= 0;
		rd2_o      <= 0;
		imm_o      <= 0;
		funct7_o   <= 0;
		funct3_o   <= 0;
		rs1_o 	   <= 0;
		rs2_o 	   <= 0;
		RDaddr_o   <= 0;
		Branch_o   <= 0;
		predict_o  <= 0;
		branchtarget_o <=0;
		pc4_o      <=0;
		end
		else begin	
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
		MemRead_o  <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		ALUOp_o    <= ALUOp_i;
		ALUSrc_o   <= ALUSrc_i;
		rd1_o      <= rd1_i;
		rd2_o      <= rd2_i;
		imm_o      <= imm_i;
		funct7_o   <= funct7_i;
		funct3_o   <= funct3_i;
		rs1_o 	   <= rs1_i;
		rs2_o 	   <= rs2_i;
		RDaddr_o   <= RDaddr_i;
		Branch_o   <= Branch_i;
		predict_o  <= predict_i;
		branchtarget_o <= branchtarget_i;
		pc4_o      <= pc4_i;
		end
	end
end
   
endmodule