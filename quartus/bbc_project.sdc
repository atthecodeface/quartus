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
create_clock -period 10.0 -name MainClock [get_ports clk]
create_generated_clock -name cpu_clk           -source [get_ports clk] -edges { 1 2 5 } [get_nets {*clk_cpu__gen*out*}]
create_generated_clock -name video_clk         -source [get_ports clk] -edges { 3 4 7 } [get_nets {*clk_2MHz_video_clock__gen*out*}]

# The register ones should not be necessary, but the global cpu_clk to video_clk may be too much
set_false_path -from cpu_clk -to [get_registers *vidproc\|pixel*]
set_false_path -from cpu_clk -to [get_registers *vidproc\|red*]
set_false_path -from cpu_clk -to [get_registers *vidproc\|green*]
set_false_path -from cpu_clk -to [get_registers *vidproc\|blue*]
#set_false_path -from cpu_clk -to video_clk
set_false_path -from [get_registers *crtc6845:*control__*] -to video_clk

# The following don't work as yet - need to get the hierarchy right - but they don't seem to be necessary
# The key generated clock is cpu_clk, which runs at half frequency, but has full frequency to/from memory
#create_generated_clock -name bbc_cpu_clk       -source [get_ports clk] -edges { 1 2 5 } [get_nets {bbc_micro_with_rams:bbc|cpu_clk__gen*out*}]
#create_generated_clock -name bbc_1mhz_rising   -source [get_ports clk] -edges { 1 2 5 } [get_nets {bbc_micro_with_rams:bbc|clk_1MHzE_falling_gen*out*}]
#create_generated_clock -name bbc_1mhz_fallsing -source [get_ports clk] -edges { 1 2 5 } [get_nets {bbc_micro_with_rams:bbc|clk_1MHzE_rising_gen*out*}]

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
