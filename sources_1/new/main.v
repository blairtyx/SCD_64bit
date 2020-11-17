`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: TA defined main module (top module)
// tyx
//////////////////////////////////////////////////////////////////////////////////

module SCD_main(clk, rst);
    
    input clk;
    input rst;
    
    wire [63:0] IM_Address;
    wire [31:0] IM_instr;
    
    wire [4:0] RF_ReadSelect1, RF_ReadSelect2, RF_WriteSelect;
    wire [63:0] RF_WriteData, RF_ReadData1, RF_ReadData2;
    
    wire [63:0] DM_ReadData, DM_Address, DM_WriteData;
    
    wire CU_WriteEnable, CU_MemWrite, CU_MemRead;
    
    Datapath u_DP(
        .clk(clk),                      // input
        .rst(rst),                      // input
        .ins_Addr(IM_Address),          // output
        .ins(IM_instr),                 // input from Instruction Memory
        .memAddr(DM_Address),           // Output of ALU
        .memWriteData(DM_WriteData),    // output of Register_file, ReadData2
        .memReadData(DM_ReadData),      // input, from Register File, ReadData2 
        .MemWrite(CU_MemWrite),         // output of Control Unit
        .MemRead(CU_MemRead),           // output of Control Unit
        .rWriteEnable(CU_WriteEnable),  // output of Control Unit
        .rReadSelect1(RF_ReadSelect1),  // output Instruction[9:5]
        .rReadSelect2(RF_ReadSelect2),  // output MUX RegtoLoc
        .rWriteSelect(RF_WriteSelect),  // output of Instruction[4:0]
        .rWriteData(RF_WriteData),      // output of MUX MemtoRegs
        .rReadData1(RF_ReadData1),      // input, from Register File, ReadData1
        .rReadData2(RF_ReadData2)       // input, from Register File, ReadData2
    );
    
    Instruction_Memory u_IM(
        .Address(IM_Address), // input
        .ReadData1(IM_instr) // output
    );
    
    Register_File u_RF(
        .ReadSelect1(RF_ReadSelect1), // input
        .ReadSelect2(RF_ReadSelect2), // input
        .WriteSelect(RF_WriteSelect), // input
        .WriteData(RF_WriteData),  // input
        .WriteEnable(CU_WriteEnable), // input
        .ReadData1(RF_ReadData1), // output
        .ReadData2(RF_ReadData2), //output
        .clk(clk), // input
        .rst(rst) // input
    );
    
    DataMemory u_DM(
        .Addr(DM_Address), // input
        .Write_data(DM_WriteData), // input
        .MemWrite(CU_MemWrite), // input
        .MemRead(CU_MemRead), //input
        .clk(clk), // input
        .rst(rst), // input
        .ReadData(DM_ReadData) // output
    );
endmodule
