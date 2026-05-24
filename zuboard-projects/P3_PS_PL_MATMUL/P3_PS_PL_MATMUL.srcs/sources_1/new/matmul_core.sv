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
    logic signed [DATA_WIDTH-1:0] a_matrix [0:N-1][0:N-1];
    logic signed [DATA_WIDTH-1:0] b_matrix [0:N-1][0:N-1];
    logic signed [PRODUCT_WIDTH-1:0] product_value;
    logic signed [ACC_WIDTH-1:0] product_ext;
    logic signed [ACC_WIDTH-1:0] acc_next;
    
    genvar gen_row;
    genvar gen_col;
    
    generate
        for (gen_row = 0; gen_row < N; gen_row = gen_row + 1) begin : GEN_INPUT_ROWS
            for (gen_col = 0; gen_col < N; gen_col = gen_col + 1) begin : GEN_INPUT_COLS
                localparam integer FLAT_BASE = ((gen_row * N) + gen_col) * DATA_WIDTH;
                assign a_matrix[gen_row][gen_col] = a_flat[FLAT_BASE +: DATA_WIDTH];
                assign b_matrix[gen_row][gen_col] = b_flat[FLAT_BASE +: DATA_WIDTH];
            end
        end
    endgenerate

    assign a_value = a_matrix[row_reg][k_reg];
    assign b_value = b_matrix[k_reg][col_reg];
    assign product_value = $signed(a_value) * $signed(b_value);
    assign acc_next = acc_reg + product_ext;
    assign product_ext = resize_product(product_value);
    
    function automatic signed [ACC_WIDTH-1:0] resize_product;
        input signed [PRODUCT_WIDTH-1:0] product;
        logic signed [ACC_WIDTH-1:0] resized_product;
        begin
            resized_product = product;
            resize_product = resized_product;
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
