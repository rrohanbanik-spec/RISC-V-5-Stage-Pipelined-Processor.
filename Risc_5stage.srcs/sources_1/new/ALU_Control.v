`timescale 1ns / 1ps

module ALU_Control(ALUOp, funct7, funct3, ALU_Selection);
input funct7;
input [1:0] ALUOp;
input [2:0] funct3;
output reg [3:0] ALU_Selection;

always @(*) begin
    case({ALUOp, funct7, funct3})
        6'b00_0_000: ALU_Selection <= 4'b0010;
        6'b01_0_000: ALU_Selection <= 4'b0110;
        6'b10_0_000: ALU_Selection <= 4'b0010;
        6'b10_1_000: ALU_Selection <= 4'b0110;
        6'b10_0_111: ALU_Selection <= 4'b0000;
        6'b10_0_110: ALU_Selection <= 4'b0001;
        default:     ALU_Selection <= 4'b0000;
    endcase
end
endmodule