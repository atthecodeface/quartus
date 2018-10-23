# Altera DE2 board - not to be confused with the newer Terasic DE2-115 board
#
# This includes a Cyclone II EP2C35F672C6N
# This is a 2008-era FPGA with 33k LEs, 105 M4k RAM blocks (each 4kbit), 35 embedded 18x18 multipliers and 4 PLLS
#
# It uses a 9V DC power supply

pin_lvttl_signal N2    clk_50

# Audio DAC/ADC
pin_lvttl_signal  B5 de2_aud__adcdat
pin_lvttl_signal  C5 de2_aud__adclrck
pin_lvttl_signal  B4 de2_aud__bclk
pin_lvttl_signal  A4 de2_aud__dacdat
pin_lvttl_signal  C6 de2_aud__daclrck
pin_lvttl_signal  A5 de2_aud__xck

# EEPROM I2C (32kbit, 0xa1 reading, 0xa0 writing)
#pin_lvttl_signal xD14 de2_eep_i2c__sclk
#pin_lvttl_signal xE14 de2_eep_i2c__sdat

# Audio and TV decoder I2C
pin_lvttl_signal B6 de2_i2c__sclk
pin_lvttl_signal A6 de2_i2c__sdat

pin_lvttl_signal {AF10 AB12 AC12 AD11 AE11  V14  V13}  de2_hex0
pin_lvttl_signal { V20  V21  W21  Y22 AA24 AA23 AB24}  de2_hex1
pin_lvttl_signal {AB23  V22 AC25 AC26 AB26 AB25  Y24}  de2_hex2
pin_lvttl_signal { Y23 AA25 AA26  Y26  Y25  U22  W24}  de1_hex3
pin_lvttl_signal {  U9   U1   U2   T4   R7   R6   T3}  de2_hex4
pin_lvttl_signal {  T2   P6   P7   T9   R5   R4   R3}  de2_hex5
pin_lvttl_signal {  R2   P4   P3   M2   M3   M5   M4}  de2_hex6
pin_lvttl_signal {  L3   L2   L9   L6   L7   P9   N9}  de2_hex7
pin_lvttl_signal {AE23 AF23 AB21 AC22 AD22 AD23 AD21 AC21 AA14 Y13 AA13 AC14 AD15 AE15 AF13 AE13 AE12 AD12} de2_ledr
pin_lvttl_signal {AE22 AF22 W19 V18 U18 U17 AA20 Y18 Y12} de2_ledg
pin_lvttl_signal {G26 N23 P23 W26} de2_keys
pin_lvttl_signal {N25 N26 P25 AE14 AF14 AD13 AC13 C13 B13 A13 N1 P1 P2 T7 U3 U4 V1 V2} de2_switches

# IRDA transceiver
pin_lvttl_signal AE25 de2_irda__rxd
pin_lvttl_signal AE24 de2_irda__txd

# LCD
pin_lvttl_signal {J1 J2 H1 H2 J4 J3 H4 H3}  de2_lcd__data
pin_lvttl_signal K2 de2_lcd__backlight
pin_lvttl_signal K3 de2_lcd__enable
pin_lvttl_signal K4 de2_lcd__read_write
pin_lvttl_signal K1 de2_lcd__rs
pin_lvttl_signal L4 de2_lcd__on

# PS2
pin_lvttl_signal C24 de2_ps2_dat
pin_lvttl_signal D26 de2_ps2_clk
#pin_lvttl_signal xF5 de2_ps2_b_dat
#pin_lvttl_signal xG5 de2_ps2_b_clk

# SMA
pin_lvttl_signal P26  de2_sma_clkin
#pin_lvttl_signal xAE23  de2_sma_clkout

# SD
#pin_lvttl_signal x{AE14 AF13 AB14 AC14} de2_sd__data
#pin_lvttl_signal xAE13 de2_sd__clk
#pin_lvttl_signal xAD14 de2_sd__cmd
#pin_lvttl_signal xAF14 de2_sd__wp_n

# TV decoder
pin_lvttl_signal D13 de2_td__clk27
pin_lvttl_signal {J9 E8 H8 H10 G9 F9 D7 C7} de2_td__data
pin_lvttl_signal C4 de2_td__reset_n
pin_lvttl_signal D5 de2_td__hs
pin_lvttl_signal K9 de2_td__vs

# UART
pin_lvttl_signal B25  de2_uart__txd
pin_lvttl_signal C25  de2_uart__rxd
#pin_lvttl_signal xG14 de2_uart__cts
#pin_lvttl_signal xJ13 de2_uart__rts

# VGA (through ADV7123)
pin_lvttl_signal B8  de2_vga__clk
pin_lvttl_signal D6  de2_vga__blank_n
pin_lvttl_signal A7  de2_vga__hs
pin_lvttl_signal D8  de2_vga__vs
pin_lvttl_signal B7  de2_vga__sync_n
pin_lvttl_signal { J13  J14  F12  G12  J10  J11  C11  B11  C12  B12} de2_vga__b
pin_lvttl_signal {  B9   A9  C10  D10  B10  A10  G11  D11  E12  D12} de2_vga__g
pin_lvttl_signal {  C8  F10  G10   D9   C9   A8  H11  H12  F11  E10} de2_vga__r

