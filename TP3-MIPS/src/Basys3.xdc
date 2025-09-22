set_property PACKAGE_PIN W5 [get_ports basys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports basys_clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports basys_clk]

set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports basys_reset]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# LED outputs
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[0]]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[1]]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[2]]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[3]]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[4]]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[5]]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[6]]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[7]]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[8]]
set_property -dict {PACKAGE_PIN V3  IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[9]]
set_property -dict {PACKAGE_PIN W3  IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[10]]
set_property -dict {PACKAGE_PIN U3  IOSTANDARD LVCMOS33} [get_ports o_mips_state_debug[11]]

set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports o_d_unit_state_debug[3]]
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports o_d_unit_state_debug[2]]
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports o_d_unit_state_debug[1]]
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports o_d_unit_state_debug[0]]

########################################################
# DEBUG TX inputs
#set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports i_uart_tx_data_debug[0]]
#set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports i_uart_tx_data_debug[1]]
#set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports i_uart_tx_data_debug[2]]
#set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports i_uart_tx_data_debug[3]]
#set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports i_uart_tx_data_debug[4]]
#set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports i_uart_tx_data_debug[5]]
#set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports i_uart_tx_data_debug[6]]
#set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports i_uart_tx_data_debug[7]]

#set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports o_uart_tx_done_debug]
#set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports i_btn_tx_debug]
########################################################


set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports i_uart_rx]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports o_uart_tx]


#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets uart_rx/shift_reg/C]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets uart_tx/shift_reg/Q]

set_property CONFIG_VOLTAGE 3.3 [current_design]