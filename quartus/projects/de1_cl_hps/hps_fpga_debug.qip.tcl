#a Environment import
global env
set RTL_DIR        $env(RTL_DIR)
set SRAMS_DIR      $env(SRAMS_DIR)
set VERILOG_DIR    $env(VERILOG_DIR)
set QUARTUS_OUTPUT $env(QUARTUS_OUTPUT)
set QUARTUS_DIR    $env(QUARTUS_DIR)

#a QIP includes
# note that there is a bug in Quartus that does not permit sourcing of tcl files and qip files from a tcl file
set_global_assignment -name QIP_FILE $QUARTUS_DIR/modules/hps/synthesis/hps.qip
