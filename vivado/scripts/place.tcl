#a Environment import
global env
source $env(VIVADO_SCRIPTS_DIR)/env.tcl

# Set design properties
# Cannot write out design - there is no design until synthesis takes place
# write_checkpoint -force ${output_file_base}.postread.dcp
read_verilog ${project_rtl_files}

# link_design ?
# Tool flow - synth
# need one of the two synth_designs...
# # synth_design -rtl -name rtl_1
# synth_design - to specified target (map to LUTs?)
# synth_design
set synth_command "synth_design ${project_synth_options}"
puts "Synth command: '$synth_command'"
eval $synth_command

write_checkpoint -force ${output_file_base}.postsynth.dcp
# did not work here
# source pins.tcl

# opt_design - high level design optimization
write_checkpoint -force ${output_file_base}.postopt.dcp

# power_opt_design - clock gating optimization

# phys_opt_design - physical logic optimization pre route

# Must source pins.tcl AFTER synth_design for some reason

source ${SCRIPTS_DIR}/pins.tcl
foreach f $project_constraints_tcl {
    source $f
}

place_design
write_checkpoint -force ${output_file_base}.postplace.dcp

phys_opt_design
write_checkpoint -force ${output_file_base}.postphysopt.dcp

