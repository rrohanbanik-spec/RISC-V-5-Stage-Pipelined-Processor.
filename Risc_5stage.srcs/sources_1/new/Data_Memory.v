`timescale 1ns / 1ps

module Data_Memory(
    input clk, 
    input reset,
    input mem_access_en, 
    input mem_wrt_en,
    input [31:0] mem_addr, 
    input [31:0] mem_wrt_data,
    output [31:0] mem_rd_data
);

    reg [31:0] D_Memory [63:0];
    integer k;

    initial begin
        for(k=0; k<64; k=k+1) D_Memory[k] = 32'b0;
        D_Memory[4]  = 32'd100;
        D_Memory[6]  = 32'd200;
    end

    always @(posedge clk) begin
        if(mem_wrt_en)
            D_Memory[mem_addr >> 2] <= mem_wrt_data;
    end

    assign mem_rd_data = (mem_access_en && !mem_wrt_en) ? D_Memory[mem_addr >> 2] : 32'b0;

endmodule