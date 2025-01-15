module Hazard_Unit
(
	Reg1_i,
	Reg2_i,
	ID_EX_RDaddr_i,
	ID_EX_MemRead_i,
	PC_write_o,
	NoOP,
	Stall_o,
);

input              ID_EX_MemRead_i;
input      [4 : 0] Reg1_i;
input      [4 : 0] Reg2_i;
input      [4 : 0] ID_EX_RDaddr_i;
output reg         Stall_o;
output reg         PC_write_o;
output reg         NoOP;

always @(Reg1_i or Reg2_i or ID_EX_RDaddr_i or ID_EX_MemRead_i)
begin
	Stall_o       = (ID_EX_MemRead_i && (Reg1_i == ID_EX_RDaddr_i || Reg2_i == ID_EX_RDaddr_i))? 1'b1 : 1'b0;
	PC_write_o    = (ID_EX_MemRead_i && (Reg1_i == ID_EX_RDaddr_i || Reg2_i == ID_EX_RDaddr_i))? 1'b0 : 1'b1;
	NoOP = (ID_EX_MemRead_i && (Reg1_i == ID_EX_RDaddr_i || Reg2_i == ID_EX_RDaddr_i))? 1'b1 : 1'b0;
end

endmodule