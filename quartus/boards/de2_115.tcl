#b Setting up I/O
#   set_location_assignment PIN M20 -to address[10]
#   set_instance_assignment -name IO_STANDARD "2.5 V" -to address[10]
#   set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to address[10]
#   set_instance_assignment -name SLEW_RATE 2 -to e[0]
#
# Can one use:
# PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING (ON)
# PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION (ON)

pin_lvttl_signal Y2    clk_50
pin_lvttl_signal AG14  clk2_50
pin_lvttl_signal AG15  clk3_50

# Audio DAC/ADC
pin_lvttl_signal  D2 de2_aud__adcdat
pin_lvttl_signal  C2 de2_aud__adclrck
pin_lvttl_signal  F2 de2_aud__bclk
pin_lvttl_signal  D1 de2_aud__dacdat
pin_lvttl_signal  E3 de2_aud__daclrck
pin_lvttl_signal  E1 de2_aud__xck

# EEPROM I2C (32kbit, 0xa1 reading, 0xa0 writing)
pin_lvttl_signal D14 de2_eep_i2c__sclk
pin_lvttl_signal E14 de2_eep_i2c__sdat

# Audio and TV decoder I2C
pin_lvttl_signal B7 de2_i2c__sclk
pin_lvttl_signal A8 de2_i2c__sdat

pin_2_5v_signal {G18 F22 E17 L26 L25 J22 H22}     de2_hex0
pin_2_5v_signal {M24 Y22 W21 W22 W25 U23 U24 }    de2_hex1
pin_2_5v_signal {AA25 AA26 Y25 W26 Y26 W27 W28 }  de2_hex2
# 0/1 are 2.5
pin_2_5v_signal  {V21 U21}                 de1_hex3 0
# 2-6 are 3.3
pin_lvttl_signal {AB20 AA21 AD24 AF23 Y19} de1_hex3 2
pin_lvttl_signal {AB19 AA19 AG21 AH21 AE19 AF19 AE18} de2_hex4
pin_lvttl_signal {AD18 AC18 AB18 AH19 AG19 AF18 AH18} de2_hex5
pin_lvttl_signal {AA17 AB16 AA16 AB17 AB15 AA15 AC17} de2_hex6
pin_lvttl_signal {AD17 AE17 AG17 AH17 AF17 AG18 AA14} de2_hex7
pin_2_5v_signal {M23 M21 N21 R24} de2_keys
pin_2_5v_signal {E21 E22 E25 E24 H21 G20 G22 G21 F17} de2_ledg
pin_2_5v_signal {G19 E19 F19 F21 F18 E18 J19 H19 J17 G17 J15 H16 J16 H17 F15 G15 G16 H15} de2_ledr
pin_2_5v_signal {AB28 AC28 AC27 AD27 AB27 AC26 AD26 AB26 AC25 AB25 AC24 AB24 AB23 AA24 AA23 AA22 Y24 Y23} de2_switches

# IRDA receiver
pin_lvttl_signal Y15 de2_irda__rxd

pin_lvttl_signal {L3 L1 L2 K7 K1 K2 M3 M5}  de2_lcd__data
pin_lvttl_signal L6 de2_lcd__backlight
pin_lvttl_signal L4 de2_lcd__enable
pin_lvttl_signal M1 de2_lcd__read_write
pin_lvttl_signal M2 de2_lcd__rs
pin_lvttl_signal L5 de2_lcd__on

# PS2
pin_lvttl_signal H5 de2_ps2_dat
pin_lvttl_signal G6 de2_ps2_clk
pin_lvttl_signal F5 de2_ps2_b_dat
pin_lvttl_signal G5 de2_ps2_b_clk

# SMA
pin_lvttl_signal AH14  de2_sma_clkin
pin_lvttl_signal AE23  de2_sma_clkout

