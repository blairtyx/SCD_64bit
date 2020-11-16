module Register_File(ReadSelect1, ReadSelect2, WriteSelect, WriteData, WriteEnable, ReadData1, ReadData2, clk, rst);

    parameter BITSIZE = 64;
    parameter REGSIZE = 32;
    input [$clog2(REGSIZE)-1:0] ReadSelect1, ReadSelect2, WriteSelect;
    input [BITSIZE-1:0] WriteData;
    input WriteEnable;
    output reg [BITSIZE-1:0] ReadData1, ReadData2;
    input clk, rst;

    reg [BITSIZE-1:0] reg_file [REGSIZE-1:0];   // Entire list of registers

    integer i;                                  // Used below to rst all registers

    // Asyncronous read of register file.
    // at readselect1, or the content of reg_file is changing
    always @(ReadSelect1, reg_file[ReadSelect1])
        begin
            ReadData1 = reg_file[ReadSelect1];
        end

    // Asyncronous read of register file.
    // at readselect2, or the content of reg_file is changing
    always @(ReadSelect2, reg_file[ReadSelect2])
        begin
            ReadData2 = reg_file[ReadSelect2];
        end

    // Write back to register file on clk edge.
    // write back at the beginning of next cycle???
    always @(posedge clk)
        begin
            if (rst)begin
                reg_file[0] <= 0;
                reg_file[1] <= 1;
                reg_file[2] <= 2;
                reg_file[3] <= 3;
                for (i=4; i<REGSIZE; i=i+1) reg_file[i] <= 'b0; // rst all registers
                end
            else
            begin
                if (WriteEnable && WriteSelect != 31) // 31 is preserved for xzr
                    reg_file[WriteSelect] <= WriteData; //If writeback is enabled and not xzr register.
            end
        end

endmodule