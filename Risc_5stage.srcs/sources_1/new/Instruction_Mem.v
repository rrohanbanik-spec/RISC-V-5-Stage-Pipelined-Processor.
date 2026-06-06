`timescale 1ns / 1ps

module Instruction_Mem(
    input clk, 
    input reset, 
    input [31:0] addr, 
    output [31:0] instr
);

    reg [31:0] I_Mem [63:0];
    integer k;

    assign instr = I_Mem[addr >> 2];

    initial begin
        for(k=0; k<64; k=k+1) I_Mem[k] = 32'b0;
        I_Mem[0]  = 32'b00000000000000000000000000000000; // NOP
        // Replace indices 1 and 2 with this load-use sequence:

        I_Mem[1]  = 32'b000000000100_00011_010_01000_0000011; 
// lw x8, 4(x3) -> Loads from memory into register x8. (ID_EX_MemRead will be 1)

        I_Mem[2]  = 32'b0000000_01000_00001_000_01001_0110011; 
// add x9, x1, x8 -> Tries to use register x8 immediately! (Hazard!)

        I_Mem[3]  = 32'b0000000_11001_10000_000_01101_0110011; // Old instruction shifted down
        I_Mem[4]  = 32'b0000000_00101_00011_110_00100_0110011;
        I_Mem[5]  = 32'b000000000011_10101_000_10110_0010011;
        I_Mem[6]  = 32'b000000000001_01000_110_01001_0010011;
        I_Mem[7]  = 32'b000000001111_00101_010_01000_0000011;
        I_Mem[8]  = 32'b000000000011_00011_010_01001_0000011;
        I_Mem[9]  = 32'b0000000_01111_00101_010_01100_0100011;
        I_Mem[10] = 32'b0000000_01110_00110_010_01010_0100011;
        I_Mem[11] = 32'h00948663;
    end

endmodule