# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "/home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/ps_pl_rgb_platform/psu_cortexa53_0/standalone_psu_cortexa53_0/bsp/include/sleep.h"
  "/home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/ps_pl_rgb_platform/psu_cortexa53_0/standalone_psu_cortexa53_0/bsp/include/xiltimer.h"
  "/home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/ps_pl_rgb_platform/psu_cortexa53_0/standalone_psu_cortexa53_0/bsp/include/xtimer_config.h"
  "/home/joseph/Documents/vivado/avnet-zuboard-experiments/zuboard-projects/P2_PS_PL_RGB/vitis/ps_pl_rgb_platform/psu_cortexa53_0/standalone_psu_cortexa53_0/bsp/lib/libxiltimer.a"
  )
endif()
