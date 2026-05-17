//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
//Date        : Sun May 17 15:52:34 2026
//Host        : Joseph-PowerLabs running 64-bit Ubuntu 22.04.5 LTS
//Command     : generate_target rgb_bd_wrapper.bd
//Design      : rgb_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module rgb_bd_wrapper
   (gpio_io_o_0);
  output [5:0]gpio_io_o_0;

  wire [5:0]gpio_io_o_0;

  rgb_bd rgb_bd_i
       (.gpio_io_o_0(gpio_io_o_0));
endmodule
