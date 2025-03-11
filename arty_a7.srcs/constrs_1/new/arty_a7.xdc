set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports led]
set_property PACKAGE_PIN H5 [get_ports led]

set_property OFFCHIP_TERM NONE [get_ports led]
set_property DRIVE 12 [get_ports led]
set_property SLEW SLOW [get_ports led]

create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];
