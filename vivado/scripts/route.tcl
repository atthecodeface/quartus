#a Environment import
global env
source $env(VIVADO_SCRIPTS_DIR)/env.tcl

open_checkpoint ${output_file_base}.postphysopt.dcp

route_design
write_checkpoint -force ${output_file_base}.postroute.dcp
