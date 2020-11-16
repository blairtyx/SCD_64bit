`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2020 08:49:48 PM
// Design Name: 
// Module Name: Datapath_test_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Datapath_test_tb(

    );
    
    
    reg clk, rst;
    wire [63:0] ins_Addr;//Instructions Address
    wire [31:0] ins;//instruction
    
    //ports for Data Memory
    wire [63:0] memAddr;// Data memory Address 
    wire [63:0] memWriteData;// Data wrote to data memory
    wire  MemWrite_o; // control signal
    wire  MemRead_o; // control signal
    wire [63:0] memReadData;//Read data from memory
    
    //ports for Register file
    wire [4:0] rReadSelect1, rReadSelect2, rWriteSelect; // Control singal for Reginster file
    wire [63:0] rWriteData; // Data wrote to Register file
    wire rWriteEnable;// Control singal for Reginster file
    wire [63:0] rReadData1, rReadData2;
    
    Datapath_test u_tb(

    clk,rst,
    
    ins_Addr,
    ins,
    
    memAddr,memWriteData,memReadData,MemWrite_o,MemRead_o,
    
    rReadSelect1,rReadSelect2,rWriteSelect,rWriteData,rWriteEnable,rReadData1,rReadData2
    );
    
    
    //clock
    always
        begin
        
            #5 clk = ~clk;
        end
    
    initial
        begin
            rst = 1;
            clk = 1;
            #1 rst = 0;
            //# 2 rst = 0;
            #100;
            $finish;
    
    
        end
    
    
    
endmodule
