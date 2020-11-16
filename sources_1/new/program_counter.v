`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2020 03:47:13 AM
// Design Name: 
// Module Name: program_counter
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


module program_counter(clk, rst, pc_branch, pc_1, pc_0);
    input clk; 
    input rst;
    input [63:0] pc_branch; // input from the branch unit
    output reg [63:0] pc_0 = 0; // pc of the previous time slot
    output reg [63:0] pc_1; // pc increment by one

    // Async reset
    always @(posedge rst)// reset to initial pc, pc = 0
    begin
        pc_0 <= 0;
        pc_1 <= 1;
    end
    
    // 
    always @(posedge clk)
    begin
        if (pc_branch != pc_1)
        begin
             pc_0 = pc_branch;
        end
        else if (pc_branch == pc_1)
        begin
            pc_0 = pc_0 +1;    
        end
        
        pc_1 = pc_0 +1;
    end

endmodule
