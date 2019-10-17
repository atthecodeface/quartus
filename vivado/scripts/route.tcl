#a Environment import
global env
source $env(VIVADO_SCRIPTS_DIR)/env.tcl
source ${SCRIPTS_DIR}/extract_memory.tcl

open_checkpoint ${output_file_base}.postphysopt.dcp

route_design
write_checkpoint -force ${output_file_base}.postroute.dcp
set bram_dict_py [open ${output_file_base}__bram_dict.py w]
report_cells_as_pydict $bram_dict_py {REF_NAME =~ *RAMB*}
close $bram_dict_py

