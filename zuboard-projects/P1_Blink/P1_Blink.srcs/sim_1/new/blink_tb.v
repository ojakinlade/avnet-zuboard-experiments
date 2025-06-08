`timescale 1ns / 1ps

module blink_tb(

    );
    
    reg clk = 0;
    wire [2:0] rgb_led0;
    wire [2:0] rgb_led1;
    
    // Generate a clock: 10ns period => 100MHz
    always #5 clk = ~clk;
    
    // Instantiate the blink module with small CLK_PERIOD for faster simulation
    blink #(.CLK_FREQ_HZ(10)) uut (
        .clk(clk),
        .rgb_led0(rgb_led0),
        .rgb_led1(rgb_led1)
    );
    
    initial begin
        $display("Starting simulation...");
        $monitor("Time: %0t | LED0 = %b | LED1 = %b", $time, rgb_led0, rgb_led1);

        #2000; // Run for 200 ns
        $display("Simulation finished.");
        $finish;
    end
endmodule
