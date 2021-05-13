/*
Class: CS 4341
Professor: Dr. Becker
Group Members:
	Jonathan Schroeter - Jas170005
	Jonathan Hocevar - jch170830
	Cameron Cook - crc170002

Assignment: CS 4341 Digital Logic and Computer Design Semester Project
Filenames: testbench.v,Modules.v
Compiler: Icarus Verilog version 12.0 (devel) (s20150603-1110-g18392a46)

File Description: Module.v holds all the math, logic, and control modules.
*/


/*
##############################
#  #  #  MATH MODULES  #  #  #
##############################
*/

// Outputs both sum and difference of 2 inputs
module adder (A, B, Sum, overflow);
    input  signed [15:0] A;
    input  signed [15:0] B;
    output signed [31:0] Sum;
	output overflow;

    assign Sum = A + B; //assinging the sum
	assign overflow = (Sum > 32767 || Sum < -32768) ? 1 : 0; //assinging for overflow
endmodule

module subtractor (A, B, Difference, overflow);
    input  signed [15:0] A;
    input  signed [15:0] B;
    output signed [31:0] Difference;
	output overflow;

    assign Difference = A - B; //assigning the difference
	assign overflow = (Difference > 32767 || Difference < -32768) ? 1 : 0; // two's complement overflow
endmodule

// Outputs the product of 2 inputs
module multiplier (A, B, Product, overflow);
    input  signed [15:0] A;
    input  signed [15:0] B;
    output signed [31:0] Product;
	output overflow;

    assign Product = A * B; //assinging the product
	assign overflow = (Product > 32767 || Product < -32768) ? 1 : 0; //assinging for overflow
endmodule

// Outputs the quotient of 2 inputs
module divider (A, B, Quotient, overflow);
    input  signed [15:0] A;
    input  signed [15:0] B;
    output signed [31:0] Quotient;
	output overflow;

    assign Quotient = A / B; //assigning the quotient
	assign overflow = (B==0) ? 1 : 0; //assinging for divide by 0
endmodule


/*
#############################
#  #  # LOGIC MODULES #  #  #
#############################
*/

// Outputs logical AND of 2 inputs
module ANDER (
    input wire [15:0] A,
    input wire [15:0] B,
    output wire [31:0] C
    );

    assign C = A & B; //assigning the AND between A and B
endmodule

// Outputs logical OR of 2 inputs
module ORER (
    input wire [15:0] A,
    input wire [15:0] B,
    output wire [31:0] C
    );

    assign C = A | B; //assinging the OR between A and B
endmodule

// Outputs logical NAND of 2 inputs
module NANDER (
	input wire [15:0] A,
    input wire [15:0] B,
    output wire [31:0] C
	);
	
	assign C = ~(A & B); //assinging the NAND between A and B
endmodule

//Outputs logical NOR of 2 inputs
module NORER(
	input wire [15:0] A,
    input wire [15:0] B,
    output wire [31:0] C
	);
	
	assign C = ~(A | B); //assigning the NOR between A and B
endmodule

// Outputs logical XOR of 2 inputs
module XORER (
    input wire [15:0] A,
    input wire [15:0] B,
    output wire [31:0] C
    );

    assign C = A ^ B; //assigning the XOR between A and B
endmodule

//Outputs logical XNOR of 2 inputs
module XNORER(
	input wire [15:0] A,
    input wire [15:0] B,
    output wire [31:0] C
	);
	
	assign C = ~(A ^ B); //assinging the XNOR between A and B
endmodule

//module for overflow
module OVERFLO(
	input wire overflowAdd,
	input wire overflowSub,
	input wire overflowMul,
	input wire overflowDiv,
	output wire Error,
	output wire Overflow,
	output wire divZero
	);
	
    assign Error = overflowAdd | overflowSub | overflowMul | overflowDiv; //checking if there was an error
    assign Overflow = overflowSub | overflowAdd | overflowMul; //checking if there was an overflow
    assign divZero = overflowDiv; //checking if there was a divide by 0
endmodule

/*
###########################
#  #  CONTROL MODULES  #  #
###########################
*/

//Decoder
module DECODER4X16(
	input [3:0] select,
	output wire [15:0] out
	);
	assign out = 1'b1 << select;
endmodule

//Mux (4:1)
module MULTIPLEXER4X1(
    input wire [31:0] A, //0
    input wire [31:0] B, //1
    input wire [31:0] C, //2
    input wire [31:0] D, //3
    input wire [31:0] E, //4
    input wire [31:0] F, //5
    input wire [31:0] G, //6
    input wire [31:0] H, //7
    input wire [31:0] I, //8
    input wire [31:0] J, //9
    input wire [31:0] K, //10
    input wire [31:0] L, //11
    input wire [31:0] M, //12
    input wire [31:0] N, //13
    input wire [31:0] O, //14
    input wire [31:0] P, //15
    input wire [15:0] muxSelect,
    output reg [31:0] muxOut
    );

    always @(*) begin
        case(muxSelect)
            // Decoder Output (selecter)        // OPERATION
            16'b0000000000000001 : assign muxOut = A; // NO OP
            16'b0000000000000010 : assign muxOut = B; // LOAD
            16'b0000000000000100 : assign muxOut = C; // Reset
            16'b0000000000001000 : assign muxOut = D; // Preset
            16'b0000000000010000 : assign muxOut = E; // Add
            16'b0000000000100000 : assign muxOut = F; // Subtract
            16'b0000000001000000 : assign muxOut = G; // Multiply
            16'b0000000010000000 : assign muxOut = H; // Divide
            16'b0000000100000000 : assign muxOut = I; // AND
            16'b0000001000000000 : assign muxOut = J; // NAND
            16'b0000010000000000 : assign muxOut = K; // OR
            16'b0000100000000000 : assign muxOut = L; // NOR
            16'b0001000000000000 : assign muxOut = M; // XOR
            16'b0010000000000000 : assign muxOut = N; // XNOR
            default : assign muxOut = 32'b11111111111111110000000000000000; //Fallback (Unexpected output from Decoder/Invalid OpCode)
        endcase
    end
endmodule

// 4-bit D-Flip-Flop
module DFF(
    input wire clock,
    input wire [31:0] in,
    output reg [31:0] out
    );

    always @(posedge clock)
    out = in;
endmodule