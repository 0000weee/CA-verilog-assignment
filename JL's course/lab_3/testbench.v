`define CYCLE_TIME 50            

module TestBench;

reg                Clk;
reg                Start;
reg                Reset;
integer            i, outfile, counter;
parameter          num_cycles = 64;

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .rst_i  (Reset)
);
  
initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;
    counter = 0;
    
    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end
    
    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 32'b0;
    end    
  
    // Load instructions into instruction memory
    // Make sure you change back to "instruction.txt" before submission
    $readmemb("instruction_1.txt", CPU.Instruction_Memory.memory);
    
    // Open output file
    // Make sure you change back to "output.txt" before submission
    outfile = $fopen("output1.txt") | 1;
    
    Clk = 0;
    Reset = 1;

    #(`CYCLE_TIME/8) 
    Reset = 0;

    #(`CYCLE_TIME/8) 
    Reset = 1;

    CPU.Data_Memory.memory[0] = 5;
    CPU.Data_Memory.memory[1] = 6;
    CPU.Data_Memory.memory[2] = 10;
    CPU.Data_Memory.memory[3] = 18;
    CPU.Data_Memory.memory[4] = 29;

    CPU.Registers.register[24] = -24;
    CPU.Registers.register[25] = -25;
    CPU.Registers.register[26] = -26;
    CPU.Registers.register[27] = -27;
    CPU.Registers.register[28] = 56;
    CPU.Registers.register[29] = 58;
    CPU.Registers.register[30] = 60;
    CPU.Registers.register[31] = 62;

end
  
always@(posedge Clk) begin
    if(counter == num_cycles)    // stop after num_cycles cycles
        $finish;

    // print PC
    // DO NOT CHANGE THE OUTPUT FORMAT
    $fdisplay(outfile, "cycle = %6d, PC = %6d, ", counter, CPU.PC.pc_o);
    $fdisplay(outfile, "Predict = %6d, IFID_Flush = %6d", CPU.branch_predictor.predict_o, CPU.IF_ID.flush_i);
    if (CPU.ID_EX.Branch_o == 1'b1)
        $fdisplay(outfile, "ALU_out = %6d", CPU.ALU.data_o);
    
    // print Registers
    // DO NOT CHANGE THE OUTPUT FORMAT
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "x0 = %6d, x8  = %6d, x16 = %6d, x24 = %6d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "x1 = %6d, x9  = %6d, x17 = %6d, x25 = %6d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "x2 = %6d, x10 = %6d, x18 = %6d, x26 = %6d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "x3 = %6d, x11 = %6d, x19 = %6d, x27 = %6d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "x4 = %6d, x12 = %6d, x20 = %6d, x28 = %6d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "x5 = %6d, x13 = %6d, x21 = %6d, x29 = %6d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "x6 = %6d, x14 = %6d, x22 = %6d, x30 = %6d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "x7 = %6d, x15 = %6d, x23 = %6d, x31 = %6d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    // DO NOT CHANGE THE OUTPUT FORMAT
    $fdisplay(outfile, "Data Memory: 0x00 = %6d", CPU.Data_Memory.memory[0]);
    $fdisplay(outfile, "Data Memory: 0x04 = %6d", CPU.Data_Memory.memory[1]);
    $fdisplay(outfile, "Data Memory: 0x08 = %6d", CPU.Data_Memory.memory[2]);
    $fdisplay(outfile, "Data Memory: 0x0C = %6d", CPU.Data_Memory.memory[3]);
    $fdisplay(outfile, "Data Memory: 0x10 = %6d", CPU.Data_Memory.memory[4]);
    $fdisplay(outfile, "Data Memory: 0x14 = %6d", CPU.Data_Memory.memory[5]);
    $fdisplay(outfile, "Data Memory: 0x18 = %6d", CPU.Data_Memory.memory[6]);
    $fdisplay(outfile, "Data Memory: 0x1C = %6d", CPU.Data_Memory.memory[7]);

    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
end
endmodule
