-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.1 (lin64) Build 5076996 Wed May 22 18:36:09 MDT 2024
-- Date        : Sun Jun  8 20:06:43 2025
-- Host        : joseph-pc running 64-bit Ubuntu 24.04.2 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/ojakinlade/Documents/vivado_projects/ZUBoard/P1_Blink/P1_Blink.gen/sources_1/bd/blink_bd/ip/blink_bd_zynq_ultra_ps_e_0_0/blink_bd_zynq_ultra_ps_e_0_0_stub.vhdl
-- Design      : blink_bd_zynq_ultra_ps_e_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu1cg-sbva484-1-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blink_bd_zynq_ultra_ps_e_0_0 is
  Port ( 
    pl_clk0 : out STD_LOGIC
  );

end blink_bd_zynq_ultra_ps_e_0_0;

architecture stub of blink_bd_zynq_ultra_ps_e_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "pl_clk0";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "zynq_ultra_ps_e_v3_5_3_zynq_ultra_ps_e,Vivado 2024.1";
begin
end;
