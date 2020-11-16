module DataMemory(Addr, Write_data, MemWrite, MemRead, clk, rst, ReadData);

    input wire[63:0] Addr;
    input wire [63:0] Write_data;
    input wire MemWrite;
    input wire MemRead;
    input wire clk;
    input wire rst;
    output reg [63:0] ReadData;
    


    integer i; // for initialization or reset
    parameter BITSIZE = 64;
    parameter MEMSIZE = 64;
    reg [BITSIZE-1:0] data_memory [0:MEMSIZE-1]; // reg array as the memory


    // when address changes, 
    always @(Addr, MemWrite, MemRead)
    begin
        // read case, write disabled, read enabled.
        if (~MemWrite && MemRead)
            begin
            ReadData <= data_memory[Addr];
            end   
    end

    always @(posedge clk)
    begin
        if (rst)
        begin
            for (i=0; i<MEMSIZE; i = i + 1) data_memory[i] <= 'b0;// reset reg array to all zero
        end
        // write case, write enabled and read disabled
        else if (MemWrite && ~MemRead)
        begin 
            data_memory[Addr] <= Write_data;
        end
    end

endmodule