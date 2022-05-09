set_property PACKAGE_PIN  C12      [ get_ports NexysA7_GPIO_Button_Reset_n ]
set_property IOSTANDARD   LVCMOS33 [ get_ports NexysA7_GPIO_Button_Reset_n ]

set_input_delay -clock [ get_clocks SystemClock ] -min 0.200 [ get_ports NexysA7_GPIO_Button_Reset_n ]
set_input_delay -clock [ get_clocks SystemClock ] -max 0.300 [ get_ports NexysA7_GPIO_Button_Reset_n ]
