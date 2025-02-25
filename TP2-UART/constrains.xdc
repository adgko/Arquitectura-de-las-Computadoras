
# Clock signal
set_property PACKAGE_PIN W5 [get_ports i_clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports i_clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports i_clk]
  

##Buttons enable
set_property PACKAGE_PIN U18 [get_ports i_reset]						
	set_property IOSTANDARD LVCMOS33 [get_ports i_reset]

#LEDS
set_property PACKAGE_PIN U16 [get_ports {o_tx_done}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {o_tx_done}]

#Pines RX-TX	
set_property PACKAGE_PIN B18 [get_ports i_rx_data]
set_property IOSTANDARD LVCMOS33 [get_ports i_rx_data]
set_property PACKAGE_PIN A18 [get_ports o_tx_data]
set_property IOSTANDARD LVCMOS33 [get_ports o_tx_data]	

set_property BITSTREAM.STARTUP.STARTUPCLK JTAGCLK [current_design]

set_property CFGBVS VCCO [current_design]
#where value1 is either VCCO or GND

set_property CONFIG_VOLTAGE 3.3 [current_design]