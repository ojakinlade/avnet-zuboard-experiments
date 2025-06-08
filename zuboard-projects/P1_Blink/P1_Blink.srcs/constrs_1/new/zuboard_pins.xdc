# Red
set_property PACKAGE_PIN A7 [get_ports {rgb_led0_0[2]}] 
# Green
set_property PACKAGE_PIN B6 [get_ports {rgb_led0_0[1]}] 
# Blue
set_property PACKAGE_PIN B5 [get_ports {rgb_led0_0[0]}] 

# Red
set_property PACKAGE_PIN B4 [get_ports {rgb_led1_0[2]}] 
# Green
set_property PACKAGE_PIN A2 [get_ports {rgb_led1_0[1]}] 
# Blue
set_property PACKAGE_PIN F4 [get_ports {rgb_led1_0[0]}] 

set_property IOSTANDARD LVCMOS18 [get_ports {rgb_led0_0[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgb_led0_0[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgb_led0_0[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {rgb_led1_0[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgb_led1_0[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgb_led1_0[0]}]