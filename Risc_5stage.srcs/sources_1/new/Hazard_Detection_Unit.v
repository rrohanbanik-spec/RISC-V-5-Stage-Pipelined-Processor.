`timescale 1ns / 1ps

module Hazard_Detection_Unit (
    input [4:0] IF_ID_Rs1,
    input [4:0] IF_ID_Rs2,
    input [4:0] ID_EX_Rd,
    input ID_EX_MemRead,
    
    output reg PCWrite,
    output reg IF_ID_Write,
    output reg Control_Mux_Sel
);

    always @(*) begin
        PCWrite = 1'b1;
        IF_ID_Write = 1'b1;
        Control_Mux_Sel = 1'b0;

        if (ID_EX_MemRead && ((ID_EX_Rd == IF_ID_Rs1) || (ID_EX_Rd == IF_ID_Rs2))) begin
            PCWrite = 1'b0;
            IF_ID_Write = 1'b0;
            Control_Mux_Sel = 1'b1;
        end
    end

endmodule