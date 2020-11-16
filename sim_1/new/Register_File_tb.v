`timescale 1ns / 1ps

module register_file_tb ();

parameter BITSIZE = 64;
parameter REGSIZE = 32;
reg [$clog2(REGSIZE)-1:0] ReadSelect1, ReadSelect2, WriteSelect;
reg [BITSIZE-1:0] WriteData;
reg WriteEnable;
wire [BITSIZE-1:0] ReadData1, ReadData2;
reg clk, rst;
integer i, j, k;


Register_File U1 (ReadSelect1, ReadSelect2, WriteSelect, WriteData, WriteEnable, ReadData1, ReadData2, clk, rst);


always
    begin
    #5 clk <= ~clk;
end


initial
begin
    clk = 1;
    rst = 1;

    #4 rst = 0;
    #6;
    ReadSelect1 = 0;
    ReadSelect2 = 0;
    WriteSelect = 0;
    WriteData = 100;
    
    // read test
    for(i = 0; i < REGSIZE; i = i +1)
    begin
        for(j = 0; j<REGSIZE ;j = j+1)
        begin
            #10;
            ReadSelect2 = ReadSelect2 +1;
            
        end
        ReadSelect1 = ReadSelect1 +1;
    end
    
    // write test
    WriteEnable = 1;
    
    for(k = 0; k < REGSIZE; k = k +1)
    begin
        #10;
        WriteSelect = WriteSelect + 1;
        WriteData = WriteData + 10;
        
    end
    WriteEnable = 0;
    
    // read after write
    ReadSelect1 = 0;
    ReadSelect2 = 0;
    for(i = 0; i < REGSIZE; i = i +1)
    begin
        #10;
        ReadSelect1 = ReadSelect1 +1;
        
    end

end


endmodule
