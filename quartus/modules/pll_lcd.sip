set_global_assignment -entity "pll_lcd" -library "lib_pll_lcd" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_lcd" -library "lib_pll_lcd" -name IP_TOOL_VERSION "15.0"
set_global_assignment -entity "pll_lcd" -library "lib_pll_lcd" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_lcd" -name SPD_FILE [file join $::quartus(sip_path) "pll_lcd.spd"]

#set_global_assignment -library "lib_pll_lcd" -name MISC_FILE [file join $::quartus(sip_path) "pll_lcd_sim/pll_lcd.vo"]
