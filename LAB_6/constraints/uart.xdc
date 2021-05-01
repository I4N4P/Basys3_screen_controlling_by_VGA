# Constraints for CLK
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -period 10.000 [get_ports clk]
set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.1


set_false_path -to [get_cells  -hier {*seq_reg*[0]} -filter {is_sequential}]
set_property PHASESHIFT_MODE WAVEFORM [get_cells -hierarchical *adv*]

# create_clock -name external_clock -period 10.00 [get_ports clk]
# create_clock -period 10.000 [get_ports clk]
# set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.1
# set_false_path -to [get_cells  -hier {*seq_reg*[0]} -filter {is_sequential}]
# set_property PHASESHIFT_MODE WAVEFORM [get_cells -hierarchical *adv*]

## Uart
set_property PACKAGE_PIN B18 [get_ports {rx}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {rx}]
set_property PACKAGE_PIN A18 [get_ports {tx}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {tx}]

## Switches
#set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
#set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
#set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
#set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
#set_property PACKAGE_PIN W15 [get_ports {sw[4]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
#set_property PACKAGE_PIN V15 [get_ports {sw[5]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
#set_property PACKAGE_PIN W14 [get_ports {sw[6]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
#set_property PACKAGE_PIN W13 [get_ports {sw[7]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
#set_property PACKAGE_PIN V2 [get_ports {sw[8]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
#set_property PACKAGE_PIN T3 [get_ports {sw[9]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
#set_property PACKAGE_PIN T2 [get_ports {sw[10]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
#set_property PACKAGE_PIN R3 [get_ports {sw[11]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
#set_property PACKAGE_PIN W2 [get_ports {sw[12]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
#set_property PACKAGE_PIN U1 [get_ports {sw[13]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
#set_property PACKAGE_PIN T1 [get_ports {sw[14]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]
#set_property PACKAGE_PIN R2 [get_ports {sw[15]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]
 

## LEDs
# set_property PACKAGE_PIN U16 [get_ports {led[0]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
# set_property PACKAGE_PIN E19 [get_ports {led[1]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
# set_property PACKAGE_PIN U19 [get_ports {led[2]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
# set_property PACKAGE_PIN V19 [get_ports {led[3]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
# set_property PACKAGE_PIN W18 [get_ports {led[4]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
# set_property PACKAGE_PIN U15 [get_ports {led[5]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
# set_property PACKAGE_PIN U14 [get_ports {led[6]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
# set_property PACKAGE_PIN V14 [get_ports {led[7]}]					
# 	set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]					

		
#7 segment display
set_property PACKAGE_PIN W7 [get_ports {seg[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property PACKAGE_PIN W6 [get_ports {seg[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U8 [get_ports {seg[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V5 [get_ports {seg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U7 [get_ports {seg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
#dp
set_property PACKAGE_PIN V7 [get_ports {seg[7]}]							
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[7]}]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]


##Buttons
set_property PACKAGE_PIN U18 [get_ports {reset}]
        set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
set_property PACKAGE_PIN T18 [get_ports btn]						
	set_property IOSTANDARD LVCMOS33 [get_ports btn]

set_property PACKAGE_PIN V17 [get_ports loopback_enable]						
	set_property IOSTANDARD LVCMOS33 [get_ports loopback_enable]

##Monitors
set_property PACKAGE_PIN J1 [get_ports rx_monitor]						
	set_property IOSTANDARD LVCMOS33 [get_ports rx_monitor]
set_property PACKAGE_PIN L2 [get_ports tx_monitor]						
	set_property IOSTANDARD LVCMOS33 [get_ports tx_monitor]
# #set_property PACKAGE_PIN U17 [get_ports btnD]						
	#set_property IOSTANDARD LVCMOS33 [get_ports btnD]

# Constraints for CFGBVS
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
