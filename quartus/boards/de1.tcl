#b Setting up I/O
#   set_location_assignment PIN M20 -to address[10]
#   set_instance_assignment -name IO_STANDARD "2.5 V" -to address[10]
#   set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to address[10]
#   set_instance_assignment -name SLEW_RATE 2 -to e[0]
#
# Can one use:
# PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING (ON)
# PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION (ON)

pin_lvttl_signal AF14 clk_50
pin_lvttl_signal AA16 clk2_50
pin_lvttl_signal Y26  clk3_50
pin_lvttl_signal K14  clk4_50

pin_lvttl_signal AJ4 de1_adc__cs_n
pin_lvttl_signal AK4 de1_adc__din
pin_lvttl_signal AK3 de1_adc__dout
pin_lvttl_signal AK2 de1_adc__sclk
pin_lvttl_signal  K7 de1_aud__adcdat
pin_lvttl_signal  K8 de1_aud__adclrck
pin_lvttl_signal  H7 de1_aud__bclk
pin_lvttl_signal  J7 de1_aud__dacdat
pin_lvttl_signal  H8 de1_aud__daclrck
pin_lvttl_signal  G7 de1_aud__xck
pin_lvttl_signal AH12 de1_ddr__clk
pin_lvttl_signal AK13 de1_ddr__cke
pin_lvttl_signal AG11 de1_ddr__cs_n
pin_lvttl_signal {AK14 AH14 AG15 AE14 AB15 AC14 AD14 AF15   AH15 AG13 AG12 AH13 AJ14} de1_ddr__addr
pin_lvttl_signal {AF13 AJ12} de1_ddr__ba
pin_lvttl_signal AE13 de1_ddr__ras_n
pin_lvttl_signal AF11 de1_ddr__cas_n
pin_lvttl_signal AA13 de1_ddr__we_n
pin_lvttl_signal { AK6  AJ7  AK7  AK8  AK9  AG10 AK11 AJ11   AH10 AJ10 AJ9  AH9  AH8  AH7  AJ6  AJ5 } de1_ddr__dq
pin_lvttl_signal AB13 de1_ddr__ldqm
pin_lvttl_signal AK12 de1_ddr__udqm
pin_lvttl_signal AA12 de1_fan_ctrl
pin_lvttl_signal J12 de1_fpga_i2c__sclk
pin_lvttl_signal K12 de1_fpga_i2c__sdat
pin_lvttl_signal {AE26 AE27 AE28 AG27 AF28 AG28 AH28} de1_hex0
pin_lvttl_signal {AJ29 AH29 AH30 AG30 AF29 AF30 AD27} de1_hex1
pin_lvttl_signal {AB23 AE29 AD29 AC28 AD30 AC29 AC30} de1_hex2
pin_lvttl_signal {AD26 AC27 AD25 AC25 AB28 AB25 AB22} de1_hex3
pin_lvttl_signal {AA24  Y23  Y24  W22  W24  V23  W25} de1_hex4
pin_lvttl_signal { V25 AA28  Y27 AB27 AB26 AA26 AA25} de1_hex5
pin_lvttl_signal H15 de1_td__clk27
pin_lvttl_signal {D2 B1 E2 B2 D1 E1 C2 B3} de1_td__data
pin_lvttl_signal A5 de1_td__hs
pin_lvttl_signal F6 de1_td__reset_n
pin_lvttl_signal A3 de1_td__vs

set gpio0_pins {
    AC18 AH18 AH17 AG16 AE16 AF16 AG17 AA18 AA19 AE17
    AC20  Y17 AH19 AJ20 AH20 AK21 AD19 AD20 AE18 AE19
    AF20 AF21 AD17 AF19 AG21 AF18 AG20 AG18 AJ21  Y18
    AK16 AK18 AK19 AJ19 AJ17 AJ16
}

set gpio1_pins {
    AB17 AA21 AB21 AC23 AD24 AE23 AE24 AF25 AF26 AG25
    AG26 AH24 AH27 AJ27 AK29 AK28 AK27 AJ26 AK26 AH25
    AJ25 AJ24 AK24 AG23 AK23 AH23 AK22 AJ22 AH22 AG22
    AF24 AF23 AE22 AD21 AA20 AC22
}

# PIN0_DOES_NOT_EXIST
# Hdr pins 1 thru 10
# Hdr pins 11 and 12 are VCC5V  GND
# Hdr pins 13 thru 28
# Hdr pins 29 and 30 are VCC3V3 GND
# Hdr pins 31 thru 40
set gpio_hdr_pins {
 0
    0 1 2 3 4 5 6 7 8 9
0 0
    10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
0 0
    26 27 28 29 30 31 32 33 34 35
}

