#line 2 "lop-config.dts"
/dts-v1/;
/ {
        compatible = "system-device-tree-v1,lop";
        lops {
                lop_0 {
                        compatible = "system-device-tree-v1,lop,load";
                        load = "assists/baremetal_validate_comp_xlnx.py";
                };

                lop_1 {
                    compatible = "system-device-tree-v1,lop,assist-v1";
                    node = "/";
                    outdir = "/home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/ps_pl_rgb_platform/zynqmp_fsbl/zynqmp_fsbl_bsp";
                    id = "module,baremetal_validate_comp_xlnx";
                    options = "psu_cortexa53_0 /home/joseph/Vitis/2024.2/data/embeddedsw/lib/sw_services/xilffs_v5_3/src /home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/_ide/.wsdata/.repo.yaml";
                };

                lop_2 {
                    compatible = "system-device-tree-v1,lop,assist-v1";
                    node = "/";
                    outdir = "/home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/ps_pl_rgb_platform/zynqmp_fsbl/zynqmp_fsbl_bsp";
                    id = "module,baremetal_validate_comp_xlnx";
                    options = "psu_cortexa53_0 /home/joseph/Vitis/2024.2/data/embeddedsw/lib/sw_services/xilsecure_v5_4/src /home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/_ide/.wsdata/.repo.yaml";
                };

                lop_3 {
                    compatible = "system-device-tree-v1,lop,assist-v1";
                    node = "/";
                    outdir = "/home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/ps_pl_rgb_platform/zynqmp_fsbl/zynqmp_fsbl_bsp";
                    id = "module,baremetal_validate_comp_xlnx";
                    options = "psu_cortexa53_0 /home/joseph/Vitis/2024.2/data/embeddedsw/lib/sw_services/xilpm_v5_3/src /home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/_ide/.wsdata/.repo.yaml";
                };

        };
    };
