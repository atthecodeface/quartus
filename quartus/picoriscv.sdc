create_clock -period 20.0 -name MainClock [get_ports clk]
#create_clock -period 7.0 -name MainClock [get_ports clk]
derive_pll_clocks
#create_clock -period 111.0 -name VideoClock [get_nets bbc|video_clk]

