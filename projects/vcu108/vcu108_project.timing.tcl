# Ultrascale clocking (MMCM for internals, PLL for I/O)
# MMCM clock in of 10MHz to 800MHz
# MMCM VCO frequency between 600MHz and 1200MHz
# MMCM Output frequency 4.7MHz - 630MHz

# PLL clock in of 70MHz to 800MHz
# PLL VCO frequency between 600MHz and 1200MHz
# PLL Output frequency 4.7MHz - 630MHz (CLKOUTPHY is 0.5/1/2xVCO hence 300MHz-2400MHz)

proc clock_from_pll_if_required {project_clks clk_name pll_pin} {
    global clock_list
    if {[lsearch $project_clks $clk_name]>=0} {
        create_generated_clock -name $clk_name [get_pins $pll_pin]
        lappend clock_list $clk_name
    }
}

set clock_list {}
create_clock -name sys_clk -period 3.33 [get_ports SYS_CLK1__p]
lappend clock_list sys_clk
create_clock -name clk125mhz -period 8.00 [get_ports CLK_125MHZ__p]
lappend clock_list clk125mhz
create_clock -name sgmii_rxclk -period 1.6 [get_ports sgmii__rxc__p]
lappend clock_list sgmii_rxclk

clock_from_pll_if_required $project_clks clk_225     video_clk_gen/pll_i/CLKOUT0
clock_from_pll_if_required $project_clks clk_150     video_clk_gen/pll_i/CLKOUT1
clock_from_pll_if_required $project_clks clk_128_57  video_clk_gen/pll_i/CLKOUT2
clock_from_pll_if_required $project_clks clk_100     video_clk_gen/pll_i/CLKOUT3
clock_from_pll_if_required $project_clks clk_50      video_clk_gen/pll_i/CLKOUT4

clock_from_pll_if_required $project_clks tx_clk_625    sgmii_pll_tx/pll_i/CLKOUT0
clock_from_pll_if_required $project_clks tx_clk_312_5  sgmii_pll_tx/pll_i/CLKOUT1
clock_from_pll_if_required $project_clks tx_clk_125    sgmii_pll_tx/pll_i/CLKOUT2
clock_from_pll_if_required $project_clks tx_clk_25     sgmii_pll_tx/pll_i/CLKOUT3

clock_from_pll_if_required $project_clks rx_clk_625    sgmii_pll_rx/pll_i/CLKOUT0
clock_from_pll_if_required $project_clks rx_clk_312_5  sgmii_pll_rx/pll_i/CLKOUT1
clock_from_pll_if_required $project_clks rx_clk_125    sgmii_pll_rx/pll_i/CLKOUT2
clock_from_pll_if_required $project_clks rx_clk_25     sgmii_pll_rx/pll_i/CLKOUT3

foreach c $clock_list {
    foreach c2 $clock_list {
        if {$c != $c2} {
            set_false_path -from [get_clocks $c] -to [get_clocks $c2]
        }
    }
}
