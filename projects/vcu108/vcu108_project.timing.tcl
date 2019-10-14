# Ultrascale clocking (MMCM for internals, PLL for I/O)
# MMCM clock in of 10MHz to 800MHz
# MMCM VCO frequency between 600MHz and 1200MHz
# MMCM Output frequency 4.7MHz - 630MHz

# PLL clock in of 70MHz to 800MHz
# PLL VCO frequency between 600MHz and 1200MHz
# PLL Output frequency 4.7MHz - 630MHz (CLKOUTPHY is 0.5/1/2xVCO hence 300MHz-2400MHz)

set clock_list {}
create_clock -name sys_clk -period 3.33 [get_ports SYS_CLK1__p]
lappend clock_list sys_clk
if {[lsearch $project_clks "clk_225"]>=0} {
    create_generated_clock -name clk_225 [get_pins video_clk_gen/pll_i/CLKOUT0]
    lappend clock_list clk_225
}
if {[lsearch $project_clks "clk_150"]>=0} {
    create_generated_clock -name clk_150 [get_pins video_clk_gen/pll_i/CLKOUT1]
    lappend clock_list clk_150
}
if {[lsearch $project_clks "clk_100"]>=0} {
    create_generated_clock -name clk_100 [get_pins video_clk_gen/pll_i/CLKOUT2]
    lappend clock_list clk_100
}
if {[lsearch $project_clks "clk_50"]>=0} {
    create_generated_clock -name clk_50 [get_pins video_clk_gen/pll_i/CLKOUT3]
    lappend clock_list clk_50
}

foreach c $clock_list {
    foreach c2 $clock_list {
        if {$c != $c2} {
            set_false_path -from [get_clocks $c] -to [get_clocks $c2]
        }
    }
}
