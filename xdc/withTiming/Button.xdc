set_property PACKAGE_PIN  M18      [ get_ports {NexysA7_GPIO_Button[0]} ]
set_property IOSTANDARD   LVCMOS33 [ get_ports -regexp {NexysA7_GPIO_Button\[\d+\]} ]

set_input_delay -clock [get_clocks SystemClock] -min 0.200 [get_ports -regexp {NexysA7_GPIO_Button\[\d+\]} ]
set_input_delay -clock [get_clocks SystemClock] -max 0.300 [get_ports -regexp {NexysA7_GPIO_Button\[\d+\]} ]
