create_clock -period 20.0 -name clk50 [get_ports clk_50]
derive_pll_clocks

set vga_clock video_clk_gen|*|general[1]*|divclk

set_false_path -from clk50 -to $vga_clock
set_false_path -from $vga_clock -to clk50

