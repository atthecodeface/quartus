#a Environment import
global env
source $env(VIVADO_SCRIPTS_DIR)/env.tcl

open_checkpoint ${output_file_base}.postroute.dcp

write_bitstream ${output_file_base}.bit
