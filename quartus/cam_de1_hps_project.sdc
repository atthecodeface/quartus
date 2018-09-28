#   #
#   # Create Constraints
#   #
#   create_clock -period 10.0 -waveform { 0 5.0 } clk2 -name clk2
#   create_clock -period 4.0 -waveform { 0 2.0 } clk1 -name clk1
#   # clk1 -> dir* : INPUT_MAX_DELAY = 1 ns
#   set_input_delay -max 1ns -clock clk1 [get_ports dir*]
#   # clk2 -> time* : OUTPUT_MAX_DELAY = -2 ns
#   set_output_delay -max -2ns -clock clk2 [get_ports time*]
#   #
create_clock -period 20.0 -name clk50 [get_ports clk_50]
derive_pll_clocks

set vga_clock video_clk_gen|*|general[1]*|divclk
set lcd_clock video_clk_gen|*|general[0]*|divclk

set_false_path -from clk50 -to $vga_clock
set_false_path -from clk50 -to $lcd_clock

set_false_path -from $vga_clock -to clk50
set_false_path -from $lcd_clock -to clk50

# 
# # The register ones should not be necessary, but the global cpu_clk to video_clk may be too much

# # The next three don't all work - just red. No idea why - except perhaps the destination gets to rename the registers?
# set_false_path -from cpu_clk -to [get_registers *vidproc\|red*]
# set_false_path -from cpu_clk -to [get_registers *vidproc\|green*]
# set_false_path -from cpu_clk -to [get_registers *vidproc\|blue*]
# #set_false_path -from cpu_clk -to video_clk
# set_false_path -from [get_registers *crtc6845:*control__*] -to video_clk

# set cpu_clk_enabled   [get_fanouts *bbc_micro_clocking:clocking*cpu_clk_low*]
# set video_clk_enabled [get_fanouts *bbc_micro_clocking:clocking*two_mhz_high*]
# set_multicycle_path -from $cpu_clk_enabled -to $cpu_clk_enabled -end -setup 2 
# set_multicycle_path -from $cpu_clk_enabled -to $cpu_clk_enabled -end -hold 1 
# set_multicycle_path -from $video_clk_enabled -to $video_clk_enabled -end -setup 2 
# set_multicycle_path -from $video_clk_enabled -to $video_clk_enabled -end -hold 1 
# set_false_path      -from $cpu_clk_enabled -to $video_clk_enabled
# #set_false_path      -from [get_nets *se_sram_srw*] -to [get_registers *bbc_vidproc:vidproc|*palette*]

#This produces a large selection of pins - all 'pins' in the design
#set fullcollection [get_pins -hierarchical *]
#foreach_in_collection pin $fullcollection {
#    post_message -type info "pin $pin"
#    post_message -type info "[get_pin_info -name $pin]"
#}

#set fullcollection [get_pins *]
#foreach_in_collection pin $fullcollection {
#    post_message -type info "[get_pin_info -name $pin]"
#}

#set fullcollection [get_cells *]
#foreach_in_collection pin $fullcollection {
#    post_message -type info "cell [get_cell_info -name $pin]"
#}

# This produces a set of pins (really ports) that re (e.g.) port_10, get_port_info -name port_10 is 'clk'
#set fullcollection [get_ports *]
#foreach_in_collection pin $fullcollection {
#    post_message -type info "pin $pin"
#    post_message -type info "[get_port_info -name $pin]"
#}
# This produces a single port, port_10, whose -name is 'clk'
#set fullcollection [get_ports clk]
#foreach_in_collection pin $fullcollection {
#    post_message -type info "pin $pin"
#    post_message -type info "[get_port_info -name $pin]"
#}
#
#create_generated_clock -divide_by 2 -source MainClock -name CpuClk [get_pins cpu_clk__gen|CLK_OUT]
