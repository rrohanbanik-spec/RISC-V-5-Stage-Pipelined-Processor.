`timescale 1ns / 1ps

module Reg_File(
    input clk,
    input reset,
    input rg_rd_en1,      
    input rg_rd_en2,      
    input rg_wrt_en,      
    input [4:0] rg_rd_addr1, rg_rd_addr2, rg_wrt_addr,
    input [31:0] rg_wrt_data,
    output [31:0] rg_rd_data1, rg_rd_data2
);

    reg [31:0] registers [31:0];

    initial begin
        registers[0]  = 0;
        registers[1]  = 4;
        registers[2]  = 2;
        registers[3]  = 100;
        registers[4]  = 4;
        registers[5]  = 50;
        registers[6]  = 44;
        registers[7]  = 4;
        registers[8]  = 2;
        registers[9]  = 1;
        registers[10] = 23;
        registers[11] = 4;
        registers[12] = 90;
        registers[13] = 10;
        registers[14] = 20;
        registers[15] = 30;
        registers[16] = 40;
        registers[17] = 50;
        registers[18] = 60;
        registers[19] = 70;
        registers[20] = 80;
        registers[21] = 7;
        registers[22] = 0;
        registers[23] = 0;
        registers[24] = 0;
        registers[25] = 90;
        registers[26] = 4;
        registers[27] = 0;
        registers[28] = 0;
        registers[29] = 34;
        registers[30] = 5;
        registers[31] = 10;
    end

    always @(posedge clk) begin
        if(rg_wrt_en && (rg_wrt_addr != 5'b0)) // Prevent writing to x0
            registers[rg_wrt_addr] <= rg_wrt_data;
    end

    assign rg_rd_data1 = registers[rg_rd_addr1];
    assign rg_rd_data2 = registers[rg_rd_addr2];

endmodule