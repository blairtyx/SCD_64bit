`timescale 1ns / 1ps

module program_counter_tb();

reg clk;
reg rst;

integer i;

reg branch;// control unit
wire [63:0] pc_0; // pc for last instruction
reg [63:0] se_pc; // sign-extended pc, offset value
wire [63:0] pc_1; // incremented pc
wire [63:0] pc_branch;


program_counter U1 (clk, rst, pc_branch, pc_1, pc_0);


branch_unit U2 (branch, pc_0,pc_1, se_pc, pc_branch);



always
begin
    #5 clk = ~clk;
end


initial
begin
    branch = 0;
    clk = 1;
    rst = 1;
    se_pc = 0;
    
    #4 rst = 0;
    #6;
    #100; // run with no branch
    
    branch = 1;
    se_pc = 1000;
    #10 branch = 0;
    #100;
    
    branch = 1;
    se_pc = -100; // backward branch;
    #10 branch = 0;
    #100;
    
    

    
end

endmodule