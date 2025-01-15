module EX_MEM
(
	clk_i,
	rst_i,
	data_i,
	data_o,
	RDaddr_i,
	RDaddr_o,
	ALUresult_i,
	ALUresult_o,
	MemRead_i,
	MemRead_o,
	MemWrite_i,
	MemWrite_o,
	RegWrite_i,
	RegWrite_o,
	MemtoReg_i,
	MemtoReg_o
);

input               clk_i;
input				rst_i;
input      [31 : 0]  data_i;
output reg [31 : 0]  data_o;
input      [4 : 0]  RDaddr_i;
output reg [4 : 0]  RDaddr_o;
input      [31 : 0] ALUresult_i;
output reg [31 : 0] ALUresult_o;
input               MemRead_i;
output reg          MemRead_o;
input               MemWrite_i;
output reg          MemWrite_o;
input               RegWrite_i;
output reg          RegWrite_o;
input               MemtoReg_i;
output reg          MemtoReg_o;
 
always @(posedge clk_i or negedge rst_i)
begin
	if (!rst_i)
	begin
		data_o <= 0;
		RDaddr_o <= 0;
		ALUresult_o <= 0;
		MemRead_o <= 0;
		MemWrite_o <= 0;
		RegWrite_o <= 0;
		MemtoReg_o <= 0;
	end
	else
	begin
		data_o <= data_i;
		RDaddr_o <= RDaddr_i;
		ALUresult_o <= ALUresult_i;
		MemRead_o <= MemRead_i;
		MemWrite_o <= MemWrite_i;
		RegWrite_o <= RegWrite_i;
		MemtoReg_o <= MemtoReg_i;
	end
end
   
endmodule