set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports led]
set_property PACKAGE_PIN H5 [get_ports led]

set_property DRIVE 12 [get_ports led]
set_property SLEW SLOW [get_ports led]

create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

set_property OFFCHIP_TERM NONE [get_ports led]
set_property PACKAGE_PIN D9 [get_ports button]
set_property IOSTANDARD LVCMOS33 [get_ports button]