# SD
pin_lvttl_signal {AE14 AF13 AB14 AC14} de2_sd__data
pin_lvttl_signal AE13 de2_sd__clk
pin_lvttl_signal AD14 de2_sd__cmd
pin_lvttl_signal AF14 de2_sd__wp_n

# TV decoder
pin_lvttl_signal B14 de2_td__clk27
pin_lvttl_signal {E8 A7 D8 C7 D7 D6 E7 F7 } de2_td__data
pin_lvttl_signal G7 de2_td__reset_n
pin_lvttl_signal E5 de2_td__hs
pin_lvttl_signal E4 de2_td__vs

# UART
pin_lvttl_signal G9  de2_uart__txd
pin_lvttl_signal G12 de2_uart__rxd
pin_lvttl_signal G14 de2_uart__cts
pin_lvttl_signal J13 de2_uart__rts

# VGA (through ADV7123)
pin_lvttl_signal F11 de2_vga__blank_n
pin_lvttl_signal G13 de2_vga__hs
pin_lvttl_signal A12 de2_vga__clk
pin_lvttl_signal {B10 A10 C11 B11 A11 C12 D11 D12} de2_vga__b
pin_lvttl_signal {G8  G11  F8 H12  C8  B8 F10  C9} de2_vga__g
pin_lvttl_signal {E12 E11 D10 F12 G10 J12 H8  H10} de2_vga__r
pin_lvttl_signal C10 de2_vga__sync_n
pin_lvttl_signal C13 de2_vga__vs

# SDRAM (Two 32Mx16 devices)
pin_lvttl_signal AE5 de2_sdr__clk
pin_lvttl_signal AA6 de2_sdr__cke
pin_lvttl_signal T4  de2_sdr__cs_n
pin_lvttl_signal U6  de2_sdr__ras_n
pin_lvttl_signal V7  de2_sdr__cas_n
pin_lvttl_signal V6  de2_sdr__we_n
pin_lvttl_signal {R6 V8 U8 P1 V5 W8 W7 AA7 Y5 Y6 R5 AA5 Y7} de2_sdr__addr
pin_lvttl_signal {U7 R4} de2_sdr__ba
pin_lvttl_signal {W3 W2 V4 W1 V3 V2 V1 U3 Y3 Y4 AB1 AA3 AB2 AC1 AB3 AC2 M8 L8 P2 N3 N4 M4 M7 L7 U5 R7 R1 R2 R3 T3 U4 U1} de2_sdr__dq
pin_lvttl_signal {U2 W4 K8 N8} de2_sdr__dqm

# SRAM (max freq 125MHz)
pin_lvttl_signal AF8 de2_sram__ce_n
pin_lvttl_signal AD5 de2_sram__oe_n
pin_lvttl_signal AE8 de2_sram__we_n
pin_lvttl_signal AC4 de2_sram__ub_n
pin_lvttl_signal AD4 de2_sram__lb_n
pin_lvttl_signal {AB7 AD7 AE7 AC7 AB6 AE6 AB5 AC5 AF5 T7 AF2 AD3 AB4 AC3 AA4 AB11 AC11 AB9 AB8 T8 } de2_sram_addr
pin_lvttl_signal {AH3 AF4 AG4 AH4 AF6 AG6 AH6 AF7 AD1 AD2 AE2 AE1 AE3 AE4 AF3 AG3} de2_sram__dq

# Flash (8M x 8)
pin_lvttl_signal AE11 de2_flash__reset_n
pin_lvttl_signal AG7  de2_flash__ce_n
pin_lvttl_signal AG8  de2_flash__oe_n
pin_lvttl_signal AC10 de2_flash__we_n
pin_lvttl_signal AE12 de2_flash__wp_n
pin_lvttl_signal Y1   de2_flash__ready
pin_lvttl_signal {AG12 AH7 Y13 Y14 Y12 AA13 AA12 AB13 AB12 AB10 AE9 AF9 AA10 AD8 AC8 Y10 AA8 AH12 AC12 AD12 AE10 AD10 AD11} de2_flash_addr
pin_lvttl_signal {AH8 AF10 AG10 AH10 AF11 AG11 AH11 AF12} de2_flash__dq

