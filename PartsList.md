# Parts List

## Wires

#### Inputs
- OP is the 4-bit opcode command bus  
- D is the 16-bit data input bus

#### Outputs
- Result is the 32-bit output from the Accumulator
- Error, Overflow, and divZero are the 1-bit output wires that output whether an operation had an error, was an overflow, or was divided by 0

#### Interfaces
- Ch0, Ch1, Ch2, Ch3, Ch4, Ch5, Ch6, Ch7, Ch8, Ch9, Ch10, Ch11, Ch12, Ch13, Ch14, Ch15 are all 16-bit busses into the multiplexer
 -FeedBack is the lower 16-bits leaving the Accumulator that feeds backs to the other components as inputs
- M is the 32-bit output of the multiplexer that feeds into the Accumulator input (D in each DFF).
- S is the 16-bit output of the decoder feeding into the select of the multiplexer (one-hot)
- addOut, subOut, multOut, divOut are the 32-bit output wires for each of the mathematic modules
- andOut, nandOut, orOut, norOut, xorOut, xnorOut are the 32-bit output wires for each of the logic gate modules
- overflowAdd, overflowSub, overflowMul, and overflowDiv, are the 1-bit wires that connect overflow ports of math modules to error module

## Components

#### Combinational Logic
Modues are explained in more detail in the ALU Description
- 1 16-bit adder
- 1 16-bit subtractor
- 1 16-bit multiplyer  
- 1 16-bit divider  
- 1 16-bit ANDer  
- 1 16-bit NANDer
- 1 16-bit ORer  
- 1 16-bit NORer
- 1 16-bit XORer
- 1 16-bit XNORer
- 1 16-bit MUX with 16 1-hot selectors  
- 1 4:16 bit decoder  

#### Sequential Logic
- 32-bit Accumulator made of 32 D flip-flops working synchronously on a clock. When the system starts, the value is unknown until a value is loaded.
