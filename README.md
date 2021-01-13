# SCD_64bit

### An ARM-based 64bit Single Cycle Datapath Design.
- Supporting one small sub-set of the ARMv8 ISA.
- Modular architecture, supporting variant instruction memory, register file components for testing.
- Available for further expanding of instruction set.


### File Structure:

```
temp:
[module name]{instance_name} 				- <file name>						
		- next level
		
Design File:
[SCD_main] - <main.v>
	- [Datapath]{u_DP} 				- <Datapath.v>					
        	- [ALU]{u_ALU}				- <ALU.v>
        	- [branch_unit]{u_bu} 			- <branch_unit.v>
        	- [Control_logic]{u_cl} 		- <Control_logic.v>
       		- [MUX_5bit]{u_RegtoLoc} 		- <MUX_5bit.v>
		- [MUX_64bit]{u_ALUSrc} 		- <MUX_64bit.v>
		- [MUX_64bit]{u_MemtoReg} 		- <MUX_64bit.v>
		- [program_counter]{u_pc} 		- <program_counter.v>
		- [SignExtend]{u_se} 			- <SignExtend.v>
	- [Instruction_Memory]{u_IM} 			- <IMem.v>
	- [Register_File]{u_RF} 			- <Register_File.v>
	- [DataMemory]{u_DM} 				- <DataMemory.v>
		
Simulation File:
[Datapath_tb] 						- <Datapath_tb.v>
	- [SCD_main]{u_main} 				- <main.v>
```



### Block Diagram of the Single Cycle Datapath:

![image](https://github.com/blairtyx/SCD_64bit/blob/main/image.png)

### Test Code:

#### Datapath_tb.v

```verilog
module Datapath_tb();
    reg clk, rst;
    // one instance of main module
    SCD_main u_main (.clk(clk), .rst(rst));

  	//clock
    always
        begin
            #5 clk = ~clk;
        end
    // main test
  	initial
        begin
            rst = 1;// initialize all storage modules
            clk = 1;
            #1 rst = 0;
            #104;// run for several instructions
            rst = 1;// reset test
            #7 rst = 0;
            # 200;// run all the instructions defined in IMem.v
            $finish;
        end
endmodule
```



#### IMem.v

```verilog
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
    initial 
    begin
        /********** ADD test **********/
        // ADD x4, x1, x3 check x4
        memory_file[0] = 32'b010_0101_1000_00011_000000_00001_00100; 
        // ADD x5, x1, x4 check x5
        memory_file[1] = 32'b010_0101_1000_00100_000000_00001_00101; 
        
        /********** AND test **********/
        // AND x6, x1, x3 check x6
        memory_file[2] = 32'b100_0011_0000_00011_000000_00001_00110; 
        // AND x5, x1, x4 check x5
        memory_file[3] = 32'b100_0011_0000_00011_000000_00001_10010; 
        
        /********** ORR test **********/
        // ORR x7, x1, x3 check x7
        memory_file[4] = 32'b101_1001_0000_00011_000000_00001_00111; 
        // ORR x8, x5, x7 check x8
        memory_file[5] = 32'b101_1001_0000_00111_000000_00101_01000; 
        
        /********** SUB test **********/
        // SUB x9, x8, x7 check x9
        memory_file[6] = 32'b001_0010_0100_00111_000000_01000_01001; 
        // SUB x10, x7,x8 check x10
        memory_file[7] = 32'b001_0010_0100_01000_000000_00111_01010; 
        
        /********** Branch test **********/
        // Branch to IMem[12]
        memory_file[8] = 32'b000_1011_0000_00000_000000_00000_00100; 
        // Branch to IMem[18]
        memory_file[10] = 32'b000_1011_0000_00000_000000_00000_01000; 
        // Branch to IMem[10]
        memory_file[12] = 32'b000_1011_0000_11111_111111_11111_11110; 
        
        /********** STUR test **********/
        // STUR x1,[x0, #0] check DM[0]
        memory_file[18] = 32'b111_1110_0000_00000_000000_00000_00001; 
        // STUR x2,[x0, #1] check DM[1]
        memory_file[19] = 32'b111_1110_0000_00000_000001_00000_00010; 
        // STUR x4,[x3,#10] check DM[13]
        memory_file[20] = 32'b111_1110_0000_00000_001010_00011_00100;
        
        /********** LDUR test **********/
        // LDUR x11,[x0,#13] check x11
        memory_file[21] = 32'b111_1010_0010_00000_001101_00000_01011; 
        // LDUR x12,[x1,#0] check x12
        memory_file[22] = 32'b111_1010_0010_00000_000000_00001_01100; 
    end
endmodule

```





### Test Description:

#### Clock: 

10ns / 100MHz

#### Initialization:

Take 1ns, at the beginning of the first cycle. 

Several components would be set to initial state at the begining of this cycle, including:

- Program Counter, ( `pc_0` is set to 0, `pc_1` is set to 1)
- Data Memory, (All 64 entries are set to zeros)
- Insctruction Memory, ( Predefined instuctions would be set to `memory_file` register array)
- Register File, ( The leading 4 registers are set to 0, 1, 2, 3, respectively, while the other are all set to zero)
- Branch Unit, (`pc_branch` is set to 0)

We assume that this first cycle do not operate (pause state), since `rst == 1` at the beginning of this cycle. Hence `pc_0`, which indicates the program counter would not change. In the Waveform, one would expect that nothing is changing in the next cycle. This applies to all the cases of cycle `t(a)` , that `rst == 1` at cycle `t(a-1), posedge` .



#### Sequential Reading, R-format Instruction Test

We predefined (complied) several test instructions for test, stored in the leading position of the Instruction Memory. Covering all Supported Opcode/Instructions, including AND, ADD, ORR, and SUB.

Register File is expected to be updated after one clock cycle. The data been updated in cycle `t(a-1)` is expected to be available at the very beginning of cycle `t(a)`. We have tested this case. 

Participating components including: (following the relative data propagation order)

- Program Counter
- Instruction Memory
- Control Unit
- RegtoLoc Multiplexer
- Register File (with write function)
- Branch Unit (for normal pc increment only)
- ALUSrc Multiplexer
- ALU
- MemtoReg Multiplexer

Note that *SignExtension Unit* and *Data Memory* is not involved in this phase of test



#### B-format Instuction Test

We perform 3 branches in this part, to test both forwarding branch and backwarding branch. 

The branch logic is illustrated as below:


| cycle | current-instruction-address | next-instruction-address |
| ----- | --------------------------- | ------------------------ |
| 1     | IMem[8]                     | IMem[12]                 |
| 2     | IMem[12]                    | IMem[10]                 |
| 3     | IMem[10]                    | IMem[14]                 |

Participating components including: (following the relative data propagation order)

- Program Counter
- Instruction Memory
- Control Unit
- Sign Extension Unit
- Branch Unit



#### D-format Instruction Test

In this part, we test both `STUR` and `LDUR` instructions.

The first 3 instructions are `STUR`, they load data from *Register File* to specific locations. 

The following `LDUR` instructions would load the content in those locations back to *Register File*.

Participating components including: (following the relative data propagation order)

- Program Counter
- Instruction Memory
- Control Unit
- RegtoLoc Multiplexer (for `STUR`)
- Register File (with write function for `LDUR`)
- Branch Unit (for normal pc increment only)
- Sign Extension Unit
- ALUSrc Multiplexer
- ALU (performing `ADD`)
- Data Memory (with write function for `STUR`)
- MemtoReg Multiplexer
