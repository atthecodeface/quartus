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
