`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: Control Logic
// Discription:
//      2 cases:
//          1. signExtend == 0, used in B-type instruction, read from Instru[20:0]
//          2. signExtend == 1, used in D-type instruction, read from Instru[20:10], 
//      Both case would sign extend regarding to the MSB of selected bit segment.(Instru[20]) 
// tyx
//////////////////////////////////////////////////////////////////////////////////

module SignExtend(
    input [31:0] instru,
    input signExtend,
    output reg  [63:0] se_pc
    );
    
    always @(instru, signExtend)
        begin
            case (signExtend)
                  0: se_pc = {{43{instru[20]}},instru[20:0]}; // read from Instr[20:0], B-format instruction
                  1: se_pc = {{53{instru[20]}},instru[20:10]};// read from Instr[20:10], D-format instruction    
            endcase
        end
endmodule
