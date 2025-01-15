module CPU
(
	clk_i,
	rst_i,
);

// Ports.
input clk_i;
input rst_i;

wire [31 : 0] inst;
wire [31 : 0] inst_addr;
wire          zero;

PC PC//OK
(
	.clk_i   (clk_i),
	.rst_i   (rst_i),
	.pc_i    (Add_PC.data_o),
	.pc_o    (inst_addr)
);

Adder Add_PC//OK
(
	.data1_i (inst_addr),
	.data2_i (32'd4),
	.data_o  (PC.pc_i)
);

Instruction_Memory Instruction_Memory//OK
(
	.addr_i (inst_addr), 
	.instr_o (inst)
);

Registers Registers//OK
(	
	.rst_i		(rst_i),
	.clk_i      (clk_i),
	.RS1addr_i   (inst[19 : 15]),
	.RS2addr_i   (inst[24 : 20]),
	.RDaddr_i   (inst[11 : 7]), 
	.RDdata_i   (ALU.data_o),
	.RegWrite_i (Control.RegWrite_o), 
	.RS1data_o   (ALU.data1_i), 
	.RS2data_o   (MUX_ALUSrc.data1_i) 
);

Sign_Extend Sign_Extend//OK
(
	.inst_i (inst),
	.sign_ext_o  (MUX_ALUSrc.data2_i)
);

MUX32 MUX_ALUSrc//OK
(
	.data1_i  (Registers.RS2data_o),
	.data2_i  (Sign_Extend.sign_ext_o),
	.select_i (Control.ALUSrc_o),
	.data_o   (ALU.data2_i)
);

ALU ALU//OK
(
	.data1_i   (Registers.RS1data_o),
	.data2_i   (MUX_ALUSrc.data_o),
	.ALUControl_i (ALU_Control.ALUControl_o),
	.data_o    (Registers.RDdata_i),
	.zero_o    (zero)
);

Control Control
(
	.Op_i       (inst[6 : 0]),
	.ALUOp_o    (ALU_Control.ALUOp_i),
	.ALUSrc_o   (MUX_ALUSrc.select_i),
	.RegWrite_o (Registers.RegWrite_i)
);

ALU_Control ALU_Control
(
	.inst_i    (inst),
	.ALUOp_i   (Control.ALUOp_o),
	.ALUControl_o (ALU.ALUControl_i)
);

endmodule

// TODO:
module Control
(
	Op_i,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o
);

input  [6 : 0] Op_i;
output [1 : 0] ALUOp_o;
output         ALUSrc_o;
output         RegWrite_o;

assign ALUOp_o  = (Op_i == 7'b0110011)? 2'b01 : 2'b10;
assign ALUSrc_o = (Op_i == 7'b0110011)? 1'b0 : 1'b1;
assign RegWrite_o = 1'b1;

endmodule


module Adder
(
	data1_i,
	data2_i,
	data_o
);

input  [31 : 0] data1_i;
input  [31 : 0] data2_i;
output [31 : 0] data_o;

assign data_o = data1_i + data2_i;

endmodule


module MUX32
(
	data1_i,
	data2_i,
	select_i,
	data_o
);

input  [31 : 0] data1_i;
input  [31 : 0] data2_i;
input           select_i;
output [31 : 0] data_o;

assign data_o = (select_i == 1'b0)? data1_i : data2_i;

endmodule


module Sign_Extend
(
	inst_i,
	sign_ext_o
);

input  [31 : 0] inst_i;
output [31 : 0] sign_ext_o;

assign sign_ext_o[11 : 0] = inst_i[31 : 20];
assign sign_ext_o[31 : 12] = (inst_i[31] == 1'b0)? {20{1'b0}} : {20{1'b1}};

endmodule

  
module ALU(
    input [31:0] data1_i,
    input [31:0] data2_i,
    input [2:0] ALUControl_i,
    output [31 : 0] data_o,
	output          zero_o
);

	reg [31 : 0] data_reg;
	assign data_o = data_reg;
	assign zero_o = (data_reg == 32'b0)? 1'b1 : 1'b0;
always @(data1_i or data2_i or ALUControl_i) begin
    case(ALUControl_i)
        3'b111: data_reg = data1_i & data2_i; // Bitwise AND
        3'b110: data_reg = data1_i ^ data2_i; // Bitwise XOR
        3'b101: data_reg = data1_i << data2_i; // Shift Left Logical
        3'b100: data_reg = data1_i + data2_i; // Addition
        3'b011: data_reg = data1_i - data2_i; // Subtraction
        3'b010: data_reg = data1_i * data2_i; // Multiplication
        3'b001: data_reg = data1_i + data2_i; // Addition (different format)
        3'b000: data_reg = data1_i >>> data2_i[4:0]; // Shift Right Arithmetic
        default: data_reg = 32'b0; // Default value
    endcase
end

endmodule


module ALU_Control(
    input [1:0] ALUOp_i,
    input [31:0] inst_i,
    output reg [2:0] ALUControl_o
);
    
    reg [2:0] ALUControl_reg;
	reg [2:0] funct3;
    reg [6:0] funct7;
    always @(inst_i or ALUOp_i)
    begin
        funct3 = inst_i[14:12];
        funct7 = inst_i[31:25];
		//R-type
        case({funct7,funct3})
            10'b0000000111 : ALUControl_o = 3'b111; // and
			10'b0000000100 : ALUControl_o = 3'b110; // xor
			10'b0000000001 : ALUControl_o = 3'b101; // sll
			10'b0000000000 : ALUControl_o = 3'b100; // add
			10'b0100000000 : ALUControl_o = 3'b011; // sub
			10'b0000001000 : ALUControl_o = 3'b010; // mul
        endcase
		//I-type
		case({ALUOp_i,funct3})
			5'b10000 : ALUControl_o = 3'b001; // addi
			5'b10101 : ALUControl_o = 3'b000; // srai
		endcase
    end
endmodule


