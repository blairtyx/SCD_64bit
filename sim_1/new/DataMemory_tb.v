`timescale 1ns / 1ps


module DataMemory_tb();
    
    reg clk, rst, mem_write, mem_read;
    reg [63:0] address;
    reg [63:0] write_data;
    wire [63:0] read_data;
    integer i, j, FILE;
    
    DataMemory U1 (.Addr(address), 
    .Write_data(write_data), 
    .MemWrite(mem_write), 
    .MemRead(mem_read), 
    .clk(clk), 
    .rst(rst), 
    .ReadData(read_data));


    
    
    always
        begin
        #5 clk <= ~clk;
    end
    
    
    initial 
    begin
        FILE = $fopen("/home/centos/Documents/DataMemory_tb.txt");
        clk = 1;
        rst =1;
        mem_write = 0;
        mem_read = 0;
        address = 0;
        write_data = 0;
        #9 rst = 0;
        
        #1 mem_read = 1;
        $fdisplay(FILE, "read test after initialization");
        for (j = 0; j < 64; j = j+1)
        begin
             address <= j;
            #1 $fdisplay(FILE, "j: %d      | address: %h       | read_data: %d         ", j, address, read_data);
            #9;            
        end
        mem_read = 0;
        
        // enable writing
        mem_write = 1;
        // write test
        $fdisplay(FILE, "write test");
        for (i=0; i<64; i = i + 1) 
        begin
            address <= i;
            write_data <= i;
            #1$fdisplay(FILE, "i: %d      | address: %h       | write_data: %d         ", i, address, write_data);
            #9;
        end
        
        //disable write
        mem_write = 0;
        
        
        //enalbe write
        mem_read = 1;
        //read from data memory
        $fdisplay(FILE, "read test after write");
        for (j = 0; j < 64; j = j+1)
        begin
            address <= j;
            #1 $fdisplay(FILE, "j: %d      | address: %h       | read_data: %d         ", j, address, read_data);
            #9;
        end
        mem_read = 0;
        
        
        // test reset
        rst = 1;
        mem_read = 1;
        $fdisplay(FILE, "read test after reset");
        for (j = 0; j < 64; j = j+1)
        begin
            address <= j;
            #1$fdisplay(FILE, "j: %d      | address: %h       | read_data: %d         ", j, address, read_data);
            #9;
        end
        
        
        
    end
endmodule