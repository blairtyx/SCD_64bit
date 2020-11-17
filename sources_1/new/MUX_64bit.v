`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: 64bit Multiplexer
// tyx
//////////////////////////////////////////////////////////////////////////////////


module MUX_64bit(A, B, C, select);
    input [63:0] A, B;
    output reg [63:0] C;
    input select;
   
    always @ (A, B, select)
    begin 
        case (select)
            0: C = A;
            1: C = B;
        endcase
    end
endmodule

