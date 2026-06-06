`timescale 1ns / 1ps

module PCplus4(
    input [31:0] from_pc,
    output [31:0] plus4_out
);

    assign plus4_out = from_pc + 32'd4;

endmodule