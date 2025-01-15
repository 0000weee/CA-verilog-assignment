module MEM_WB(
rst_i,
clk_i,
RegWrite_i,
MemtoReg_i,
ALUresult_i,
data_i,
RDaddr_i,
RegWrite_o,
MemtoReg_o,
ALUresult_o,
data_o,
RDaddr_o
);

input rst_i;
input clk_i;
input RegWrite_i;
input MemtoReg_i;
input [31:0]ALUresult_i;
input [31:0]data_i;
input [4:0] RDaddr_i;
output reg RegWrite_o;
output reg MemtoReg_o;
output reg [31:0]ALUresult_o;
output reg [31:0]data_o;
output reg [4:0] RDaddr_o;

always @(posedge clk_i or negedge rst_i)
begin
	if (!rst_i)
	begin
		RegWrite_o <= 1'b0;
        MemtoReg_o <=1'b0;
        ALUresult_o<=32'b0;
        data_o<= 32'b0;
        RDaddr_o<=5'b0;
	end
	else
	begin
		RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        ALUresult_o<= ALUresult_i;
        data_o<=data_i;
        RDaddr_o<=RDaddr_i;
	end
end

endmodule