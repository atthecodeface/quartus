global env
source $env(QUARTUS_SCRIPTS_DIR)/env.tcl

load_package flow

post_message -type info "Synthesizing project '$project_file' revision '$PROJECT_SYNTH_REVISION'"

project_open $project_file -revision $PROJECT_SYNTH_REVISION

lappend project_global_assignments "-name TOP_LEVEL_ENTITY       $project_top"

source $SCRIPTS_DIR/quartus.tcl
source $SCRIPTS_DIR/pins.tcl

foreach pga $project_global_assignments {
    eval "set_global_assignment $pga"
}
foreach pga $project_instance_assignments {
    eval "set_instance_assignment $pga"
}
foreach rtl $project_rtl_files {
    set_global_assignment -name VERILOG_FILE $rtl
}
foreach pe $project_parameter_entities {
    eval "set_parameter -entity $project_top $pe"
}
foreach f $project_constraints_tcl {
    source $f
}
execute_module -tool map

project_close
