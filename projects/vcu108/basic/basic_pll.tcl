set project_part "xcvu095-ffva2104-2-e"
set project_file "basic"
set project_top  "basic_project_pll"

set project_synth_options ""
append project_synth_options " -top ${project_top}"
append project_synth_options " -part ${project_part}"
append project_synth_options " -verilog_define basic_module=basic_0"

# Read RTL files
set project_rtl_files {}
lappend project_rtl_files ${RTL_DIR}/xilinx/basic_0.v
lappend project_rtl_files ${RTL_DIR}/xilinx/basic_project_pll.v

set project_constraints_tcl {}
lappend project_constraints_tcl basic.pins.tcl
lappend project_constraints_tcl basic.timing.tcl
