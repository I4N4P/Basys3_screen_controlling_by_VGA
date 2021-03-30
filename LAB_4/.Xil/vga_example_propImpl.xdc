set_property SRC_FILE_INFO {cfile:C:/Users/dawid/Desktop/Studia/Basys3_Screen_controllingby_VGA/LAB_4/constraints/vga_example.xdc rfile:../constraints/vga_example.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:6 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.1
