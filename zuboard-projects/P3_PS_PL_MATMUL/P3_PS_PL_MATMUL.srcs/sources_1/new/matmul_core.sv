`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2026 05:23:56 PM
// Design Name: 
// Module Name: matmul_core
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


module matmul_core #(
    parameter integer N = 2,
    parameter integer DATA_WIDTH = 16,
    parameter integer ACC_WIDTH = 32
)(
    input logic clk,
    input logic resetn,
    input logic start,
    input logic signed [(N*N*DATA_WIDTH)-1:0] a_flat,
    input logic signed [(N*N*DATA_WIDTH)-1:0] b_flat,
    output logic busy,
    output logic done,
    output logic signed [(N*N*ACC_WIDTH)-1:0] c_flat
);

    localparam integer INDEX_WIDTH = (N <= 1) ? 1 : $clog2(N);
    localparam integer PRODUCT_WIDTH = 2 * DATA_WIDTH;
    localparam [1:0] ST_IDLE = 2'd0;
    localparam [1:0] ST_RUN = 2'd1;
    localparam [1:0] ST_DONE = 2'd2;
    
    logic [1:0] state_reg = ST_IDLE;
    logic [INDEX_WIDTH-1:0] row_reg = {INDEX_WIDTH{1'b0}};
    logic [INDEX_WIDTH-1:0] col_reg = {INDEX_WIDTH{1'b0}};
    logic [INDEX_WIDTH-1:0] k_reg = {INDEX_WIDTH{1'b0}};
    logic signed [ACC_WIDTH-1:0] acc_reg = {ACC_WIDTH{1'b0}};
    
    logic signed [DATA_WIDTH-1:0] a_value;
    logic signed [DATA_WIDTH-1:0] b_value;
    logic signed [PRODUCT_WIDTH-1:0] product_value;
    logic signed [ACC_WIDTH-1:0] product_ext;
    logic signed [ACC_WIDTH-1:0] acc_next;
    
    assign a_value = get_a(row_reg, k_reg);
    assign b_value = get_b(k_reg, col_reg);
    assign product_value = a_value * b_value;
    assign acc_next = acc_reg + product_ext;
    
    generate 
        if (ACC_WIDTH > PRODUCT_WIDTH) begin : GEN_PRODUCT_EXTEND
            assign product_ext = {{(ACC_WIDTH-PRODUCT_WIDTH){product_value[PRODUCT_WIDTH-1]}}, product_value};
        end else if (ACC_WIDTH == PRODUCT_WIDTH) begin : GEN_PRODCUT_EXACT
            assign prodcut_ext = product_value;
        end else begin : GEN_PRODCUT_TRUNCATE
            assign product_ext = product_value[ACC_WIDTH-1:0];
        end
    endgenerate
    
    function automatic signed [DATA_WIDTH-1:0] get_a;
        input [INDEX_WIDTH-1:0] row;
        input [INDEX_WIDTH-1:0] col;
        integer base;
        begin
            base = ((row * N) + col) * DATA_WIDTH;
            get_a = a_flat[base +: DATA_WIDTH];
        end
    endfunction
    
    function automatic signed [DATA_WIDTH-1:0] get_b;
        input [INDEX_WIDTH-1:0] row;
        input [INDEX_WIDTH-1:0] col;
        integer base;
        begin
            base = ((row * N) + col) * DATA_WIDTH;
            get_b = b_flat[base +: DATA_WIDTH];
        end
    endfunction
    
    task automatic start_operation;
        begin
            busy <= 1'b1;
            done <= 1'b0;
            row_reg <= {INDEX_WIDTH{1'b0}};
            col_reg <= {INDEX_WIDTH{1'b0}};
            k_reg <= {INDEX_WIDTH{1'b0}};
            acc_reg <= {ACC_WIDTH{1'b0}};
            c_flat <= {(N*N*ACC_WIDTH){1'b0}};
            state_reg <= ST_RUN;
        end
    endtask
    
    always @(posedge clk) begin
        if (!resetn) begin
            state_reg <= ST_IDLE;
            busy <= 1'b0;
            done <= 1'b0;
            row_reg <= {INDEX_WIDTH{1'b0}};
            col_reg <= {INDEX_WIDTH{1'b0}};
            k_reg <= {INDEX_WIDTH{1'b0}};
            acc_reg <= {ACC_WIDTH{1'b0}};
            c_flat <= {(N*N*ACC_WIDTH){1'b0}};
        end else begin
            case (state_reg)
                ST_IDLE: begin
                    busy <= 1'b0;
                    done <= 1'b0;
                    if (start) begin
                        start_operation();
                    end
                end
                
                ST_RUN: begin
                    if (k_reg == N-1) begin
                        c_flat[(((row_reg * N) + col_reg) * ACC_WIDTH) +: ACC_WIDTH] <= acc_next;
                        acc_reg <= {ACC_WIDTH{1'b0}};
                        k_reg <= {INDEX_WIDTH{1'b0}};
                        
                        if ((row_reg == N-1) && (col_reg == N-1)) begin
                            busy <= 1'b0;
                            done <= 1'b1;
                            state_reg <= ST_DONE;
                        end else if (col_reg == N-1) begin
                            col_reg <= {INDEX_WIDTH{1'b0}};
                            row_reg <= row_reg + 1'b1;
                        end else begin
                            col_reg <= col_reg + 1'b1;
                        end
                    end else begin
                        acc_reg <= acc_next;
                        k_reg <= k_reg + 1'b1;
                    end
                end
                
                ST_DONE: begin
                    busy <= 1'b0;
                    done <= 1'b1;
                    if (start) begin
                        start_operation();
                    end
                end
                
                default: begin
                    state_reg <= ST_IDLE;
                    busy <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end
endmodule
