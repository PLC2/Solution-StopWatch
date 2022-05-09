set_property ASYNC_REG TRUE [ get_cells gen[*].Sync/FF1_METASTABILITY_FFS ]
set_property ASYNC_REG TRUE [ get_cells gen[*].Sync/FF2 ]
set_false_path -from [ all_clocks ] -to [ get_pins gen[*].Sync/FF1_METASTABILITY_FFS/D ]
