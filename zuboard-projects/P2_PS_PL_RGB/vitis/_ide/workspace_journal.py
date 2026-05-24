# 2026-05-17T16:56:27.278286
import vitis

client = vitis.create_client()
client.set_workspace(path="vitis")

platform = client.create_platform_component(name = "ps_pl_rgb_platform",hw_design = "$COMPONENT_LOCATION/../../rgb_bd_wrapper.xsa",os = "standalone",cpu = "psu_cortexa53_0",domain_name = "standalone_psu_cortexa53_0")

platform = client.get_component(name="ps_pl_rgb_platform")
status = platform.build()

comp = client.create_app_component(name="rgb_control_app",platform = "$COMPONENT_LOCATION/../ps_pl_rgb_platform/export/ps_pl_rgb_platform/ps_pl_rgb_platform.xpfm",domain = "standalone_psu_cortexa53_0")

status = platform.build()

comp = client.get_component(name="rgb_control_app")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = comp.clean()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = comp.clean()

status = platform.build()

comp.build()

vitis.dispose()

