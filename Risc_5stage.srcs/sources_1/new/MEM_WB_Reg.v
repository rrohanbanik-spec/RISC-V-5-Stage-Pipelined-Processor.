`timescale 1ns / 1ps

module MEM_WB_Reg (
    input clk,
    input reset,

    input RegWrite_in, MemtoReg_in,
    input [31:0] ALU_result_in, Data_Memory_read_data_in,
    input [4:0] Rd_in,

    output reg RegWrite_out, MemtoReg_out,
    output reg [31:0] ALU_result_out, Data_Memory_read_data_out,
    output reg [4:0] Rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out             <= 1'b0;
            MemtoReg_out             <= 1'b0;
            ALU_result_out           <= 32'b0;
            Data_Memory_read_data_out <= 32'b0;
            Rd_out                   <= 5'b0;
        end
        else begin
            RegWrite_out             <= RegWrite_in;
            MemtoReg_out             <= MemtoReg_in;
            ALU_result_out           <= ALU_result_in;
            Data_Memory_read_data_out <= Data_Memory_read_data_in;
            Rd_out                   <= Rd_in;
        end
    end

endmodule
