module Datapath(

    clk,rst,
    
    ins_Addr,
    ins,
    
    memAddr,memWriteData,memReadData,MemWrite,MemRead,
    
    rReadSelect1,rReadSelect2,rWriteSelect,rWriteData,rWriteEnable,rReadData1,rReadData2
    );

    input clk,rst;

    //ports for IMEM
    output [63:0] ins_Addr;//Instructions Address
    input  [31:0] ins;//instruction
    
    //ports for Data Memory
    output [63:0] memAddr;// Data memory Address 
    output [63:0] memWriteData;// Data wrote to data memory
    output  MemWrite; // control signal
    output  MemRead; // control signal
    input [63:0] memReadData;//Read data from memory
    
    //ports for Register file
    output [4:0] rReadSelect1, rReadSelect2, rWriteSelect; // Control singal for Reginster file
    output [63:0] rWriteData; // Data wrote to Register file
    output rWriteEnable;// Control singal for Reginster file
    input [63:0] rReadData1, rReadData2;
    
    /* program counters */ 
    wire [63:0] pc_branch;// ouput of branch unit
    wire [63:0] pc_1;// pc incremented by 1, of next timeslot.
    wire [63:0] pc_0;// pc of this timeslot
    
    /* Instruction Memory */
    wire [31:0] instru;// instruction from IMem
    
    /* Control signals  */ 
    wire RegtoLoc, RegWrite, ALUSrc, ALUOp, Branch, MemWrite, MemRead, MemtoReg, SignExtend;
    
    /* Sign Extension Unit */
    wire [63:0] se_pc;// sign extended pc 
    
    /* MUX RegtoLoc output */
    wire [4:0] ReadReg2;

    /* register file output */
    wire [63:0] ReadData1, ReadData2;
    
    /* MUX ALUSrc output*/
    wire [63:0] ALUSrc_o;
    
    /* ALU output*/
    wire [63:0] ALU_result;
    wire ALU_zero_flag;
    
    /* Data Memory Data Output */
    wire [63:0] DM_o;
    
    /* MUX MemtoReg output */
    wire [63:0] WriteData;// output of MemtoReg MUX


    // program counter
    program_counter u_pc (.clk(clk), .rst(rst), 
                    .pc_branch(pc_branch), .pc_1(pc_1), .pc_0(pc_0));
    
    //instruction Memory
    Instruction_Memory u_imm(.Address(pc_0), .ReadData1(instru));
     
    // 5bit MUX RegtoLoc
    MUX_5bit u_RegtoLoc (.A(instru[20:16]), .B(instru[4:0]), .C(ReadReg2), .select(RegtoLoc));
    
    // Control logic 
    Control_logic u_cl (.Opcode(instru[31:21]), .RegtoLoc(RegtoLoc), .RegWrite(RegWrite), 
                    .ALUSrc(ALUSrc), .ALUOp(ALUOp), .Branch(Branch), 
                    .MemWrite(MemWrite), .MemRead(MemRead), 
                    .MemtoReg(MemtoReg), .SignExtend(SignExtend));
                    
    // Sign Extension Unit
    SignExtend u_se(.instru(instru), .signExtend(SignExtend), .se_pc(se_pc));
    
    
    // Register File
    Register_File u_rf(.ReadSelect1(instru[9:5]), .ReadSelect2(ReadReg2), 
                    .WriteSelect(instru[4:0]), .WriteData(WriteData), .WriteEnable(RegWrite), 
                    .ReadData1(ReadData1), .ReadData2(ReadData2), 
                    .clk(clk), .rst(rst));
    
    // MUX ALUSrc
    MUX_64bit u_ALUSrc (.A(ReadData2), .B(se_pc), .C(ALUSrc_o), .select(ALUSrc));
    
    // ALU
    ALU u_alu(.input_a(ReadData1), .input_b(ALUSrc_o), 
                .ALUop(ALUOp), .result(ALU_result), .Z(ALU_zero_flag));
    
    // Data Memory
    DataMemory u_dm(.Addr(ALU_result), .Write_data(ReadData2), 
                    .MemWrite(MemWrite), .MemRead(MemRead), 
                    .clk(clk), .rst(rst), 
                    .ReadData(DM_o));
                    
    // MUX MemtoReg
    MUX_64bit u_MemtoReg (.A(ALU_result), .B(DM_o), .C(WriteData), .select(MemtoReg));
    
    // Branch Unit
    branch_unit u_bu(.branch(Branch), .pc_0(pc_0), 
                    .pc_1(pc_1), .se_pc(se_pc), .pc_branch(pc_branch));
    
endmodule


