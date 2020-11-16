`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2020 03:49:04 AM
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb(

    );
    reg [63:0] input_a;
    reg [63:0] input_b;
    reg [3:0] ALUop;
    wire [63:0] result;
    wire Z;
    integer i,j,k;
    integer FILE;
    
    
    
    
    ALU U1 (.input_a(input_a), .input_b(input_b), .ALUop(ALUop), .result(result), .Z(Z));
    
    
    initial begin
        FILE = $fopen("/home/centos/Documents/ALU_tb.txt");
        input_a = 0;
        input_b = 0;
        
        ALUop = 1;
        
        for (i = 1; i < 7; i=i+1)
            begin
                for (j = 0; j < 16; j = j+1)
                    begin
                        for(k = 0; k <16; k = k+1)
                            begin
                                
                                $fdisplay(FILE, "input_a:%h     | input_b:%h        | ALUop: %b         | result: %h        ",input_a, input_b, ALUop, result);
                                input_a = input_a +1;
                                #10;
                            end
                        
                        
                        input_b = input_b +1;
                    end
                ALUop = ALUop +1;
            end
    end
endmodule
