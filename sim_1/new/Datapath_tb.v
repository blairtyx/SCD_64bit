`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: TA defined testbench module
// tyx
//////////////////////////////////////////////////////////////////////////////////

module Datapath_tb();
    
    reg clk, rst;
    SCD_main u_main (.clk(clk), .rst(rst));
    
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
            #104;
            rst = 1;
            #7 rst = 0;
            # 200;
            $finish;
        end
    
endmodule