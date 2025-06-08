// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
// Date        : Sun Jun  8 20:06:43 2025
// Host        : joseph-pc running 64-bit Ubuntu 24.04.2 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/ojakinlade/Documents/vivado_projects/ZUBoard/P1_Blink/P1_Blink.gen/sources_1/bd/blink_bd/ip/blink_bd_zynq_ultra_ps_e_0_0/blink_bd_zynq_ultra_ps_e_0_0_stub.v
// Design      : blink_bd_zynq_ultra_ps_e_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu1cg-sbva484-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "zynq_ultra_ps_e_v3_5_3_zynq_ultra_ps_e,Vivado 2024.1" *)
module blink_bd_zynq_ultra_ps_e_0_0(pl_clk0)
/* synthesis syn_force_seq_prim="pl_clk0" */;
  output pl_clk0 /* synthesis syn_isclock = 1 */;
endmodule
