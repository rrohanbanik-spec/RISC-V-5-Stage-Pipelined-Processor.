`timescale 1ns / 1ps


module ID_EX_Reg (
    input clk, 
    input reset,
    
    input RegWrite_in, MemtoReg_in, MemWrite_in, MemRead_in, Branch_in, ALUSrc_in,
    input [1:0] ALUOp_in,
    
    input [31:0] PC_plus4_in, Rd1_in, Rd2_in, ImmExt_in,
    
    input [2:0] funct3_in,
    input funct7_in,
    input [4:0] Rs1_in, Rs2_in, Rd_in,

    output reg RegWrite_out, MemtoReg_out, MemWrite_out, MemRead_out, Branch_out, ALUSrc_out,
    output reg [1:0] ALUOp_out,
    
    output reg [31:0] PC_plus4_out, Rd1_out, Rd2_out, ImmExt_out,
    
    output reg [2:0] funct3_out,
    output reg funct7_out,
    output reg [4:0] Rs1_out, Rs2_out, Rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 1'b0;
            MemtoReg_out <= 1'b0;
            MemWrite_out <= 1'b0;
            MemRead_out  <= 1'b0;
            Branch_out   <= 1'b0;
            ALUSrc_out   <= 1'b0;
            ALUOp_out    <= 2'b00;
            
            PC_plus4_out <= 32'b0;
            Rd1_out      <= 32'b0;
            Rd2_out      <= 32'b0;
            ImmExt_out   <= 32'b0;
            
            funct3_out   <= 3'b0;
            funct7_out   <= 1'b0;
            Rs1_out      <= 5'b0;
            Rs2_out      <= 5'b0;
            Rd_out       <= 5'b0;
        end
        else begin
            RegWrite_out <= RegWrite_in;
            MemtoReg_out <= MemtoReg_in;
            MemWrite_out <= MemWrite_in;
            MemRead_out  <= MemRead_in;
            Branch_out   <= Branch_in;
            ALUSrc_out   <= ALUSrc_in;
            ALUOp_out    <= ALUOp_in;
            
            PC_plus4_out <= PC_plus4_in;
            Rd1_out      <= Rd1_in;
            Rd2_out      <= Rd2_in;
            ImmExt_out   <= ImmExt_in;
            
            funct3_out   <= funct3_in;
            funct7_out   <= funct7_in;
            Rs1_out      <= Rs1_in;
            Rs2_out      <= Rs2_in;
            Rd_out       <= Rd_in;
        end
    end

endmodule