`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: program_counter
// tyx

// version: 1.1
// Update: Syncronous Reset
//////////////////////////////////////////////////////////////////////////////////


module program_counter(clk, rst, pc_branch, pc_1, pc_0);
    input clk; 
    input rst;
    input [63:0] pc_branch; // input from the branch unit
    output reg [63:0] pc_0 = 0; // pc of the previous time slot
    output reg [63:0] pc_1; // pc increment by one

    // clock trigger, pause if rst == 1
    always @(posedge clk)
    begin
        // Sync Reset
        if (rst)
        begin
            pc_0 <= 0;
            pc_1 <= 0;// special input, only occur when rst is 1
        end
    
        // Normal case
        else
        begin
            // unconditional branch case, pc_branch doesn't match pc_1
            if (pc_branch != pc_1) 
            begin
                 pc_0 = pc_branch;
            end
            
            // normal case, pc is incremented by one
            else if (pc_branch == pc_1 && pc_1 != 0)
            begin
                pc_0 = pc_0 +1;    
            end
            // one cycle after the reset
            else if (pc_branch == pc_1 && pc_1 ==0 )
            begin
                pc_0 = 0;
            end
            
            // indicating the next instruction for next cycle
            pc_1 = pc_0 +1;
        end
    end
endmodule