global env
set USE_MTL_AS_VGA $env(USE_MTL_AS_VGA)
proc pin_sel {bus pins} {
    set sel_pins {}
    for {set n 0} {$n<[llength $pins]} {incr n} {
        set i [lindex $pins $n]
        set sel_pins "$sel_pins [lindex $bus $i]"
    }
    return $sel_pins
}
set gpio0_hdr_pins [pin_sel $gpio0_pins $gpio_hdr_pins]
set gpio1_hdr_pins [pin_sel $gpio1_pins $gpio_hdr_pins]
if {"$USE_MTL_AS_VGA"=="GPIO1"} {
    pin_lvttl_signal F10 de1_vga__blank_n
    pin_lvttl_signal C10 de1_vga__sync_n
    pin_lvttl_signal [pin_sel $gpio1_hdr_pins {36}] de1_vga__vs
    pin_lvttl_signal [pin_sel $gpio1_hdr_pins {35}] de1_vga__hs
    pin_lvttl_signal [pin_sel $gpio1_hdr_pins {2 }] de1_vga__clk
    pin_lvttl_signal [pin_sel $gpio1_hdr_pins {23 25 26 27 28 31 32 33}] de1_vga__b
    pin_lvttl_signal [pin_sel $gpio1_hdr_pins {14 15 16 17 18 21 22 24}] de1_vga__g
    pin_lvttl_signal [pin_sel $gpio1_hdr_pins { 4  5  6  7  8  9 10 13}] de1_vga__r
} else {
    pin_lvttl_signal D11 de1_vga__vs
    pin_lvttl_signal F10 de1_vga__blank_n
    pin_lvttl_signal B11 de1_vga__hs
    pin_lvttl_signal A11 de1_vga__clk
    pin_lvttl_signal { B13  G13  H13  F14  H14  F15  G15  J14} de1_vga__b
    pin_lvttl_signal {  J9  J10  H12  G10  G11  G12  F11  E11} de1_vga__g
    pin_lvttl_signal { A13  C13  E13  B12  C12  D12  E12  F13} de1_vga__r
    pin_lvttl_signal C10 de1_vga__sync_n
}

pin_lvttl_signal AE7 de1_ps2_dat
pin_lvttl_signal AD7 de1_ps2_clk
pin_lvttl_signal AE9 de1_ps2_b_dat
pin_lvttl_signal AD9 de1_ps2_b_clk
pin_lvttl_signal {V16 W16 V17 V18 W17 W19 Y19 W20 W21 Y21} de1_leds
pin_lvttl_signal {AB12 AC12  AF9 AF10 AD11 AD12 AE11  AC9 AD10 AE12} de1_switches
pin_lvttl_signal {AA14 AA15  W15  Y16} de1_keys
pin_lvttl_signal AA30 de1_irda__rxd
pin_lvttl_signal AB30 de1_irda__txd


#set_location_assignment PIN_AC18 -to GPIO_0[0]
#set_location_assignment PIN_AH18 -to GPIO_0[10]
#set_location_assignment PIN_AH17 -to GPIO_0[11]
#set_location_assignment PIN_AG16 -to GPIO_0[12]
#set_location_assignment PIN_AE16 -to GPIO_0[13]
#set_location_assignment PIN_AF16 -to GPIO_0[14]
#set_location_assignment PIN_AG17 -to GPIO_0[15]
#set_location_assignment PIN_AA18 -to GPIO_0[16]
#set_location_assignment PIN_AA19 -to GPIO_0[17]
#set_location_assignment PIN_AE17 -to GPIO_0[18]
#set_location_assignment PIN_AC20 -to GPIO_0[19]
#set_location_assignment PIN_Y17 -to GPIO_0[1]
#set_location_assignment PIN_AH19 -to GPIO_0[20]
#set_location_assignment PIN_AJ20 -to GPIO_0[21]
#set_location_assignment PIN_AH20 -to GPIO_0[22]
#set_location_assignment PIN_AK21 -to GPIO_0[23]
#set_location_assignment PIN_AD19 -to GPIO_0[24]
#set_location_assignment PIN_AD20 -to GPIO_0[25]
#set_location_assignment PIN_AE18 -to GPIO_0[26]
#set_location_assignment PIN_AE19 -to GPIO_0[27]
#set_location_assignment PIN_AF20 -to GPIO_0[28]
#set_location_assignment PIN_AF21 -to GPIO_0[29]
#set_location_assignment PIN_AD17 -to GPIO_0[2]
#set_location_assignment PIN_AF19 -to GPIO_0[30]
#set_location_assignment PIN_AG21 -to GPIO_0[31]
#set_location_assignment PIN_AF18 -to GPIO_0[32]
#set_location_assignment PIN_AG20 -to GPIO_0[33]
#set_location_assignment PIN_AG18 -to GPIO_0[34]
#set_location_assignment PIN_AJ21 -to GPIO_0[35]
#set_location_assignment PIN_Y18 -to GPIO_0[3]
#set_location_assignment PIN_AK16 -to GPIO_0[4]
#set_location_assignment PIN_AK18 -to GPIO_0[5]
#set_location_assignment PIN_AK19 -to GPIO_0[6]
#set_location_assignment PIN_AJ19 -to GPIO_0[7]
#set_location_assignment PIN_AJ17 -to GPIO_0[8]
#set_location_assignment PIN_AJ16 -to GPIO_0[9]
