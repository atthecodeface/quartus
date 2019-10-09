# XCVU108 clocks (table 1-10)
# SYSCLK1 - 300MHz - G31/F31 - DIFF_SSTL12
# SYSCLK2 - 300MHz - G22/G21 - DIFF_SSTL12
# SYSCLK2 - 300MHz - G22/G21 - DIFF_SSTL12
# CLK_125MHz - 125MHz - BC9/BC8 - LVDS
# FPGA_EMCCLK - ? - AL20 - LVCMOS18
# SYSCTRL_CLK - ? - AL20 - LVCMOS18

set pin_desc {}
lappend pin_desc {vcu108_inputs__switches 4 0 {{PACKAGE_PIN {C38 C37 L19 BC40}}    {IOSTANDARD LVCMOS12} } }
lappend pin_desc {vcu108_inputs__buttons  5 0 {{PACKAGE_PIN {E34 D9 M22 A10 AW27}} {IOSTANDARD LVCMOS12} } }
lappend pin_desc {vcu108_leds__leds 8 0 {{PACKAGE_PIN {AT32 AV34 AY30 BB32 BF32 AV36 AY35 BA37}} {IOSTANDARD LVCMOS12} }}

#a Uart
lappend pin_desc {uart_rxd 0 0 {{PACKAGE_PIN BC24} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {uart_txd 0 0 {{PACKAGE_PIN BE24} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {uart_cts 0 0 {{PACKAGE_PIN BF24} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {uart_rts 0 0 {{PACKAGE_PIN BD22} {IOSTANDARD LVCMOS18}}}

#a HDMI
lappend pin_desc    {hdmi__clk   0 0 {{PACKAGE_PIN AK33} {IOSTANDARD LVCMOS18}}}
lappend pin_desc    {hdmi__vsync 0 0 {{PACKAGE_PIN AK30} {IOSTANDARD LVCMOS18}}}
lappend pin_desc    {hdmi__hsync 0 0 {{PACKAGE_PIN AK29} {IOSTANDARD LVCMOS18}}}
lappend pin_desc    {hdmi__de    0 0 {{PACKAGE_PIN AH34} {IOSTANDARD LVCMOS18}}}
lappend pin_desc    {hdmi__d    16 0 {{PACKAGE_PIN {R36 R34 P34 V30 V33 V34 U35 T36  Y34 W34 V32 U33 AH33 AH30 AM33 AM31}} {IOSTANDARD LVCMOS18}}}
lappend pin_desc    {hdmi__spdif 0 0 {{PACKAGE_PIN AJ35} {IOSTANDARD LVCMOS18}}}

#a Clocks
lappend pin_desc {SYS_CLK1__p 0 0 {{PACKAGE_PIN G31} {IOSTANDARD DIFF_SSTL12}}}
lappend pin_desc     {SYS_CLK1__n 0 0 {{PACKAGE_PIN F31} {IOSTANDARD DIFF_SSTL12}}}
lappend pin_desc     {SYS_CLK2__p 0 0 {{PACKAGE_PIN G22} {IOSTANDARD DIFF_SSTL12}}}
lappend pin_desc     {SYS_CLK2__n 0 0 {{PACKAGE_PIN G21} {IOSTANDARD DIFF_SSTL12}}}
lappend pin_desc     {CLK_125MHZ__p 0 0 {{PACKAGE_PIN BC9} {IOSTANDARD LVDS}}}
lappend pin_desc     {CLK_125MHZ__n 0 0 {{PACKAGE_PIN BC8} {IOSTANDARD LVDS}}}
lappend pin_desc     {USER_SI570_CLOCK__p 0 0 {{PACKAGE_PIN AU23} {IOSTANDARD LVDS_25}}}
lappend pin_desc     {USER_SI570_CLOCK__n 0 0 {{PACKAGE_PIN AV23} {IOSTANDARD LVDS_25}}}
lappend pin_desc     {FPGA_EMCCLK 0 0 {{PACKAGE_PIN AL20} {IOSTANDARD LVCMOS18}}}

#a Invoke settings
pin_desc_set_properties $pin_desc

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

