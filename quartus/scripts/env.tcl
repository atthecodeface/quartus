global env
set SCRIPTS_DIR      $env(QUARTUS_SCRIPTS_DIR)
set SRAMS_DIR        $env(SRAMS_DIR)
set VERILOG_DIR      $env(VERILOG_DIR)
set RTL_DIR          $env(RTL_DIR)
set ALTERA_RTL_DIR   $env(ALTERA_RTL_DIR)
set QUARTUS_OUTPUT   $env(QUARTUS_OUTPUT)
set QUARTUS_DIR      $env(QUARTUS_DIR)

global argv
set project    [ lindex $argv 0 ]
set PROJECT_SYNTH_REVISION [ lindex $argv 1 ]
set project_global_assignments {}
set project_instance_assignments {}
set project_rtl_files {}
set project_constraints_tcl {}
set project_parameter_entities {}
source ${project}_project.tcl

lappend project_global_assignments "-name PROJECT_OUTPUT_DIRECTORY $QUARTUS_OUTPUT"
lappend project_global_assignments "-name MIN_CORE_JUNCTION_TEMP 0"
lappend project_global_assignments "-name MAX_CORE_JUNCTION_TEMP 85"
lappend project_global_assignments "-name ERROR_CHECK_FREQUENCY_DIVISOR 256"
lappend project_global_assignments {-name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"}
lappend project_global_assignments {-name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation}
lappend project_global_assignments "-name PARTITION_NETLIST_TYPE SOURCE -section_id Top"
lappend project_global_assignments "-name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top"
lappend project_global_assignments "-name PARTITION_COLOR 16764057 -section_id Top"
lappend project_instance_assignments "-name PARTITION_HIERARCHY root_partition -to | -section_id Top"

set output_file_base "${QUARTUS_OUTPUT}/${project_file}"

