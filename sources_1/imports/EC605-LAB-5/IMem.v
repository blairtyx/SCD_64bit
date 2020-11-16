`timescale 1ns / 1ns
module Instruction_Memory(Address, ReadData1);

	parameter BITSIZE = 32;
	parameter REGSIZE = 64;
	input [REGSIZE-1:0] Address;
	output reg [BITSIZE-1:0] ReadData1;

	reg [BITSIZE-1:0] memory_file [0:REGSIZE-1];	// Entire list of memory

	// Asyncronous read of memory. Was not specified.
	always @(Address, memory_file[Address])
		begin
			ReadData1 = memory_file[Address];
		end
    
    
    integer i;
    
    /*
    Branch: 11'h0B0 = 11'b000_1011_0000
    
    AND: 11'h430 = 11'b100_0011_0000
    
    ADD: 11'h258 = 11'b010_0101_1000
    
    ORR: 11'h590 = 11'b101_1001_0000
    
    SUB: 11'h124 = 11'b001_0010_0100
    
    STUR 11'h7E0 = 11'b111_1110_0000
    
    LDUR 11'h7A2 = 11'b111_1010_0010
    
    
    
    
    
    Example code:
    
    // ADD test
    
                         |opcode       | Rm  | Shamt| Rn  | Rt   
    ADD x4, x1, x3 => 32'b010_0101_1000_00011_000000_00001_00100;
    
    ADD x5, x1, x4 => 32'b010_0101_1000_00100_000000_00001_00101;
    
    x0 =0, x1 = 1, x2 = 2, x3 = 3, x4 = 4, x5 = 5
    
    // AND test
                         |opcode       | Rm  | Shamt| Rn  | Rt   
    AND x6, x1, x3 => 32'b100_0011_0000_00011_000000_00001_00110;
    
    AND x18,x1, x3 => 32'b100_0011_0000_00011_000000_00001_10010;
    
    x0 =0, x1 = 1, x2 = 2, x3 = 3, x4 = 4, x5 = 5, x6 = 1, x18 = 1

    
    // ORR test
                         |opcode       | Rm  | Shamt| Rn  | Rt   
    ORR x7, x1, x3 => 32'b101_1001_0000_00011_000000_00001_00111;
    
    ORR x8, x5, x7 => 32'b101_1001_0000_00111_000000_00101_01000;
    
    x0 =0, x1 = 1, x2 = 2, x3 = 3, x4 = 4, x5 = 5, x6 = 1, x18 = 1, x7 = 3, x8 = 7

    
    //SUB test
                         |opcode       | Rm  | Shamt| Rn  | Rt   
    SUB x9, x8, x7 => 32'b001_0010_0100_00111_000000_01000_01001; x8 - x7 -> x9 (7-3 ->4), x9 = 4
    
    SUB x10, x7,x8 => 32'b001_0010_0100_01000_000000_00111_01010; x8 - x7 ->x10 (3-7 
    
    // STUR test
                         |opcode       | DT address | Rn  | Rt   
    STUR x1,[x0, #0]  32'b111_1110_0000_00000_000000_00000_00001; // store content in x1 to [x0 + 0]
    STUR x2,[x0, #1]  32'b111_1110_0000_00000_000001_00000_00010; // store content in x2 to [x0 + 1]
    STUR x4,[x3, #10] 32'b111_1110_0000_00000_001010_00011_00100; // store content in x4 to [x3 + 10]
    
    // LDUR test
                         |opcode       | DT address | Rn  | Rt   
    LDUR x11,[x0,#13] 32'b111_1010_0010_00000_001101_00000_01011; // load content in [x0 + 13] to x11
    LDUR x12,[x1,#0]  32'b111_1010_0010_00000_000000_00001_01100; // load content in [x1 + 0 ] to x12
    
    
    */
    
    
    
    
    
    initial 
    begin
        // ADD test
        memory_file[0] = 32'b010_0101_1000_00011_000000_00001_00100; // ADD x4, x1, x3
        memory_file[1] = 32'b010_0101_1000_00100_000000_00001_00101; // ADD x5, x1, x4
        // AND test
        memory_file[2] = 32'b100_0011_0000_00011_000000_00001_00110; // AND x6, x1, x3
        memory_file[3] = 32'b100_0011_0000_00011_000000_00001_10010; // ADD x5, x1, x4
        // ORR test
        memory_file[4] = 32'b101_1001_0000_00011_000000_00001_00111; // ORR x7, x1, x3 
        memory_file[5] = 32'b101_1001_0000_00111_000000_00101_01000; // ORR x8, x5, x7
        // SUB test
        memory_file[6] = 32'b001_0010_0100_00111_000000_01000_01001; // SUB x9, x8, x7
        memory_file[7] = 32'b001_0010_0100_01000_000000_00111_01010; // SUB x10, x7,x8
        // Branch test
        // memory_file[8] = 32'b000_1011_0000_11111_111111_11111_11000; // Branch to start, backward branch
        memory_file[8] = 32'b000_1011_0000_00000_000000_00000_00100; // Branch to IMem[12]
        
        
        memory_file[10] = 32'b000_1011_0000_00000_000000_00000_01000; // Branch to IMem[18]
        
        memory_file[12] = 32'b000_1011_0000_11111_111111_11111_11110; // Branch to IMem[10]
        
        // STUR test
        memory_file[18] = 32'b111_1110_0000_00000_000000_00000_00001; // STUR x1,[x0, #0] check DM[0]
        memory_file[19] = 32'b111_1110_0000_00000_000001_00000_00010; // STUR x2,[x0, #1] check DM[1]
        memory_file[20] = 32'b111_1110_0000_00000_001010_00011_00100;// STUR x4,[x3,#10] check DM[13]
        
        // LDUR test
        memory_file[21] = 32'b111_1010_0010_00000_001101_00000_01011; // LDUR x11,[x0,#13] check x11
        memory_file[22] = 32'b111_1010_0010_00000_000000_00001_01100; // LDUR x12,[x1,#0] check x12
    
    end
endmodule