# GPIO, GPIO connect to GPIO Default
pin_lvttl_signal {AB22 AC15 AB21 Y17 AC21 Y16 AD21 AE16 AD15 AE15 AC19 AF16 AD19 AF15 AF24 AE21 AF25 AC22 AE22 AF21 AF22 AD22 AG25 AD25 AH25 AE25 AG22 AE24 AH22 AF26 AE20 AG23 AF20 AH26 AH23 AG26} de2_gpio

# Ethernet 0
pin_2_5v_signal A17 de2_eth0__gtx_clk
pin_2_5v_signal A21 de2_eth0__int_n
pin_2_5v_signal C19 de2_eth0__reset_n
pin_2_5v_signal C20 de2_eth0__mdc
pin_2_5v_signal B21 de2_eth0__mdio
pin_2_5v_signal A15 de2_eth0__rx_clk
pin_2_5v_signal E15 de2_eth0__rx_col
pin_2_5v_signal D15 de2_eth0__rx_crs
pin_2_5v_signal {C16 D16 D17 C15} de2_eth0__rxd
pin_2_5v_signal C17 de2_eth0__rx_dv
pin_2_5v_signal D18 de2_eth0__rx_er
pin_2_5v_signal B17 de2_eth0__tx_clk
pin_2_5v_signal {C18 D19 A19 B19} de2_eth0__txd
pin_2_5v_signal A18 de2_eth0__tx_en
pin_2_5v_signal B18 de2_eth0__tx_er

pin_2_5v_signal C23 de2_eth1__gtx_clk
pin_2_5v_signal D24 de2_eth1__int_n
pin_2_5v_signal D22 de2_eth1__reset_n
pin_2_5v_signal D23 de2_eth1__mdc
pin_2_5v_signal D25 de2_eth1__mdio
pin_2_5v_signal B15 de2_eth1__rx_clk
pin_2_5v_signal B22 de2_eth1__rx_col
pin_2_5v_signal D20 de2_eth1__rx_crs
pin_2_5v_signal {B23 C21 A23 D21} de2_eth1__rx_data
pin_2_5v_signal A22 de2_eth1__rx_dv
pin_2_5v_signal C24 de2_eth1__rx_er
pin_2_5v_signal C22 de2_eth1__tx_clk
pin_2_5v_signal {C25 A26 B26 C26} de2_eth1__tx_data
pin_2_5v_signal B25 de2_eth1__tx_en
pin_2_5v_signal A25 de2_eth1__tx_er

