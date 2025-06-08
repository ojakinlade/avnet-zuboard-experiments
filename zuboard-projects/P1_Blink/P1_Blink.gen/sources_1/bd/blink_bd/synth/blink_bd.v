//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
//Date        : Sun Jun  8 20:05:02 2025
//Host        : joseph-pc running 64-bit Ubuntu 24.04.2 LTS
//Command     : generate_target blink_bd.bd
//Design      : blink_bd
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "blink_bd,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=blink_bd,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=1,da_zynq_ultra_ps_e_cnt=1,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "blink_bd.hwdef" *) 
module blink_bd
   (rgb_led0_0,
    rgb_led1_0);
  output [2:0]rgb_led0_0;
  output [2:0]rgb_led1_0;

  wire [2:0]blink_0_rgb_led0;
  wire [2:0]blink_0_rgb_led1;
  wire zynq_ultra_ps_e_0_pl_clk0;

  assign rgb_led0_0[2:0] = blink_0_rgb_led0;
  assign rgb_led1_0[2:0] = blink_0_rgb_led1;
  blink_bd_blink_0_0 blink_0
       (.clk(zynq_ultra_ps_e_0_pl_clk0),
        .rgb_led0(blink_0_rgb_led0),
        .rgb_led1(blink_0_rgb_led1));
  blink_bd_zynq_ultra_ps_e_0_0 zynq_ultra_ps_e_0
       (.pl_clk0(zynq_ultra_ps_e_0_pl_clk0));
endmodule
