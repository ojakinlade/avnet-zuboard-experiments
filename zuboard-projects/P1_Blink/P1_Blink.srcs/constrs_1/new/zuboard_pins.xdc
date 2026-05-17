########## RGB LED0 #####################
# Red
set_property PACKAGE_PIN A7 [get_ports {gpio_io_o_0[0]}] 
# Green
set_property PACKAGE_PIN B6 [get_ports {gpio_io_o_0[1]}] 
# Blue
set_property PACKAGE_PIN B5 [get_ports {gpio_io_o_0[2]}] 

########## RGB LED1 #####################
# Red
set_property PACKAGE_PIN B4 [get_ports {gpio_io_o_0[3]}] 
# Green
set_property PACKAGE_PIN A2 [get_ports {gpio_io_o_0[4]}] 
# Blue
set_property PACKAGE_PIN F4 [get_ports {gpio_io_o_0[5]}] 

set_property IOSTANDARD LVCMOS18 [get_ports {gpio_io_o_0[*]}]

