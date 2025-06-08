//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
//Date        : Sun Jun  8 20:05:03 2025
//Host        : joseph-pc running 64-bit Ubuntu 24.04.2 LTS
//Command     : generate_target blink_bd_wrapper.bd
//Design      : blink_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module blink_bd_wrapper
   (rgb_led0_0,
    rgb_led1_0);
  output [2:0]rgb_led0_0;
  output [2:0]rgb_led1_0;

  wire [2:0]rgb_led0_0;
  wire [2:0]rgb_led1_0;

  blink_bd blink_bd_i
       (.rgb_led0_0(rgb_led0_0),
        .rgb_led1_0(rgb_led1_0));
endmodule
