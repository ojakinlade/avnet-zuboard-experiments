`timescale 1ns / 1ps

module blink #(
    parameter CLK_FREQ_HZ = 100_000_000 // 1 second period (clk freq: 100MHz)
)(
    input wire clk,
    output reg [2:0] rgb_led0,
    output reg [2:0] rgb_led1
);
    
    localparam integer MAX_STATE = 8;
    
    reg [26:0] counter = 0;
    reg [2:0] state = 0;
    
    always @(posedge clk) begin
        if (counter < CLK_FREQ_HZ - 1) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
            state <= (state + 1) % MAX_STATE;
        end
    end
    
    always @(posedge clk) begin
        case (state)
            3'd0: begin rgb_led0 <= 3'b000; rgb_led1 <= 3'b000; end
            3'd1: begin rgb_led0 <= 3'b001; rgb_led1 <= 3'b001; end
            3'd2: begin rgb_led0 <= 3'b010; rgb_led1 <= 3'b010; end
            3'd3: begin rgb_led0 <= 3'b011; rgb_led1 <= 3'b011; end
            3'd4: begin rgb_led0 <= 3'b100; rgb_led1 <= 3'b100; end
            3'd5: begin rgb_led0 <= 3'b101; rgb_led1 <= 3'b101; end
            3'd6: begin rgb_led0 <= 3'b110; rgb_led1 <= 3'b110; end
            3'd7: begin rgb_led0 <= 3'b111; rgb_led1 <= 3'b111; end
            default: begin rgb_led0 <= 3'b000; rgb_led1 <= 3'b000; end
        endcase
    end
endmodule
