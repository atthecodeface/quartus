# XCVU108 clocks (table 1-10)
# SYSCLK1 - 300MHz - G31/F31 - DIFF_SSTL12
# SYSCLK2 - 300MHz - G22/G21 - DIFF_SSTL12
# SYSCLK2 - 300MHz - G22/G21 - DIFF_SSTL12
# CLK_125MHz - 125MHz - BC9/BC8 - LVDS
# FPGA_EMCCLK - ? - AL20 - LVCMOS18
# SYSCTRL_CLK - ? - AL20 - LVCMOS18
# FPGA_CCLK - (up to 90MHz) - AF13 - LVCMOS18

set pin_desc {}
lappend pin_desc {vcu108_inputs__switches 4 0 {{PACKAGE_PIN {C38 C37 L19 BC40}}    {IOSTANDARD LVCMOS12} } }
lappend pin_desc {vcu108_inputs__buttons  5 0 {{PACKAGE_PIN {E34 D9 M22 A10 AW27}} {IOSTANDARD LVCMOS12} } }
lappend pin_desc {vcu108_outputs__leds 8 0 {{PACKAGE_PIN {AT32 AV34 AY30 BB32 BF32 AV36 AY35 BA37}} {IOSTANDARD LVCMOS12} }}

#a Uart
lappend pin_desc {uart_rxd  0 0 {{PACKAGE_PIN BC24} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {uart_rts  0 0 {{PACKAGE_PIN BD22} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {uart_txd 0 0 {{PACKAGE_PIN BE24} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {uart_cts 0 0 {{PACKAGE_PIN BF24} {IOSTANDARD LVCMOS18}}}

#a MDIO
lappend pin_desc {eth__reset_n  0 0 {{PACKAGE_PIN AU21} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {eth__int_n    0 0 {{PACKAGE_PIN AT21} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {eth__mdc      0 0 {{PACKAGE_PIN AV21} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {eth__mdio     0 0 {{PACKAGE_PIN AV24} {IOSTANDARD LVCMOS18}}}

#a I2C
lappend pin_desc {i2c_sysmon__scl  0 0 {{PACKAGE_PIN AP18} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {i2c_sysmon__sda  0 0 {{PACKAGE_PIN AP17} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {i2c_main__scl  0 0 {{PACKAGE_PIN AN21} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {i2c_main__sda  0 0 {{PACKAGE_PIN AP21} {IOSTANDARD LVCMOS18}}}
lappend pin_desc {i2c_reset_mux_n  0 0 {{PACKAGE_PIN AM23} {IOSTANDARD LVCMOS18}}}

#a BPI flash - clock is FPGA_CCLK (AF13) and WP is held high
#lappend pin_desc {bpi_flash__d  16 0 {{PACKAGE_PIN {AP11 AN11 AM11 AL11 AM19 AM18 AN20 AP20   AN19 AN18 AR18 AR17 AT20 AT19 AT17 AU17}} {IOSTANDARD LVCMOS18}}}
#lappend pin_desc {bpi_flash__a  26 0 {{PACKAGE_PIN {AR20 AR19 AV20 AW20 AU19 AU18 AV19 AV18   AW18 AY18 AY19 BA19 BA17 BB17 BB19 BC19   BB18 BC18 AY20 BA20 BD18 BD17 BC20 BD20   BE20 BF20}} {IOSTANDARD LVCMOS18}}}
#lappend pin_desc {bpi_flash__adv    0 0 {{PACKAGE_PIN AW17}} {IOSTANDARD LVCMOS18}}
#lappend pin_desc {bpi_flash__ce_b   0 0 {{PACKAGE_PIN AJ11}} {IOSTANDARD LVCMOS18}}
#lappend pin_desc {bpi_flash__oe_b   0 0 {{PACKAGE_PIN BF17}} {IOSTANDARD LVCMOS18}}
#lappend pin_desc {bpi_flash__fwe_b  0 0 {{PACKAGE_PIN BF16}} {IOSTANDARD LVCMOS18}}
#lappend pin_desc {bpi_flash__wait   0 0 {{PACKAGE_PIN BC23}} {IOSTANDARD LVCMOS18}}

#a SDIO - attached to Zynq
# lappend pin_desc {sdio__reset_n  0 0 {{PACKAGE_PIN K3} {IOSTANDARD LVCMOS18}}}
# lappend pin_desc {eth__int_n    0 0 {{PACKAGE_PIN L1} {IOSTANDARD LVCMOS18}}}
# lappend pin_desc {eth__mdc      0 0 {{PACKAGE_PIN L3} {IOSTANDARD LVCMOS18}}}
# lappend pin_desc {eth__mdio     0 0 {{PACKAGE_PIN M1} {IOSTANDARD LVCMOS18}}}

#a SGMII is RX (AR24, AT24) RXCLK (AT22 AU22) TX (AR23 AR22)
lappend pin_desc     {sgmii__rxc__p 0 0 {{PACKAGE_PIN AT22} {IOSTANDARD LVDS_25}}}
lappend pin_desc     {sgmii__rxc__n 0 0 {{PACKAGE_PIN AU22} {IOSTANDARD LVDS_25}}}
lappend pin_desc     {sgmii__rxd__p 0 0 {{PACKAGE_PIN AR24} {IOSTANDARD DIFF_HSTL_I_18}}}
lappend pin_desc     {sgmii__rxd__n 0 0 {{PACKAGE_PIN AT24} {IOSTANDARD DIFF_HSTL_I_18}}}
#lappend pin_desc     {sgmii__txd__p 0 0 {{PACKAGE_PIN AR23} {IOSTANDARD DIFF_HSTL_I_18} {SLEW SLOW}}}
#lappend pin_desc     {sgmii__txd__n 0 0 {{PACKAGE_PIN AR22} {IOSTANDARD DIFF_HSTL_I_18} {SLEW SLOW}}}
lappend pin_desc     {sgmii__txd__p 0 0 {{PACKAGE_PIN AR23} {IOSTANDARD LVDS}}}
lappend pin_desc     {sgmii__txd__n 0 0 {{PACKAGE_PIN AR22} {IOSTANDARD LVDS}}}

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
#lappend pin_desc     {FPGA_EMCCLK 0 0 {{PACKAGE_PIN AL20} {IOSTANDARD LVCMOS18}}}
#lappend pin_desc     {FPGA_CCLK 0 0 {{PACKAGE_PIN AF13} {IOSTANDARD LVCMOS18}}}

#a Invoke settings
pin_desc_set_properties $pin_desc

set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

