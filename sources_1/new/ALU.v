//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: ALU
// tyx
//////////////////////////////////////////////////////////////////////////////////


module ALU (input_a, input_b, ALUop, result, Z);
    parameter BITSIZE = 64;
    input [BITSIZE-1:0] input_a;
    input [BITSIZE-1:0] input_b;
    input [3:0] ALUop;
    output reg [BITSIZE-1:0] result;
    output Z;
    
    always @(input_a, input_b, ALUop) begin
        case(ALUop)
            // AND
            4'h1: result <= input_a & input_b;
            // OR
            4'h2: result <= input_a | input_b;
            // NOT
            4'h3: result <= ~input_a;
            // Add
            4'h4: result <= input_a + input_b;
            // subtraction
            4'h5: result <= input_a - input_b;
            // self defined operation, xzr
            4'h6: result <= 0;
        endcase
    end
    assign Z = (result == 0)? (1'b1):(1'b0);
endmodule