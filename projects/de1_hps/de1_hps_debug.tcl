#a Environment import
global env
set RTL_DIR        $env(RTL_DIR)
set SRAMS_DIR      $env(SRAMS_DIR)
set VERILOG_DIR    $env(VERILOG_DIR)
set QUARTUS_OUTPUT $env(QUARTUS_OUTPUT)
set QUARTUS_DIR    $env(QUARTUS_DIR)

#a Project globals
set entity    "de1_hps_project"
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY $QUARTUS_OUTPUT
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top
set_global_assignment -name TOP_LEVEL_ENTITY       $entity

#a Source files
set project_global_assignments {}
set project_rtl_files {}

# Read RTL files

source $QUARTUS_DIR/scripts/quartus.tcl
source $QUARTUS_DIR/scripts/pins.tcl
source $QUARTUS_DIR/devices/cyclone_5_SE_M_F31.tcl
source $QUARTUS_DIR/boards/de1.tcl
source $QUARTUS_DIR/boards/de1_hps.tcl

puts "Sourced TCL files"

lappend project_global_assignments "-name SDC_FILE      de1_hps_debug.sdc"
lappend project_global_assignments "-name VERILOG_MACRO de1_hps_dut_module=de1_hps_debug"
lappend project_global_assignments "-name VERILOG_MACRO dut_clk=clk_100"

lappend project_rtl_files $RTL_DIR/de1_hps_project.v
lappend project_rtl_files $RTL_DIR/srams.v
lappend project_rtl_files $VERILOG_DIR/de1_hps_debug.v
lappend project_rtl_files $VERILOG_DIR/apb_master_axi.v
lappend project_rtl_files $VERILOG_DIR/apb_master_mux.v
lappend project_rtl_files $VERILOG_DIR/apb_processor.v
lappend project_rtl_files $VERILOG_DIR/apb_target_dprintf.v
lappend project_rtl_files $VERILOG_DIR/apb_target_gpio.v
lappend project_rtl_files $VERILOG_DIR/apb_target_timer.v
lappend project_rtl_files $VERILOG_DIR/apb_target_rv_timer.v
lappend project_rtl_files $VERILOG_DIR/apb_target_ps2_host.v
lappend project_rtl_files $VERILOG_DIR/apb_target_led_ws2812.v
lappend project_rtl_files $VERILOG_DIR/apb_target_sram_interface.v
lappend project_rtl_files $VERILOG_DIR/apb_target_de1_cl_inputs.v
lappend project_rtl_files $VERILOG_DIR/ps2_host.v
lappend project_rtl_files $VERILOG_DIR/hysteresis_switch.v
lappend project_rtl_files $VERILOG_DIR/de1_cl_controls.v
lappend project_rtl_files $VERILOG_DIR/csr_target_apb.v
lappend project_rtl_files $VERILOG_DIR/csr_target_timeout.v
lappend project_rtl_files $VERILOG_DIR/csr_master_apb.v
lappend project_rtl_files $VERILOG_DIR/csr_target_csr.v
lappend project_rtl_files $VERILOG_DIR/dprintf.v
lappend project_rtl_files $VERILOG_DIR/dprintf_4_mux.v
lappend project_rtl_files $VERILOG_DIR/framebuffer_timing.v
lappend project_rtl_files $VERILOG_DIR/framebuffer_teletext.v
lappend project_rtl_files $VERILOG_DIR/led_seven_segment.v
lappend project_rtl_files $VERILOG_DIR/led_ws2812_chain.v
lappend project_rtl_files $VERILOG_DIR/teletext.v
lappend project_rtl_files ${VERILOG_DIR}/clock_timer.v
lappend project_rtl_files ${VERILOG_DIR}/clock_divider.v
lappend project_rtl_files ${RTL_DIR}/chk_riscv_ifetch.v
lappend project_rtl_files ${RTL_DIR}/chk_riscv_trace.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_debug.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_minimal_apb.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_minimal.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32c_pipeline.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32c_decode.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_decode.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_alu.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_dmem_request.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_dmem_read_data.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_trace.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_csrs_decode.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_csrs_machine_only.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_csrs_machine_debug.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_pipeline_control.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_pipeline_control_flow.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_pipeline_control_fetch_data.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_pipeline_control_fetch_req.v
lappend project_rtl_files ${VERILOG_DIR}/riscv_i32_pipeline_trap_interposer.v

foreach pga $project_global_assignments {
    eval "set_global_assignment $pga"
}
foreach rtl $project_rtl_files {
    set_global_assignment -name VERILOG_FILE $rtl
}

#a Set parameters (e.g. SRAMs)

# e.g. fpga_0|framebuffer_teletext:ftb|se_sram_srw_128x45:character_rom|se_sram_srw:ram

set fpga_hier "dut"

set_parameter -entity $entity -to "$fpga_hier\|ftb_debug\|character_rom\|ram"      -name initfile $SRAMS_DIR/teletext.qmif
set_parameter -entity $entity -to "$fpga_hier\|ftb_vga\|character_rom\|ram"        -name initfile $SRAMS_DIR/teletext.qmif
set_parameter -entity $entity -to "$fpga_hier\|apb_rom\|ram"                       -name initfile $SRAMS_DIR/apb_vga_rom.qmif

