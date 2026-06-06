`timescale 1ns / 1ps

module Forwarding_Unit (
    input [4:0] ID_EX_Rs1,
    input [4:0] ID_EX_Rs2,
    input [4:0] EX_MEM_Rd,
    input [4:0] MEM_WB_Rd,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);

    always @(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // ==========================================
        // FORWARD A LOGIC (ALU Input 1)
        // ==========================================
        if (EX_MEM_RegWrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rs1)) begin
            ForwardA = 2'b10;
        end
        else if (MEM_WB_RegWrite && (MEM_WB_Rd != 5'b0) && (MEM_WB_Rd == ID_EX_Rs1)) begin
            ForwardA = 2'b01;
        end

        // ==========================================
        // FORWARD B LOGIC (ALU Input 2)
        // ==========================================
        if (EX_MEM_RegWrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rs2)) begin
            ForwardB = 2'b10;
        end
        else if (MEM_WB_RegWrite && (MEM_WB_Rd != 5'b0) && (MEM_WB_Rd == ID_EX_Rs2)) begin
            ForwardB = 2'b01;
        end
    end

endmodule