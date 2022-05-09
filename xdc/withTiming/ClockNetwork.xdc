# Rename auto generated clocks from MMCM
create_generated_clock -name SystemClock [ get_pins clkNet/System_MMCM/CLKOUT0 ]
