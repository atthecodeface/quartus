global env
set SCRIPTS_DIR    $env(VIVADO_SCRIPTS_DIR)
set SRAMS_DIR      $env(SRAMS_DIR)
set VERILOG_DIR    $env(VERILOG_DIR)
set RTL_DIR        $env(RTL_DIR)
set VIVADO_OUTPUT  $env(VIVADO_OUTPUT)
set VIVADO_DIR     $env(VIVADO_DIR)

global argv
set project [lindex $argv 0]
source ${project}.tcl

set output_file_base "${VIVADO_OUTPUT}/${project_file}"

