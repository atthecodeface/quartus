# Ultrascale clocking (MMCM for internals, PLL for I/O)
# MMCM clock in of 10MHz to 800MHz
# MMCM VCO frequency between 600MHz and 1200MHz
# MMCM Output frequency 4.7MHz - 630MHz

# PLL clock in of 70MHz to 800MHz
# PLL VCO frequency between 600MHz and 1200MHz
# PLL Output frequency 4.7MHz - 630MHz (CLKOUTPHY is 0.5/1/2xVCO hence 300MHz-2400MHz)

create_clock -name sys_clk -period 3.33 [get_ports SYS_CLK1__p]
# set_input_delay -clock sys_clk 1. [get_ports -regexp "switches.*"]
