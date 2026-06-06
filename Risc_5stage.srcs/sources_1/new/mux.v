`timescale 1ns / 1ps

module mux (
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] y
);

    assign y = (sel == 1'b0) ? a : b;

endmodule