`timescale 1ns / 1ps
module Program_Counter(clk, reset, en, pc_next, pc_out);
input clk;
input reset;
input en; // Maps to PCWrite in top.v
input [31:0] pc_next; // Maps to IF_pc_next in top.v
output reg [31:0] pc_out; // Maps to IF_pc_current in top.v

always @(posedge clk or posedge reset)
begin
    if(reset)
        pc_out <= 32'b0;
    else if(en) // Only update if enable is high (no stall)
        pc_out <= pc_next;
    // If en is 0, it holds its current value (stalls)
end
endmodule