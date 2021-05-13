/*
Class: CS 4341
Professor: Dr. Becker
Group Members:
	Jonathan Schroeter - Jas170005
	Jonathan Hocevar - jch170830
	Cameron Cook - crc170002

Assignment: CS 4341 Digital Logic and Computer Design Semester Project
Filenames: testbench.v, Modules.v
Compiler: Icarus Verilog version 12.0 (devel) (s20150603-1110-g18392a46)

File Description: testbench.v is the test bench for the program. 
*/

`include "Modules.v"

module testbench();

    // Inputs
    reg [15:0] D;
	reg [3:0] OP;

    // Interfaces
    reg [15:0] feedback;
    wire [31:0] Ch0; //MUX
    wire [31:0] Ch1; //MUX
    wire [31:0] Ch2; //MUX
    wire [31:0] Ch3; //MUX
    wire [31:0] Ch4; //MUX
    wire [31:0] Ch5; //MUX
    wire [31:0] Ch6; //MUX
    wire [31:0] Ch7; //MUX
    wire [31:0] Ch8; //MUX
    wire [31:0] Ch9; //MUX
    wire [31:0] Ch10;//MUX
    wire [31:0] Ch11;//MUX
    wire [31:0] Ch12;//MUX
    wire [31:0] Ch13;//MUX
    wire [31:0] Ch14;//MUX
    wire [31:0] Ch15;//MUX
	
    wire signed [31:0] addOut;  //output of +
    wire signed [31:0] subOut;  //output of -
    wire signed [31:0] multOut; //output of *
    wire signed [31:0] divOut;  //output of /
	
    wire [31:0] andOut;     //output of AND
	wire [31:0] nandOut;    //output of NAND
    wire [31:0] orOut;      //output of OR
	wire [31:0] norOut;     //output of NOR
    wire [31:0] xorOut;     //output of XOR
	wire [31:0] xnorOut;    //output of XNOR
	
    wire [15:0] S; //output of the decoder
	
	//overflow varibales
	wire overflowAdd; //output of overflow of +
	wire overflowSub; //output of overflow of -
	wire overflowMul; //output of overflow of *
	wire overflowDiv; //output of divide by 0 of /
	

    // Outputs
	reg  signed [31:0] Result;  //result of the operations
    wire signed [31:0] M;       //output from the MUX
	
	//overflow outputs
	wire Error; //output of Error Handling for an error
	wire Overflow; //output of Error Handling for an overflow
	wire divZero; //output of Error Handling for divide by 0
    reg ErrorReg;
    reg OverflowReg;
    reg divZeroReg;


    reg  [31:0] next;
    wire [31:0] curr; //current value for No-Op
    reg clk; //clock

    // Create each of the modules that feed into the mux
    adder add(feedback, D, addOut,overflowAdd);
    subtractor sub(feedback, D, subOut,overflowSub);
    multiplier mult(feedback, D, multOut,overflowMul);
    divider div(feedback, D, divOut,overflowDiv);
    ANDER and1(feedback, D, andOut);
	NANDER nand1(feedback, D, nandOut);
    ORER or1(feedback, D, orOut);
	NORER nor1(feedback, D, norOut);
    XORER xor1(feedback, D, xorOut);
	XNORER xnor1(feedback, D, xnorOut);
	
	//overflow 
	OVERFLO overflow1(overflowAdd,overflowSub,overflowMul,overflowDiv,Error,Overflow,divZero);

    // Create moduels for selecting input based on op-code
	DECODER4X16 decode1(OP,S);
    MULTIPLEXER4X1 mux1(Ch0, Ch1, Ch2, Ch3, Ch4, Ch5, Ch6, Ch7, Ch8, Ch9, Ch10, Ch11, Ch12, Ch13, Ch14, Ch15, S, M);
	
    // Create Accumulator
    DFF ACC [3:1] (clk, next, curr);
	
    // Assign inputs to the multiplexer
    assign Ch0 = curr;          // NO-OP     0000    0
    assign Ch1 = D;             // LOAD      0001    1
    assign Ch2 = {32{1'b0}};    // RESET     0010    2
    assign Ch3 = {32{1'b1}};    // PRESET    0011    3
    assign Ch4 = addOut;        // ADD       0100    4
    assign Ch5 = subOut;        // SUBTRACT  0100    5
    assign Ch6 = multOut;       // MULTIPLY  0100    6
    assign Ch7 = divOut;        // DIVIDE    0100    7
    assign Ch8 = andOut;        // AND       0100    8
    assign Ch9 = nandOut;       // NAND      0100    9
    assign Ch10 = orOut;        // OR        0100    10
    assign Ch11 = norOut;       // NOR       0100    11
    assign Ch12 = xorOut;       // XOR       0100    12
    assign Ch13 = xnorOut;      // XNOR      0100    13
    assign Ch14 = 0;            // GROUND=0
    assign Ch15 = 0;            // GROUND=0

    always @(*)
    begin
        feedback = curr[15:0];
        Result=M;
        next=M;

        ErrorReg = Error;
        OverflowReg = Overflow;
        divZeroReg = divZero;
    end

    // CLOCK
    initial begin
        forever
        begin
            clk=0;
            #5;
            clk=1;
            #5;
        end
    end

    // Output Thread
    initial begin
        $display("The second D and Result columns show the decimal results for easier reading on mathematical operations, they are the same outputs as the first ones");
        $display("E - Error bit (Either Overflow or Divide-by-Zero is true");
        $display("O - Overflow is true on either additon, subtraction, or multiplication");
        $display("/ - Divide by zero error (second input is 0)");
        $display("|OP  |D (Data In)     |Result                          |E|O|/|  |Ch|    D|    Result|");
        forever begin
			$display("|%4b|%16b|%32b|%1d|%1d|%1d|  |%2d|%5d|%10d|", OP, D, Result, ErrorReg, OverflowReg, divZeroReg, OP, D, Result);
            #10;
        end
    end

    // Stimulus Thread
    initial begin
        #7;

        //-----------------------------
        D = 16'b0000000000000001;  // LOAD
        OP = 4'b0001;
        #10;

        //-----------------------------
        D = 16'b0000000000000001; // ADD 1
        OP = 4'b0100;
        #10;

        //-----------------------------
        D = 16'b0000000000000001; // ADD 1
        OP = 4'b0100;
        #10;

        //-----------------------------
        D = 16'b0000000000000001; // SUBTRACT 1
        OP = 4'b0101;
        #10;

        //-----------------------------
        D = 16'b0000000000000010; // MULTIPLY BY 2
        OP = 4'b0110;
        #10;
		
		//-----------------------------
        D = 16'b0000000000000010; // NO-OP
        OP = 4'b0000;
        #10;
		
		//-----------------------------
        D = 16'b0000000000000010; // RESET
        OP = 4'b0010;
        #10;
		
		//-----------------------------
        D = 16'b0000000000000000; //divide by 0
        OP = 4'b0111;
        #10;
		
		//-----------------------------
        D = 16'b0000000000000000; //Preset
        OP = 4'b0011;
        #10;
		
		//-----------------------------
        D = 16'b1111111111111111; //NAND
        OP = 4'b1001;
        #10;
		
		//-----------------------------
        D = 16'b1111111111111111; //NO-OP
        OP = 4'b0000;
        #10;
		
		//-----------------------------
        D = 16'b1011011011101000; //LOAD
        OP = 4'b0001;
        #10;
		
		//-----------------------------
        D = 16'b101100000001000; //XNOR
        OP = 4'b1101;
        #10;
		
		//-----------------------------
        D = 16'b000000000001000; //XOR
        OP = 4'b1100;
        #10;
		
		//-----------------------------
        D = 16'b101000100001100; //AND
        OP = 4'b1000;
        #10;
		
		//-----------------------------
        D = 16'b101000100001100; //RESET
        OP = 4'b0010;
        #10;
		
		//-----------------------------
        D = 16'b111010110101100; //NOR
        OP = 4'b1011;
        #10;
		
		//-----------------------------
        D = 16'b111010110101100; //RESET
        OP = 4'b1011;
        #10;
		
		//-----------------------------
        D = 16'b111010110111111; //MULTIPLY
        OP = 4'b0110;
        #10;
		
		//-----------------------------
        D = 16'b111010110111111; //NO-OP
        OP = 4'b0000;
        #10;

        //-----------------------------
        D = 16'b0000000011111111; //SUBTRACT
        OP = 4'b0101;
        #10;

        //-----------------------------
        D = 16'b0000000000000010; //MULTIPLY
        OP = 4'b0110;
        #10;

		$finish;
    end
endmodule