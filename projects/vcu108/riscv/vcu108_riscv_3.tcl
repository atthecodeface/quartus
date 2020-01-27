set project_part "xcvu095-ffva2104-2-e"
set project_file "vcu108_riscv_3"
set project_top "vcu108_project"

set project_synth_options ""
append project_synth_options " -top ${project_top}"
append project_synth_options " -part ${project_part}"
append project_synth_options " -verilog_define debug_module=vcu108_riscv_3"
append project_synth_options " -verilog_define dut_clk=clk_128_57"

# Read RTL files
set project_rtl_files {}
source project_files.tcl

# clk_50 for second divider
# clk_150 for video
# clk_128_57 for dut
set project_clks "clk_50 clk_150 clk_128_57 rx_clk_312_5 rx_clk_625 tx_clk_312_5 tx_clk_625"
set project_constraints_tcl {}
lappend project_constraints_tcl ${VIVADO_DIR}/boards/vcu108.tcl
lappend project_constraints_tcl ../vcu108_project.timing.tcl

