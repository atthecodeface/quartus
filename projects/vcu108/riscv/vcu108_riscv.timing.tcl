# Ultrascale clocking (MMCM for internals, PLL for I/O)
# MMCM clock in of 10MHz to 800MHz
# MMCM VCO frequency between 600MHz and 1200MHz
# MMCM Output frequency 4.7MHz - 630MHz

# PLL clock in of 70MHz to 800MHz
# PLL VCO frequency between 600MHz and 1200MHz
# PLL Output frequency 4.7MHz - 630MHz (CLKOUTPHY is 0.5/1/2xVCO hence 300MHz-2400MHz)

create_clock -name sys_clk -period 3.33 [get_ports SYS_CLK1__p]
create_generated_clock -name clk_225 [get_pins video_clk_gen/pll_i/CLKOUT0]
create_generated_clock -name clk_150 [get_pins video_clk_gen/pll_i/CLKOUT1]
create_generated_clock -name clk_100 [get_pins video_clk_gen/pll_i/CLKOUT2]
create_generated_clock -name clk_50  [get_pins video_clk_gen/pll_i/CLKOUT3]

set_false_path -from [get_clocks sys_clk] -to [get_clocks {clk_225 clk_150 clk_100 clk_50}]
set_false_path -from [get_clocks clk_225] -to [get_clocks {sys_clk clk_150 clk_100 clk_50}]
set_false_path -from [get_clocks clk_150] -to [get_clocks {sys_clk clk_225 clk_100 clk_50}]
set_false_path -from [get_clocks clk_100] -to [get_clocks {sys_clk clk_225 clk_150 clk_50}]
set_false_path -from [get_clocks clk_50]  -to [get_clocks {sys_clk clk_225 clk_150 clk_100}]
