module Sign_Extend
(
	inst_i,
	sign_ext_o
);

input  [11 : 0] inst_i;
output [63 : 0] sign_ext_o;
assign sign_ext_o[11 : 0] = inst_i; 
assign sign_ext_o[63 : 12] = (inst_i[11] == 1'b0)? {52{1'b0}} : {52{1'b1}};

endmodule