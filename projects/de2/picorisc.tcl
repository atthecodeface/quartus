#a Environment import
global env
set RTL_DIR        $env(RTL_DIR)
set SRAMS_DIR      $env(SRAMS_DIR)
set VERILOG_DIR    $env(VERILOG_DIR)
set QUARTUS_OUTPUT $env(QUARTUS_OUTPUT)
set QUARTUS_DIR    $env(QUARTUS_DIR)

#a Project globals
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
set entity    "de2_project"
set_global_assignment -name TOP_LEVEL_ENTITY       $entity

#a Source files

source $QUARTUS_DIR/scripts/pins.tcl
source $QUARTUS_DIR/devices/cyclone_2_35_F_672.tcl
source $QUARTUS_DIR/boards/de2.tcl

puts "Sourced TCL files"

set_global_assignment -name SDC_FILE     picorisc.sdc
set_global_assignment -name VERILOG_MACRO de2_dut_module=picorisc_de2
#set_global_assignment -name VERILOG_FILE picorisc.v
set_global_assignment -name VERILOG_FILE $RTL_DIR/srams.v
set_global_assignment -name VERILOG_FILE $RTL_DIR/de2_project.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_master_mux.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_processor.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_dprintf.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_gpio.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_timer.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_rv_timer.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_ps2_host.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_sram_interface.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/ps2_host.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/hysteresis_switch.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/csr_target_apb.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/csr_target_timeout.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/csr_master_apb.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/csr_target_csr.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/dprintf.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/dprintf_4_mux.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/framebuffer_timing.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/framebuffer_teletext.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/led_seven_segment.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/teletext.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_trace.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_decode.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32c_decode.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_alu.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_csrs_minimal.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32c_pipeline.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_minimal.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_minimal_apb.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/picorisc_de2.v

#a Set parameters (e.g. SRAMs)

# e.g. fpga_0|framebuffer_teletext:ftb|se_sram_srw_128x45:character_rom|se_sram_srw:ram

set fpga_hier "dut"

set_parameter -entity $entity -to "$fpga_hier\|ftb_vga\|character_rom\|ram"     -name initfile $SRAMS_DIR/teletext.qmif
set_parameter -entity $entity -to "$fpga_hier\|apb_rom\|ram"                    -name initfile $SRAMS_DIR/apb_vga_rom.qmif

