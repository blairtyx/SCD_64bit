`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2020 01:58:11 AM
// Design Name: 
// Module Name: branch_unit
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


module branch_unit(branch, pc_0,pc_1, se_pc, pc_branch);
    input branch;// control bit
    input [63:0] pc_0; // pc for last instruction
    input [63:0] se_pc; // sign-extended pc, offset value
    input [63:0] pc_1; // incremented pc
    output reg [63:0] pc_branch = 0;
    
    always @(se_pc, branch,pc_0)
    begin
        if (branch)
        begin
            pc_branch <= pc_0 + se_pc;// unconditional branch case, pc <- pc + offset value, left shift by 2 
        end
        else
        begin
            pc_branch <= pc_1;// not branching case, pc <- pc + 1  
        end
    end
    


endmodule
