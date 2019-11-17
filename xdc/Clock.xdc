set_property PACKAGE_PIN  E3       [ get_ports Clock ]
set_property IOSTANDARD   LVCMOS33 [ get_ports Clock ]                        ; # set I/O standard
create_clock -name PIN_SystemClock_100MHz -period 10.000 [ get_ports Clock ]  ; # specify a 100 MHz clock
