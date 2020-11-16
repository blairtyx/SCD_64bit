`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2020 05:10:58 PM
// Design Name: 
// Module Name: SignExtend
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


module SignExtend(
    input [31:0] instru,
    input signExtend,
    output reg  [63:0] se_pc
    );
    
    always @(instru, signExtend)
        begin
            case (signExtend)
                  0: se_pc = {{43{instru[20]}},instru[20:0]}; // read from Instr[20:0], D-format instruction
                  1: se_pc = {{53{instru[20]}},instru[20:10]};// read from Instr[20:10], B-format instruction    
            endcase
        
        end
    
    
endmodule
