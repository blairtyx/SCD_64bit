`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: 5bit Multiplexer
// tyx
//////////////////////////////////////////////////////////////////////////////////

module MUX_5bit(A, B, C, select);
    input [4:0] A, B;
    output reg [4:0] C;
    input select;
   
    always @ (A, B, select)
    begin 
        case (select)
            0: C = A;
            1: C = B;
        endcase
    end
endmodule