#============================================================
# HSMC, HSMC connect to HSMC Default
#============================================================
# set_location_assignment PIN_J27 -to HSMC_CLKIN_P1
# set_location_assignment PIN_J28 -to HSMC_CLKIN_N1
# set_location_assignment PIN_Y27 -to HSMC_CLKIN_P2
# set_location_assignment PIN_Y28 -to HSMC_CLKIN_N2
# set_location_assignment PIN_D27 -to HSMC_TX_D_P[0]
# set_location_assignment PIN_D28 -to HSMC_TX_D_N[0]
# set_location_assignment PIN_F24 -to HSMC_RX_D_P[0]
# set_location_assignment PIN_F25 -to HSMC_RX_D_N[0]
# set_location_assignment PIN_E27 -to HSMC_TX_D_P[1]
# set_location_assignment PIN_C27 -to HSMC_RX_D_N[1]
# set_location_assignment PIN_E28 -to HSMC_TX_D_N[1]
# set_location_assignment PIN_D26 -to HSMC_RX_D_P[1]
# set_location_assignment PIN_F27 -to HSMC_TX_D_P[2]
# set_location_assignment PIN_F28 -to HSMC_TX_D_N[2]
# set_location_assignment PIN_F26 -to HSMC_RX_D_P[2]
# set_location_assignment PIN_E26 -to HSMC_RX_D_N[2]
# set_location_assignment PIN_G27 -to HSMC_TX_D_P[3]
# set_location_assignment PIN_G28 -to HSMC_TX_D_N[3]
# set_location_assignment PIN_G25 -to HSMC_RX_D_P[3]
# set_location_assignment PIN_G26 -to HSMC_RX_D_N[3]
# set_location_assignment PIN_K27 -to HSMC_TX_D_P[4]
# set_location_assignment PIN_K28 -to HSMC_TX_D_N[4]
# set_location_assignment PIN_H25 -to HSMC_RX_D_P[4]
# set_location_assignment PIN_H26 -to HSMC_RX_D_N[4]
# set_location_assignment PIN_M27 -to HSMC_TX_D_P[5]
# set_location_assignment PIN_M28 -to HSMC_TX_D_N[5]
# set_location_assignment PIN_K25 -to HSMC_RX_D_P[5]
# set_location_assignment PIN_K26 -to HSMC_RX_D_N[5]
# set_location_assignment PIN_K21 -to HSMC_TX_D_P[6]
# set_location_assignment PIN_K22 -to HSMC_TX_D_N[6]
# set_location_assignment PIN_L23 -to HSMC_RX_D_P[6]
# set_location_assignment PIN_L24 -to HSMC_RX_D_N[6]
# set_location_assignment PIN_H23 -to HSMC_TX_D_P[7]
# set_location_assignment PIN_H24 -to HSMC_TX_D_N[7]
# set_location_assignment PIN_M25 -to HSMC_RX_D_P[7]
# set_location_assignment PIN_M26 -to HSMC_RX_D_N[7]
# set_location_assignment PIN_J23 -to HSMC_TX_D_P[8]
# set_location_assignment PIN_J24 -to HSMC_TX_D_N[8]
# set_location_assignment PIN_R25 -to HSMC_RX_D_P[8]
# set_location_assignment PIN_R26 -to HSMC_RX_D_N[8]
# set_location_assignment PIN_P27 -to HSMC_TX_D_P[9]
# set_location_assignment PIN_P28 -to HSMC_TX_D_N[9]
# set_location_assignment PIN_T25 -to HSMC_RX_D_P[9]
# set_location_assignment PIN_T26 -to HSMC_RX_D_N[9]
# set_location_assignment PIN_J25 -to HSMC_TX_D_P[10]
# set_location_assignment PIN_J26 -to HSMC_TX_D_N[10]
# set_location_assignment PIN_U25 -to HSMC_RX_D_P[10]
# set_location_assignment PIN_U26 -to HSMC_RX_D_N[10]
# set_location_assignment PIN_L27 -to HSMC_TX_D_P[11]
# set_location_assignment PIN_L28 -to HSMC_TX_D_N[11]
# set_location_assignment PIN_L21 -to HSMC_RX_D_P[11]
# set_location_assignment PIN_L22 -to HSMC_RX_D_N[11]
# set_location_assignment PIN_V25 -to HSMC_TX_D_P[12]
# set_location_assignment PIN_V26 -to HSMC_TX_D_N[12]
# set_location_assignment PIN_N25 -to HSMC_RX_D_P[12]
# set_location_assignment PIN_N26 -to HSMC_RX_D_N[12]
# set_location_assignment PIN_R27 -to HSMC_TX_D_P[13]
# set_location_assignment PIN_R28 -to HSMC_TX_D_N[13]
# set_location_assignment PIN_P25 -to HSMC_RX_D_P[13]
# set_location_assignment PIN_P26 -to HSMC_RX_D_N[13]
# set_location_assignment PIN_U27 -to HSMC_TX_D_P[14]
# set_location_assignment PIN_U28 -to HSMC_TX_D_N[14]
# set_location_assignment PIN_P21 -to HSMC_RX_D_P[14]
# set_location_assignment PIN_R21 -to HSMC_RX_D_N[14]
# set_location_assignment PIN_V27 -to HSMC_TX_D_P[15]
# set_location_assignment PIN_V28 -to HSMC_TX_D_N[15]
# set_location_assignment PIN_R22 -to HSMC_RX_D_P[15]
# set_location_assignment PIN_R23 -to HSMC_RX_D_N[15]
# set_location_assignment PIN_U22 -to HSMC_TX_D_P[16]
# set_location_assignment PIN_V22 -to HSMC_TX_D_N[16]
# set_location_assignment PIN_T21 -to HSMC_RX_D_P[16]
# set_location_assignment PIN_T22 -to HSMC_RX_D_N[16]
# set_location_assignment PIN_V23 -to HSMC_CLKOUT_P2
# set_location_assignment PIN_V24 -to HSMC_CLKOUT_N2
# set_location_assignment PIN_G23 -to HSMC_CLKOUT_P1
# set_location_assignment PIN_G24 -to HSMC_CLKOUT_N1
# set_location_assignment PIN_AD28 -to HSMC_CLKOUT0
# set_location_assignment PIN_AE26 -to HSMC_D[0]
# set_location_assignment PIN_AE28 -to HSMC_D[1]
# set_location_assignment PIN_AE27 -to HSMC_D[2]
# set_location_assignment PIN_AF27 -to HSMC_D[3]
# set_location_assignment PIN_AH15 -to HSMC_CLKIN0
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_CLKIN_P1
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_CLKIN_N1
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_CLKIN_P2
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_CLKIN_N2
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[0]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[1]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[2]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[3]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[4]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[5]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[6]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[7]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[8]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[9]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[10]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[11]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[12]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[13]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[14]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[15]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_P[16]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[0]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[1]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[2]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[3]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[4]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[5]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[6]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[7]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[8]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[9]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[10]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[11]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[12]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[13]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[14]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[15]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_TX_D_N[16]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[0]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[1]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[2]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[3]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[4]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[5]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[6]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[7]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[8]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[9]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[10]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[11]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[12]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[13]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[14]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[15]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_P[16]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[0]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[1]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[2]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[3]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[4]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[5]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[6]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[7]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[8]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[9]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[10]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[11]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[12]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[13]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[14]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[15]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_RX_D_N[16]
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_CLKOUT_P1
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_CLKOUT_N1
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_CLKOUT_P2
# set_instance_assignment -name IO_STANDARD LVDS -to HSMC_CLKOUT_N2
# set_instance_assignment -name IO_STANDARD "2.5 V" -to HSMC_CLKOUT0
# set_instance_assignment -name IO_STANDARD "2.5 V" -to HSMC_D[0]
# set_instance_assignment -name IO_STANDARD "2.5 V" -to HSMC_D[1]
# set_instance_assignment -name IO_STANDARD "2.5 V" -to HSMC_D[2]
# set_instance_assignment -name IO_STANDARD "2.5 V" -to HSMC_D[3]
# set_instance_assignment -name IO_STANDARD "3.0-V LVTTL" -to HSMC_CLKIN0
# 
# #============================================================
# # HSMC, HSMC connect to HSMC Default
# #============================================================
# set_location_assignment PIN_J10 -to EXT_IO[0]
# set_location_assignment PIN_J14 -to EXT_IO[1]
# set_location_assignment PIN_H13 -to EXT_IO[2]
# set_location_assignment PIN_H14 -to EXT_IO[3]
# set_location_assignment PIN_F14 -to EXT_IO[4]
# set_location_assignment PIN_E10 -to EXT_IO[5]
# set_location_assignment PIN_D9 -to EXT_IO[6]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to EXT_IO[0]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to EXT_IO[1]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to EXT_IO[2]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to EXT_IO[3]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to EXT_IO[4]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to EXT_IO[5]
# set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to EXT_IO[6]
