#a Environment import
global env
source $env(VIVADO_SCRIPTS_DIR)/env.tcl

# Info messages to suppress
# [Synth 8-155] case statement is not full and has no default
# [Synth 8-226] default block is never used
# [Synth 8-802] inferred FSM for state register '...' in module '...'
# [Synth 8-3333] propagating constant 0 across sequential element
# [Synth 8-3354] encoded FSM with state register 'video_state__v_state_reg' using encoding 'one-hot' in module
# [Synth 8-3536] HDL ADVISOR - Pragma parallel_case detected. Simulation mismatch may occur
# [Synth 8-3886] merging instance
# [Synth 8-4471] merging register
# [Synth 8-5544] ROM "..." won't be mapped to Block RAM because address size (4) smaller than threshold (5)
# [Synth 8-5587] ROM size for "..." is below threshold of ROM address width. It will be mapped to LUTs
# [Synth 8-5818] HDL ADVISOR - The operator resource <adder> is shared. To prevent sharing consider applying a KEEP on the output of the operator
# [Synth 8-6155] done synthesizing module '...'
# [Synth 8-6157] synthesizing module '...'
# [Synth 8-6837] The timing for the instance ... (implemented as a Block RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
set info_to_suppress {{[Synth 8-155]}
    {[Synth 8-226]}
    {[Synth 8-802]}
    {[Synth 8-3333]}
    {[Synth 8-3354]}
    {[Synth 8-3536]}
    {[Synth 8-3886]}
    {[Synth 8-4471]}
    {[Synth 8-5544]}
    {[Synth 8-5587]}
    {[Synth 8-5818]}
    {[Synth 8-6155]}
    {[Synth 8-6157]}
    {[Synth 8-6837]}
}

# Warnings to suppress
# [Synth 8-6014] Unused sequential element vga_counters_reg[3] was removed.
#  The next one means that a design does not *use* an input port
# [Synth 8-3331] design ... has unconnected port ...
# [Synth 8-3332] Sequential element (FSM_sequential_debug_state__control__fsm_state_reg[2]) is unused and will be removed from module ...
# keep... [Synth 8-3917] design vcu108_project has port eth__mdc driven by constant 1
# [Synth 8-6014] Unused sequential element ... was removed.  [...]
# [Synth 8-7023] instance '...' of module '...' has ... connections declared, but only ... given [...]
# [Synth 8-3936] Found unconnected internal register 'data_sram_access_req__address_reg' and it is trimmed from '32' to '16' bits. [/git/atcf_fpga/verilog/riscv_i32_minimal.v:1614]
set warnings_to_suppress { {[Synth 8-6014]}
    {[Synth 8-3331]}
    {[Synth 8-3332]}
    {[Synth 8-3936]}
    {[Synth 8-6014]}
    {[Synth 8-7023]}
}
foreach msg $info_to_suppress {
    set_msg_config -id $msg -suppress
}
foreach msg $warnings_to_suppress {
    set_msg_config -id $msg -suppress
}
#
#set_msg_config -id {[Synth 8-155]} -new_severity {ERROR}

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
eval $synth_command

# set_part xcvu095-ffva2104-2-e

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

