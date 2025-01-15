module Imm_Gen(
    data_i,
    data_o
);
// Signed extends the immediate value into 32-bit number. You have to make sure
// both positive and negative immediate values can work correctly.

input      [31:0] data_i;
output reg [31:0] data_o;


always @ (*) begin
    if (data_i[6:0] == 7'b1100011) // beq
        data_o = {{20{data_i[31]}}, data_i[7], data_i[30:25], data_i[11:8], 1'b0};
    else if (data_i[6:0] == 7'b0100011) // sw
        data_o = {{20{data_i[31]}}, data_i[31:25], data_i[11:7]};
    else if (data_i[6:0] == 7'b0010011) // srai、addi
        data_o = {{20{data_i[31]}}, data_i[31:20]};
    else//lw
        data_o = {{20{data_i[31]}}, data_i[31:20]};

end

endmodule