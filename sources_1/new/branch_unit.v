`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: branch_unit
// tyx
//////////////////////////////////////////////////////////////////////////////////


module branch_unit(branch, pc_0,pc_1, se_pc, pc_branch);
    input branch;// control bit
    input [63:0] pc_0; // pc of current instruction
    input [63:0] se_pc; // sign-extended pc, from sign_extension unit
    input [63:0] pc_1; // incremented pc, from program_counter
    output reg [63:0] pc_branch = 0; // we assume that pc_0 starts with 0
    
    always @(se_pc, branch,pc_0, pc_1)
    begin
        if (pc_1 == 0)
        begin
            pc_branch = 0;            
        end
        
        else
        begin
            // unconditional branch case, pc_branch <- pc_0 + [offset value]  
            if (branch)
            begin
                pc_branch <= pc_0 + se_pc;
            end
            
            // not branching case, pass pc_1 = pc_0 +1 to pc_branch
            else 
            begin
                pc_branch <= pc_1;
            end
        end
    end
endmodule
