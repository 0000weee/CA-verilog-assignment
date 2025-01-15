module CPU
(
    clk_i, 
    rst_i
);
/* 
cp testcases/instruction_n.txt instruction.txt
iverilog -o cpu code/src/*.v code/supplied/*.v
vvp cpu
*/
input               clk_i;
input               rst_i;
wire                IFID_Flush;
wire                IDEX_Flush;
wire  [1:0]         IF_MUXcontrol;
assign IFID_Flush = (((branch_predictor.predict_o) && (Control.Branch_o)) ||(ID_EX.Branch_o&&(branch_predictor.predict_o!=ALU.zero_o)));
assign IDEX_Flush = (ID_EX.Branch_o==1'b1)&&((branch_predictor.predict_o)!=(ALU.zero_o));
assign IF_MUXcontrol = ((branch_predictor.predict_o) && (Control.Branch_o))? 2'b01:
((ALU.zero_o==1'b0)&&(ID_EX.Branch_o==1'b1)&&(ID_EX.predict_o==1'b1))? 2'b10: 
((ALU.zero_o==1'b1)&&(ID_EX.Branch_o==1'b1)&&(ID_EX.predict_o==1'b0))? 2'b11: 
2'b00;

branch_predictor branch_predictor (
    .branch_condition(Control.Branch_o),
    .branch_outcome(ALU.zero_o),
    .EX_branch(ID_EX.Branch_o),
    .predict_o(),
    .clk_i(clk_i)
);

MUX4to1 IF_MUX(
.select_i(IF_MUXcontrol),
.data1_i(Add_PC.data_o),
.data2_i(Adder_ID.data_o),
.data3_i(ID_EX.pc4_o),
.data4_i(ID_EX.branchtarget_o),
.data_o()
);

PC PC(
.clk_i(clk_i),
.rst_i(rst_i),
.PCWrite_i(Hazard_Detection.PC_write_o),
.pc_i(IF_MUX.data_o),
.pc_o()
);

Instruction_Memory Instruction_Memory(
.addr_i(PC.pc_o),
.instr_o()
);
Adder Add_PC
(
	.data1_i (PC.pc_o),
	.data2_i (32'd4),
	.data_o  ()
);

IF_ID IF_ID(
.clk_i(clk_i),
.rst_i(rst_i),
.Stall_i(Hazard_Detection.Stall_o),
.flush_i(IFID_Flush),
.pc_i(PC.pc_o),
.pc_o(),
.instr_i(Instruction_Memory.instr_o),
.instr_o()
);

Control Control(
.Op_i(IF_ID.instr_o[6:0]),
.NoOP(Hazard_Detection.NoOP),
.RegWrite_o(),
.MemtoReg_o(),
.MemRead_o(),
.MemWrite_o(),
.ALUOp_o(),
.ALUSrc_o(),
.Branch_o()
);
Hazard_Unit Hazard_Detection(
.Reg1_i(IF_ID.instr_o[19:15]),
.Reg2_i(IF_ID.instr_o[24:20]),
.ID_EX_MemRead_i(ID_EX.MemRead_o),
.ID_EX_RDaddr_i(ID_EX.RDaddr_o),
.PC_write_o(),
.Stall_o(),
.NoOP()
);


Registers Registers(
.rst_i(rst_i),
.clk_i(clk_i),
.RS1addr_i(IF_ID.instr_o[19:15]),
.RS2addr_i(IF_ID.instr_o[24:20]),
.RDaddr_i(MEM_WB.RDaddr_o),
.RDdata_i(WB_MUX.data_o),
.RegWrite_i(MEM_WB.RegWrite_o),
.RS1data_o(), 
.RS2data_o()
);

Imm_Gen Imm_Gen(
.data_i(IF_ID.instr_o),
.data_o()
);

Adder Adder_ID(
.data1_i(Imm_Gen.data_o),
.data2_i(IF_ID.pc_o),
.data_o()
);
ID_EX ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(Control.RegWrite_o),
    .MemtoReg_i(Control.MemtoReg_o),
    .MemRead_i(Control.MemRead_o),
    .MemWrite_i(Control.MemWrite_o),
    .ALUOp_i(Control.ALUOp_o),
    .ALUSrc_i(Control.ALUSrc_o),
    .rd1_i(Registers.RS1data_o),
    .rd2_i(Registers.RS2data_o),
    .imm_i(Imm_Gen.data_o),
    .funct7_i(IF_ID.instr_o[31:25]),
    .funct3_i(IF_ID.instr_o[14:12]),
    .rs1_i(IF_ID.instr_o[19:15]),
    .rs2_i(IF_ID.instr_o[24:20]),
    .RDaddr_i(IF_ID.instr_o[11:7]),
    .Branch_i(Control.Branch_o),.predict_i(branch_predictor.predict_o),.flush_i(IDEX_Flush),.pc4_i(IF_ID.pc4_o),.branchtarget_i(Adder_ID.data_o),
    .RegWrite_o(),
    .MemtoReg_o(),
    .MemRead_o(),
    .MemWrite_o(),
    .ALUOp_o(),
    .ALUSrc_o(),
    .rd1_o(),
    .rd2_o(),
    .imm_o(),
    .funct7_o(),
    .funct3_o(),
    .rs1_o(),
    .rs2_o(),
    .RDaddr_o(),
    .branchtarget_o(),
    .pc4_o(),
    .predict_o(),
    .Branch_o()
);


MUX4to1 EX_MUX1(
.data1_i(ID_EX.rd1_o),
.data2_i(WB_MUX.data_o),
.data3_i(EX_MEM.ALUresult_o),
.data4_i(),
.select_i(Forward.forwardA_o),
.data_o()
);
MUX4to1 EX_MUX2(
.data1_i(ID_EX.rd2_o),
.data2_i(WB_MUX.data_o),
.data3_i(EX_MEM.ALUresult_o),
.data4_i(),
.select_i(Forward.forwardB_o),
.data_o()
);
MUX32 EX_MUX3(
.select_i(ID_EX.ALUSrc_o),
.data1_i(EX_MUX2.data_o),
.data2_i(ID_EX.imm_o),
.data_o()
);
ALU ALU(
.data1_i(EX_MUX1.data_o),
.data2_i(EX_MUX3.data_o),
.ALUControl_i(ALU_Control.ALUControl_o),
.data_o()
);

ALU_Control ALU_Control(
.funct7(ID_EX.funct7_o),
.funct3(ID_EX.funct3_o),
.ALUOp_i(ID_EX.ALUOp_o),
.ALUControl_o()
);
Forward_Unit Forward(
    .rs1_EX_i(ID_EX.rs1_o),
    .rs2_EX_i(ID_EX.rs2_o),
    .regWrite_WB_i(MEM_WB.RegWrite_o),
    .rd_WB_i(MEM_WB.RDaddr_o),
    .regWrite_MEM_i(EX_MEM.RegWrite_o),
    .rd_MEM_i(EX_MEM.RDaddr_o),
    .forwardA_o(),
    .forwardB_o()
);

EX_MEM EX_MEM(
.clk_i(clk_i),
.rst_i(rst_i),
.RegWrite_i(ID_EX.RegWrite_o),
.MemtoReg_i(ID_EX.MemtoReg_o),
.MemRead_i(ID_EX.MemRead_o),
.MemWrite_i(ID_EX.MemWrite_o),
.ALUresult_i(ALU.data_o),
.data_i(EX_MUX2.data_o),
.RDaddr_i(ID_EX.RDaddr_o),
.RegWrite_o(),
.MemtoReg_o(),
.MemRead_o(),
.MemWrite_o(),
.ALUresult_o(),
.data_o(),
.RDaddr_o()
);
Data_Memory Data_Memory(
.clk_i(clk_i), 
.addr_i(EX_MEM.ALUresult_o), 
.MemRead_i(EX_MEM.MemRead_o),
.MemWrite_i(EX_MEM.MemWrite_o),
.data_i(EX_MEM.data_o),
.data_o()
);
MEM_WB MEM_WB(
.rst_i(rst_i),
.clk_i(clk_i),
.RegWrite_i(EX_MEM.RegWrite_o),
.MemtoReg_i(EX_MEM.MemtoReg_o),
.ALUresult_i(EX_MEM.ALUresult_o),
.data_i(Data_Memory.data_o),
.RDaddr_i(EX_MEM.RDaddr_o),
.RegWrite_o(),
.MemtoReg_o(),
.ALUresult_o(),
.data_o(),
.RDaddr_o()
);
MUX32 WB_MUX(
.select_i(MEM_WB.MemtoReg_o),
.data1_i(MEM_WB.ALUresult_o),
.data2_i(MEM_WB.data_o),
.data_o()
);
endmodule