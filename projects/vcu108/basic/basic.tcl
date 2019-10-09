set file "basic"
set top "basic_project"

# Read RTL files
set project_rtl_files {}
lappend project_rtl_files ${RTL_DIR}/basic_0.v
lappend project_rtl_files ${RTL_DIR}/basic_project.v

set project_constraints_tcl {}
lappend project_constraints_tcl basic.pins.tcl
lappend project_constraints_tcl basic.timing.tcl
