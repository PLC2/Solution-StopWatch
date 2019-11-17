set_property PACKAGE_PIN  M18      [ get_ports Button[0] ]
set_property IOSTANDARD   LVCMOS33 [ get_ports -regexp {Button\[\d+\]} ]  ; # set I/O standard
set_false_path               -from [ get_ports -regexp {Button\[\d+\]} ]  ; # Ignore timings on async I/O pins
