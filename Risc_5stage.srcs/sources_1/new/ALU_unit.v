`timescale 1ns / 1ps

module ALU_unit(a, b, alu_control, result, zero);
input [31:0] a, b;
input [3:0] alu_control;
output reg zero;
output reg [31:0] result;

always @(*) begin
    case(alu_control)
        4'b0000: begin zero <= 0; result <= a & b; end
        4'b0001: begin zero <= 0; result <= a | b; end
        4'b0010: begin zero <= 0; result <= a + b; end
        4'b0110: begin result <= a - b; zero <= (a == b) ? 1 : 0; end
        default: begin zero <= 0; result <= 32'b0; end
    endcase
end
endmodule