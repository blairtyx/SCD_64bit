`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2020 06:29:50 PM
// Design Name: 
// Module Name: MUX_5bit
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
