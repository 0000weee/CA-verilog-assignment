module IF_ID
(
    clk_i,
    rst_i,
    Stall_i,
    flush_i,
    pc_i,
    pc_o,
    instr_i,
    instr_o
);


input  [31:0] pc4_i;
input               clk_i, rst_i, Stall_i, flush_i;
input      [31 : 0] instr_i, pc_i;
output reg [31 : 0] instr_o, pc_o, pc4_o;


always @ (posedge clk_i or negedge rst_i) begin
    if (!rst_i)begin 
        pc_o <= 32'b0;
        instr_o <= 32'b0; 
        pc4_o <= 32'b0;
    end 
    else begin
        if (!Stall_i) begin
            pc_o <= pc_i;
            instr_o <= instr_i;
            pc4_o <= pc4_i;
        end
        if (flush_i)
            instr_o <= 32'b0;
    end
end
   
endmodule