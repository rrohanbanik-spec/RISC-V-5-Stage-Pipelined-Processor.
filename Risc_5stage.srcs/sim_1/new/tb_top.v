`timescale 1ns / 1ps

module tb_top();

    // Inputs to the top module
    reg clk;
    reg reset;

    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation (50 MHz clock -> 20ns period)
    always begin
        #10 clk = ~clk;
    end

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        
        // Hold reset active for 2 clock cycles to clear the pipeline registers cleanly
        #25;
        reset = 0;
        
        // Let the simulation run for a sequence of cycles to observe execution progression
        #500;
        
        $finish;
    end

endmodule