#b Setting up I/O
#   set_location_assignment PIN M20 -to address[10]
#   set_instance_assignment -name IO_STANDARD "2.5 V" -to address[10]
#   set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to address[10]
#   set_instance_assignment -name SLEW_RATE 2 -to e[0]
#
# Can one use:
# PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING (ON)
# PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION (ON)


#============================================================
# HPS
#============================================================
#source "modules/hps/synthesis/submodules/hps_sdram_p0_pin_assignments.tcl"

diff_sstl_signal __hps_sdram_p0  hps_ddr3__ck_n 1
diff_sstl_signal __hps_sdram_p0  hps_ddr3__ck_p 1

sstl_signal __hps_sdram_p0 hps_ddr3__addr  14
sstl_signal __hps_sdram_p0 hps_ddr3__ba    3
sstl_signal __hps_sdram_p0 hps_ddr3__dm    4
sstl_signal __hps_sdram_p0 hps_ddr3__dq    32
diff_sstl_signal __hps_sdram_p0  hps_ddr3__dqs_n 4
diff_sstl_signal __hps_sdram_p0  hps_ddr3__dqs_p 4

sstl_signal __hps_sdram_p0 hps_ddr3__cke 1
sstl_signal __hps_sdram_p0 hps_ddr3__cs_n 1
sstl_signal __hps_sdram_p0 hps_ddr3__ras_n 1
sstl_signal __hps_sdram_p0 hps_ddr3__cas_n 1
sstl_signal __hps_sdram_p0 hps_ddr3__we_n 1
sstl_signal __hps_sdram_p0 hps_ddr3__odt 1
sstl_signal __hps_sdram_p0 hps_ddr3__reset_n 1
sstl_signal __hps_sdram_p0 hps_ddr3__rzq 1

set_instance_assignment -name D5_DELAY 2 -to hps_ddr3__ck_p -tag __hps_sdram_p0
set_instance_assignment -name D5_DELAY 2 -to hps_ddr3__ck_n -tag __hps_sdram_p0
set_global_assignment -name USE_DLL_FREQUENCY_FOR_DQS_DELAY_CHAIN ON

set hps_sdram_inst u0|hps_0|hps_io|border|hps_sdram_inst
set umemphy ${hps_sdram_inst}|p0|umemphy
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|ureset|phy_reset_mem_stable_n -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|ureset|phy_reset_n -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uio_pads|dq_ddio[0].read_capture_clk_buffer -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uread_datapath|reset_n_fifo_write_side[0] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uread_datapath|reset_n_fifo_wraddress[0] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uio_pads|dq_ddio[1].read_capture_clk_buffer -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uread_datapath|reset_n_fifo_write_side[1] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uread_datapath|reset_n_fifo_wraddress[1] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uio_pads|dq_ddio[2].read_capture_clk_buffer -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uread_datapath|reset_n_fifo_write_side[2] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uread_datapath|reset_n_fifo_wraddress[2] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uio_pads|dq_ddio[3].read_capture_clk_buffer -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uread_datapath|reset_n_fifo_write_side[3] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to $umemphy|uread_datapath|reset_n_fifo_wraddress[3] -tag __hps_sdram_p0
set_instance_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS ON -to $hps_sdram_inst -tag __hps_sdram_p0
set_instance_assignment -name PLL_COMPENSATION_MODE DIRECT -to $hps_sdram_inst|pll0|fbout -tag __hps_sdram_p0

term50 __hps_sdram_p0 hps_ddr3__dq 32
term50 __hps_sdram_p0 hps_ddr3__dqs_p 4
term50 __hps_sdram_p0 hps_ddr3__dqs_n 4
inst_assign OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"  __hps_sdram_p0 hps_ddr3__ck_p 1
inst_assign OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"  __hps_sdram_p0 hps_ddr3__ck_n 1

inst_assign CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"  __hps_sdram_p0 hps_ddr3__addr     15
inst_assign CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"  __hps_sdram_p0 hps_ddr3__ba       3
inst_assign CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"  __hps_sdram_p0 hps_ddr3__cke      1
inst_assign CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"  __hps_sdram_p0 hps_ddr3__cs_n     1
inst_assign CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"  __hps_sdram_p0 hps_ddr3__cas_n    1
inst_assign CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"  __hps_sdram_p0 hps_ddr3__ras_n    1
inst_assign CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"  __hps_sdram_p0 hps_ddr3__we_n     1
inst_assign CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"  __hps_sdram_p0 hps_ddr3__odt      1
inst_assign CURRENT_STRENGTH_NEW "MAXIMUM CURRENT"  __hps_sdram_p0 hps_ddr3__reset_n  1

inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__dq     32
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__dm     4
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__dqs_p  4
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__dqs_n  4
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__addr     15
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__ba       3
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__cke      1
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__cs_n     1
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__cas_n    1
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__ras_n    1
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__we_n     1
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__odt      1
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__reset_n  1
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__ck_n     1
inst_assign PACKAGE_SKEW_COMPENSATION OFF  __hps_sdram_p0 hps_ddr3__ck_p     1

inst_assign OUTPUT_TERMINATION "SERIES 50 OHM WITH CALIBRATION"  __hps_sdram_p0 hps_ddr3__dm   4


lvttl_signal "" hps_conv_usb_n 1

lvttl_signal "" hps_enet__gtx_clk 1
lvttl_signal "" hps_enet__int_n 1
lvttl_signal "" hps_enet__mdc 1
lvttl_signal "" hps_enet__mdio 1
lvttl_signal "" hps_enet__rx_clk 1
lvttl_signal "" hps_enet__rx_data 4
lvttl_signal "" hps_enet__rx_dv 1
lvttl_signal "" hps_enet__tx_data 4
lvttl_signal "" hps_enet__tx_en 1
lvttl_signal "" hps_flash__data 4
lvttl_signal "" hps_flash__dclk 1
lvttl_signal "" hps_flash__ncso 1
lvttl_signal "" hps_i2c1_sclk 1
lvttl_signal "" hps_i2c1_sdat 1
lvttl_signal "" hps_i2c2_sclk 1
lvttl_signal "" hps_i2c2_sdat 1
lvttl_signal "" hps_i2c_control 1
lvttl_signal "" hps_sd__clk 1
lvttl_signal "" hps_sd__cmd 1
lvttl_signal "" hps_sd__data 4
lvttl_signal "" hps_spim__clk 1
lvttl_signal "" hps_spim__miso 1
lvttl_signal "" hps_spim__mosi 1
lvttl_signal "" hps_spim__ss 1
lvttl_signal "" hps_uart__rx 1
lvttl_signal "" hps_uart__tx 1
lvttl_signal "" hps_usb__clkout 1
lvttl_signal "" hps_usb__data 8
lvttl_signal "" hps_usb__dir 1
lvttl_signal "" hps_usb__nxt 1
lvttl_signal "" hps_usb__stp 1

#lvttl_signal "" hps_key 1
#lvttl_signal "" hps_led 1
#lvttl_signal "" hps_ltc_gpio 1
#lvttl_signal "" hps_gsensor_int 1

