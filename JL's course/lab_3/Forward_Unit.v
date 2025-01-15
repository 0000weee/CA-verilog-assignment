module Forward_Unit
(
    // Inputs
    input [4:0] rs1_EX_i,
    input [4:0] rs2_EX_i,
    input regWrite_WB_i,
    input [4:0] rd_WB_i,
    input regWrite_MEM_i,
    input [4:0] rd_MEM_i,
    
    // Outputs
    output reg [1:0] forwardA_o,
    output reg [1:0] forwardB_o
);

    always @* begin
        // Forwarding logic for source register 1 (rs1_EX_i)
        if (regWrite_MEM_i && (rd_MEM_i != 0) && (rd_MEM_i == rs1_EX_i))
            forwardA_o = 2'b10;  // Forward from MEM stage
        else if (regWrite_WB_i && (rd_WB_i != 0) && (rd_WB_i == rs1_EX_i))
            forwardA_o = 2'b01;  // Forward from WB stage
        else
            forwardA_o = 2'b00;  // No forwarding
        
        // Forwarding logic for source register 2 (rs2_EX_i)
        if (regWrite_MEM_i && (rd_MEM_i != 0) && (rd_MEM_i == rs2_EX_i))
            forwardB_o = 2'b10;  // Forward from MEM stage
        else if (regWrite_WB_i && (rd_WB_i != 0) && (rd_WB_i == rs2_EX_i))
            forwardB_o = 2'b01;  // Forward from WB stage
        else
            forwardB_o = 2'b00;  // No forwarding
    end

endmodule