# SDRAM (One 1Mx16 device)
pin_lvttl_signal AA7 de2_sdr__clk
pin_lvttl_signal AA6 de2_sdr__cke
pin_lvttl_signal AC3  de2_sdr__cs_n
pin_lvttl_signal AB4  de2_sdr__ras_n
pin_lvttl_signal AB3  de2_sdr__cas_n
pin_lvttl_signal AD3  de2_sdr__we_n
pin_lvttl_signal {T6 V4 V3 W2 W1 U6 U7 U5 W4 W3 Y1 V5} de2_sdr__addr
pin_lvttl_signal {AE2 AE3} de2_sdr__ba
pin_lvttl_signal {V6 AA2 AA1 Y3 Y4 R8 T8 V7 W6 AB2 AB1 AA4 AA3 AC2 AA5} de2_sdr__dq
pin_lvttl_signal {AD2 Y5} de2_sdr__dqm

# SRAM (max freq 125MHz)
pin_lvttl_signal AC11 de2_sram__ce_n
pin_lvttl_signal AD10 de2_sram__oe_n
pin_lvttl_signal AE10 de2_sram__we_n
pin_lvttl_signal AF9 de2_sram__ub_n
pin_lvttl_signal AE9 de2_sram__lb_n
pin_lvttl_signal {AE4 AF4 AC5 AC6 AD4 AD5 AE5 AF5 AD6 AD7 V10 V9 AC7 W8 W10 Y10 AB8 AC8} de2_sram_addr
pin_lvttl_signal {AD8 AE6 AF6 AA9 AA10 AB10 AA11 Y11 AE7 AF7 AE8 AF8 W11 W12 AC9 AC10} de2_sram__dq

# Flash (8M x 8)
pin_lvttl_signal AA18 de2_flash__reset_n
pin_lvttl_signal V17  de2_flash__ce_n
pin_lvttl_signal W17  de2_flash__oe_n
pin_lvttl_signal AA17 de2_flash__we_n
#pin_lvttl_signal  de2_flash__wp_n
#pin_lvttl_signal    de2_flash__ready
pin_lvttl_signal {AC18 AB18 AE19 AF19 AE18 AF18  Y16 AA16 AD17 AC17 AE17 AF17 W16 W15 AC16 AD16 AE16 AC15 AB15 AA15 Y15 Y14} de2_flash_addr
pin_lvttl_signal {AD19 AC19 AF20 AE20 AB20 AC20 AF21 AE21} de2_flash__dq

# GPIO, GPIO connect to GPIO Default
pin_lvttl_signal {D25 J22 E26 E25 F24 F23 J21 J20 F25 F26} de2_gpio_0  0
pin_lvttl_signal {N18 P18 G23 G24 K22 G25 H23 H24 J23 J24} de2_gpio_0 10
pin_lvttl_signal {H25 H26 H19 K18 K19 K21 K23 K24 L21 L20} de2_gpio_0 20
pin_lvttl_signal {J25 J26 L23 L24 L25 L19}                 de2_gpio_0 30
pin_lvttl_signal {K25 K26 M22 M23 M19 M20 N20 M21 M24 M25} de2_gpio_1  0
pin_lvttl_signal {N24 P24 R25 R24 R20 T22 T23 T24 T25 T18} de2_gpio_1 10
pin_lvttl_signal {T21 T20 U26 U25 U23 U24 R19 T19 U20 U21} de2_gpio_1 20
pin_lvttl_signal {V26 V25 V24 V23 W25 W23}                 de2_gpio_1 30

# Ethernet 
#pin_2_5v_signal A17 de2_eth0__gtx_clk
#pin_2_5v_signal A21 de2_eth0__int_n
#pin_2_5v_signal C19 de2_eth0__reset_n
#pin_2_5v_signal C20 de2_eth0__mdc
#pin_2_5v_signal B21 de2_eth0__mdio
#pin_2_5v_signal A15 de2_eth0__rx_clk
#pin_2_5v_signal E15 de2_eth0__rx_col
#pin_2_5v_signal D15 de2_eth0__rx_crs
#pin_2_5v_signal {C16 D16 D17 C15} de2_eth0__rxd
#pin_2_5v_signal C17 de2_eth0__rx_dv
#pin_2_5v_signal D18 de2_eth0__rx_er
#pin_2_5v_signal B17 de2_eth0__tx_clk
#pin_2_5v_signal {C18 D19 A19 B19} de2_eth0__txd
#pin_2_5v_signal A18 de2_eth0__tx_en
#pin_2_5v_signal B18 de2_eth0__tx_er

# USB OTG
