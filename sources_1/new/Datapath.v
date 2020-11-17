//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: TA defined datapath module
// tyx
//////////////////////////////////////////////////////////////////////////////////

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
    output [63:0] memAddr;// Data memory Address , ALU_result
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
    
    /* Control signals  */ 
    wire RegtoLoc, RegWrite, ALUSrc, Branch, MemtoReg, SignExtend;
    wire [10:0] ALUOp;
    
    /* Sign Extension Unit */
    wire [63:0] se_pc;// sign extended pc 

    /* MUX ALUSrc output*/
    wire [63:0] ALUSrc_o;
    
    /* ALU output*/
    wire [63:0] ALU_result;
    wire ALU_zero_flag;

    // program counter
    program_counter u_pc (
        .clk(clk), .rst(rst),               // input, external
        .pc_branch(pc_branch),              // input, internal
        .pc_1(pc_1),                        // output, internal 
        .pc_0(ins_Addr)                     // output, external & internal
        );
    
    // 5bit MUX RegtoLoc
    MUX_5bit u_RegtoLoc (.A(ins[20:16]),    // input, external
                .B(ins[4:0]),               // input, external 
                .C(rReadSelect2),           // output, external
                .select(RegtoLoc)           // input, internal
                );
    
    // Control logic 
    Control_logic u_cl (.Opcode(ins[31:21]),// input, external
                    .RegtoLoc(RegtoLoc),    // output, internal
                    .RegWrite(rWriteEnable),// output, internal
                    .ALUSrc(ALUSrc),        // output, internal
                    .ALUOp(ALUOp),          // output, internal
                    .Branch(Branch),        // output, internal
                    .MemWrite(MemWrite),    // output, internal
                    .MemRead(MemRead),      // output, internal
                    .MemtoReg(MemtoReg),    // output, internal
                    .SignExtend(SignExtend) // output, internal
                    );
                    
    // Sign Extension Unit
    SignExtend u_se(.instru(ins),           // input, external
                .signExtend(SignExtend),    // input, internal
                .se_pc(se_pc)               // output, internal
                );
    
    // MUX ALUSrc
    MUX_64bit u_ALUSrc (.A(rReadData2),     // input, external 
                        .B(se_pc),          // input, internal
                        .C(ALUSrc_o),       // output, internal
                        .select(ALUSrc)     // input, internal
                        );
    
    // ALU
    ALU u_alu(.input_a(rReadData1),         // input, external
                .input_b(ALUSrc_o),         // input, internal
                .ALUop(ALUOp),              // input, internal
                .result(ALU_result),        // output, internal & external
                .Z(ALU_zero_flag)           // output, external, not defined
                );
                    
    // MUX MemtoReg
    MUX_64bit u_MemtoReg (.A(ALU_result),   // input, internal
                .B(memReadData),            // input, external
                .C(rWriteData),             // output, external
                .select(MemtoReg)           // input, internal
                );
    
    // Branch Unit
    branch_unit u_bu(
                    .branch(Branch),        // input, internal
                    .pc_0(ins_Addr),        // input, internal
                    .pc_1(pc_1),            // input, internal
                    .se_pc(se_pc),          // input, internal
                    .pc_branch(pc_branch)   // output, internal
                    );
                    
    assign rReadSelect1 = ins[9:5];
    assign rWriteSelect = ins[4:0];
    assign memWriteData = rReadData2;
    assign memAddr = ALU_result;
endmodule


