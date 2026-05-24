`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2026 06:41:12 PM
// Design Name: 
// Module Name: tb_matmul_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_matmul_core(

    );
    
    localparam integer N = 3;
    localparam integer DATA_WIDTH = 8;
    localparam integer ACC_WIDTH = 32;
    localparam integer CLK_PERIOD_NS = 10;
    
    logic clk = 1'b0;
    logic resetn = 1'b0;
    logic start = 1'b0;
    logic signed [(N*N*DATA_WIDTH)-1:0] a_flat = '0;
    logic signed [(N*N*DATA_WIDTH)-1:0] b_flat = '0;
    logic busy;
    logic done;
    logic signed [(N*N*ACC_WIDTH)-1:0] c_flat;
    
    integer i;
    integer j;
    integer k;
    integer errors;
    integer expected;
    integer observed;
    
    always #(CLK_PERIOD_NS/2) clk = ~clk;
    
    matmul_core #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) dut (
        .clk(clk),
        .resetn(resetn),
        .start(start),
        .a_flat(a_flat),
        .b_flat(b_flat),
        .busy(busy),
        .done(done),
        .c_flat(c_flat)
    );
    
    task automatic set_a;
        input integer row;
        input integer col;
        input integer value;
        integer base;
        begin
            base = ((row * N) + col) * DATA_WIDTH;
            a_flat[base +: DATA_WIDTH] = value[DATA_WIDTH-1:0];
        end
    endtask
    
    task automatic set_b;
        input integer row;
        input integer col;
        input integer value;
        integer base;
        begin
            base = ((row * N) + col) * DATA_WIDTH;
            b_flat[base +: DATA_WIDTH] = value[DATA_WIDTH-1:0];
        end
    endtask
    
    function automatic signed [DATA_WIDTH-1:0] get_a;
        input integer row;
        input integer col;
        integer base;
        begin
            base = ((row * N) + col) * DATA_WIDTH;
            get_a = a_flat[base +: DATA_WIDTH];
        end
    endfunction
    
    function automatic signed [DATA_WIDTH-1:0] get_b;
        input integer row;
        input integer col;
        integer base;
        begin
            base = ((row * N) + col) * DATA_WIDTH;
            get_b = b_flat[base +: DATA_WIDTH];
        end
    endfunction
    
    function automatic signed [DATA_WIDTH-1:0] get_c;
        input integer row;
        input integer col;
        integer base;
        begin
            base = ((row * N) + col) * DATA_WIDTH;
            get_c = c_flat[base +: ACC_WIDTH];
        end
    endfunction
    
    initial begin
        $display("Starting matmul_core simulation...");
        
        set_a(0,0,1); set_a(0,1,2); set_a(0,2,3);
        set_a(1,0,4); set_a(1,1,5); set_a(1,2,6);
        set_a(2,0,-1); set_a(2,1,7); set_a(2,2,2);
        
        set_b(0,0,7); set_b(0,1,8); set_b(0,2,9);
        set_b(1,0,1); set_b(1,1,-2); set_b(1,2,3);
        set_b(2,0,4); set_b(2,1,5); set_b(2,2,6);
        
        repeat (4) @(posedge clk);
        resetn <= 1'b1;
        repeat (2) @(posedge clk);
        
        start <= 1'b1;
        @(posedge clk);
        start <= 1'b0;
        
        wait (done == 1'b1);
        @(posedge clk);
        
        errors = 0;
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                expected = 0;
                for (k = 0; k < N; k = k + 1) begin
                    expected = expected + (get_a(i,k) * get_b(k,j));
                end
                
                observed = get_c(i, j);
                if (observed !== expected) begin
                    $display("ERROR: c[%0d][%0d] expected %0d, got %0d", i, j, expected, observed);
                    errors = errors + 1;
                end
            end
        end
        
        if (errors == 0) begin
            $display("PASS: matmul_core result match expected output");
        end else begin 
            $display("FAIL: matmul_core had %0d mismatches", errors);
        end
        
        $finish;
    end
endmodule
