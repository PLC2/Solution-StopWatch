set_property PACKAGE_PIN  R17      [ get_ports Switch[4] ]
set_property PACKAGE_PIN  T18      [ get_ports Switch[5] ]
set_property PACKAGE_PIN  U18      [ get_ports Switch[6] ]
set_property PACKAGE_PIN  R13      [ get_ports Switch[7] ]
set_property PACKAGE_PIN  T8       [ get_ports Switch[8] ]
set_property PACKAGE_PIN  U8       [ get_ports Switch[9] ]
set_property PACKAGE_PIN  R16      [ get_ports Switch[10] ]
set_property PACKAGE_PIN  T13      [ get_ports Switch[11] ]
set_property PACKAGE_PIN  H6       [ get_ports Switch[12] ]
set_property PACKAGE_PIN  U12      [ get_ports Switch[13] ]
set_property PACKAGE_PIN  U11      [ get_ports Switch[14] ]
set_property PACKAGE_PIN  V10      [ get_ports Switch[15] ]
set_property IOSTANDARD   LVCMOS33 [ get_ports -regexp {Switch\[\d+\]} ]  ; # set I/O standard
set_false_path               -from [ get_ports -regexp {Switch\[\d+\]} ]  ; # Ignore timings on async I/O pins
