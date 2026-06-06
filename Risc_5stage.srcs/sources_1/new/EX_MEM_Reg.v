`timescale 1ns / 1ps


module EX_MEM_Reg (
    input clk,
    input reset,

    input RegWrite_in, MemtoReg_in, MemWrite_in, MemRead_in, Branch_in,
    input Zero_in,
    input [31:0] Reg_target_in, ALU_result_in, Rd2_in,
    input [4:0] Rd_in,

    output reg RegWrite_out, MemtoReg_out, MemWrite_out, MemRead_out, Branch_out,
    output reg Zero_out,
    output reg [31:0] Reg_target_out, ALU_result_out, Rd2_out,
    output reg [4:0] Rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out   <= 1'b0;
            MemtoReg_out   <= 1'b0;
            MemWrite_out   <= 1'b0;
            MemRead_out    <= 1'b0;
            Branch_out     <= 1'b0;
            Zero_out       <= 1'b0;
            Reg_target_out <= 32'b0;
            ALU_result_out <= 32'b0;
            Rd2_out        <= 32'b0;
            Rd_out         <= 5'b0;
        end
        else begin
            RegWrite_out   <= RegWrite_in;
            MemtoReg_out   <= MemtoReg_in;
            MemWrite_out   <= MemWrite_in;
            MemRead_out    <= MemRead_in;
            Branch_out     <= Branch_in;
            Zero_out       <= Zero_in;
            Reg_target_out <= Reg_target_in;
            ALU_result_out <= ALU_result_in;
            Rd2_out        <= Rd2_in;
            Rd_out         <= Rd_in;
        end
    end

endmodule
