	## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports r_Clock]							
	set_property IOSTANDARD LVCMOS33 [get_ports r_Clock]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports r_Clock]

##USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports rx_data]						
	set_property IOSTANDARD LVCMOS33 [get_ports rx_data]
set_property PACKAGE_PIN A18 [get_ports tx_data]						
	set_property IOSTANDARD LVCMOS33 [get_ports tx_data]

##Buttons
set_property PACKAGE_PIN U18 [get_ports r_reset]						
	set_property IOSTANDARD LVCMOS33 [get_ports r_reset]
	
# LEDs
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN W18 [get_ports {LED[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
set_property PACKAGE_PIN V13 [get_ports {LED2[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED2[0]}]
set_property PACKAGE_PIN V3 [get_ports {LED2[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED2[1]}]
set_property PACKAGE_PIN W3 [get_ports {LED2[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED2[2]}]
set_property PACKAGE_PIN U3 [get_ports {LED2[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED2[3]}]
set_property PACKAGE_PIN P3 [get_ports {LED2[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED2[4]}]
set_property PACKAGE_PIN N3 [get_ports {LED2[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED2[5]}]
set_property PACKAGE_PIN P1 [get_ports {LED2[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED2[6]}]
set_property PACKAGE_PIN L1 [get_ports {LED2[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED2[7]}]

