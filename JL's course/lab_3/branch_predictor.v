module branch_predictor (
    input wire branch_condition,
    input wire branch_outcome,
    input wire EX_branch,
    output reg predict_o,
    input wire clk_i
);

    // 定义状态
    parameter ST_STRONG_TAKEN = 2'b11;
    parameter ST_WEAK_TAKEN = 2'b10;
    parameter ST_WEAK_NOT_TAKEN = 2'b01;
    parameter ST_STRONG_NOT_TAKEN = 2'b00;

    reg [1:0] state; // 2-bit状态寄存器

    // 初始状态设定为强跳转
    initial begin
        state = ST_STRONG_TAKEN;
    end

    always @ (posedge clk_i) begin
        // 根据状态进行预测
        case(state)
            ST_STRONG_TAKEN: begin
                if ((branch_outcome == 1'b0) && (EX_branch == 1'b1))
                    state <= ST_WEAK_TAKEN;
            end
            ST_WEAK_TAKEN: begin
                if ((branch_outcome == 1'b0) && (EX_branch == 1'b1))
                    state <= ST_WEAK_NOT_TAKEN;
                else if ((branch_outcome == 1'b1) && (EX_branch == 1'b1))
                    state <= ST_STRONG_TAKEN;
            end
            ST_WEAK_NOT_TAKEN: begin
                if ((branch_outcome == 1'b1) && (EX_branch == 1'b1))
                    state <= ST_WEAK_TAKEN;
                else if ((branch_outcome == 1'b0) && (EX_branch == 1'b1))
                    state <= ST_STRONG_NOT_TAKEN;
            end
            ST_STRONG_NOT_TAKEN: begin
                if ((branch_outcome == 1'b1) && (EX_branch == 1'b1))
                    state <= ST_WEAK_NOT_TAKEN;
            end
         endcase
    end

    // 根据状态输出预测结果
    always @ (*) begin
        case(state)
            ST_STRONG_TAKEN, ST_WEAK_TAKEN: predict_o = 1'b1;
            ST_WEAK_NOT_TAKEN, ST_STRONG_NOT_TAKEN: predict_o = 1'b0;
            default: predict_o = 1'b0; // 默认情况
        endcase
    end

endmodule

