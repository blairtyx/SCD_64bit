`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Single Cycle Datapath 64bit
// Module Name: Control Logic
// Discription:
//      Generate Control bits to MUX and other unit.
// tyx
//////////////////////////////////////////////////////////////////////////////////


module Control_logic (Opcode, RegtoLoc, RegWrite, 
                    ALUSrc, ALUOp, Branch, 
                    MemWrite, MemRead, MemtoReg, SignExtend);
    input [10:0] Opcode; // 11 bit opcode, from instruction
    output reg RegtoLoc;
    output reg RegWrite;
    output reg ALUSrc;
    output reg [3:0] ALUOp;
    output reg Branch;
    output reg MemWrite;
    output reg MemRead;
    output reg MemtoReg;
    output reg SignExtend;

    // Opcode triggering
    always @(Opcode)
    begin
        case(Opcode)
            // Branch, B-type instruction
            11'h0B0:
                begin
                    RegtoLoc <= 1'bX; 
                    RegWrite <= 0;
                    ALUSrc <= 1'bX; // ALU not used
                    ALUOp <= 1'bX;// ALU not used
                    Branch <= 1; // Branch Unit generate new address of pc
                    MemWrite <= 0;
                    MemRead <= 0;
                    MemtoReg <= 1'bX;
                    SignExtend <= 0;// read from instr[20:0]
                end 
            // AND
            11'h430:
                begin
                    RegtoLoc <= 0;
                    RegWrite <= 1;
                    ALUSrc <= 0;
                    ALUOp <= 1;
                    Branch <= 0;
                    MemWrite <= 0;
                    MemRead <= 0;
                    MemtoReg <= 0;
                    SignExtend <= 1'bX;// immediate not used
                end
            // ADD
            11'h258:
                begin
                    RegtoLoc <= 0;
                    RegWrite <= 1;
                    ALUSrc <= 0;
                    ALUOp <= 4;
                    Branch <= 0;
                    MemWrite <= 0;
                    MemRead <= 0;
                    MemtoReg <= 0;
                    SignExtend <= 1'bX;// immediate not used
                end
            // ORR
            11'h590:
                begin
                    RegtoLoc <= 0;
                    RegWrite <= 1;
                    ALUSrc <= 0;
                    ALUOp <= 2;
                    Branch <= 0;
                    MemWrite <= 0;
                    MemRead <= 0;
                    MemtoReg <= 0;
                    SignExtend <= 1'bX;// immediate not used
                end
            // SUB
            11'h124:
                begin
                    RegtoLoc <= 0;
                    RegWrite <= 1;
                    ALUSrc <= 0;
                    ALUOp <= 5;
                    Branch <= 0;
                    MemWrite <= 0;
                    MemRead <= 0;
                    MemtoReg <= 0;
                    SignExtend <= 1'bX;// immediate not used
                end
            // STUR
            11'h7E0:
                begin
                    RegtoLoc <= 1;
                    RegWrite <= 0;
                    ALUSrc <= 1;
                    ALUOp <= 4;// add base and offset 
                    Branch <= 0;
                    MemWrite <= 1;
                    MemRead <= 0;
                    MemtoReg <= 1'bX;
                    SignExtend <= 1; // read from Instr[20:10]
                end
            // LDUR
            11'h7A2:
                begin
                    RegtoLoc <= 1'bX;
                    RegWrite <= 1;
                    ALUSrc <= 1;
                    ALUOp <= 4;// add base and offset
                    Branch <= 0;
                    MemWrite <= 0;
                    MemRead <= 1;
                    MemtoReg <= 1;
                    SignExtend <= 1; // read from Instr[20:10]
                end
        endcase
    end
endmodule
