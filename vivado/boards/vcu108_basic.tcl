# XCVU108 clocks (table 1-10)
# SYSCLK1 - 300MHz - G31/F31 - DIFF_SSTL12
# SYSCLK2 - 300MHz - G22/G21 - DIFF_SSTL12
# SYSCLK2 - 300MHz - G22/G21 - DIFF_SSTL12
# CLK_125MHz - 125MHz - BC9/BC8 - LVDS
# FPGA_EMCCLK - ? - AL20 - LVCMOS18
# SYSCTRL_CLK - ? - AL20 - LVCMOS18

set pin_desc {}
lappend pin_desc {
    switches 4 0 {
        {PACKAGE_PIN {C38 C37 L19 BC40}}
        {IOSTANDARD LVCMOS12} }
}
lappend pin_desc {
    leds 8 0 {
        {PACKAGE_PIN {AT32 AV34 AY30 BB32 BF32 AV36 AY35 BA37}}
        {IOSTANDARD LVCMOS12} }
}

lappend pin_desc {
    {SYS_CLK1__p 0 0 {{PACKAGE_PIN G31} {IOSTANDARD DIFF_SSTL12}}}
    {SYS_CLK1__n 0 0 {{PACKAGE_PIN F31} {IOSTANDARD DIFF_SSTL12}}}
}

pin_desc_set_properties $pin_desc

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

