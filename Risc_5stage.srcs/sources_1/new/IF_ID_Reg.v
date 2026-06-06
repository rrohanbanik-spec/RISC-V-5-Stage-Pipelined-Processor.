`timescale 1ns / 1ps

module IF_ID_Reg(
    input clk, 
    input reset, 
    input en,
    input [31:0] PC_plus4_in, 
    input [31:0] instruction_in, 
    output reg [31:0] PC_plus4_out, 
    output reg [31:0] instruction_out
);

always @(posedge clk or posedge reset)
begin
    if(reset) begin
        PC_plus4_out    <= 32'b0;
        instruction_out <= 32'b0;
    end
    else if(en) begin // Only capture new instructions if enable is high (no stall)
        PC_plus4_out    <= PC_plus4_in;
        instruction_out <= instruction_in;
    end
    // If en is 0, outputs hold their values, freezing the instruction in the Decode stage
end

endmodule