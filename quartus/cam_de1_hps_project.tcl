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

#a Source files

source pins.tcl
source hps.tcl
source de1.tcl
source cam_de1.tcl

puts "Sourced all files"
set_global_assignment -name VERILOG_FILE $RTL_DIR/cam_de1_hps_project.v

puts "Sourced verilog files"
set_global_assignment -name SDC_FILE $QUARTUS_DIR/cam_de1_hps_project.sdc

set_global_assignment -name VERILOG_FILE $RTL_DIR/srams.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_master_axi.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_master_mux.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_processor.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_dprintf.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_gpio.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_timer.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_ps2_host.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_led_ws2812.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_sram_interface.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/apb_target_de1_cl_inputs.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/ps2_host.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/hysteresis_switch.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/de1_cl_controls.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/csr_target_apb.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/csr_target_timeout.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/csr_master_apb.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/csr_target_csr.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/dprintf.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/dprintf_4_mux.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/framebuffer_timing.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/framebuffer_teletext.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/led_seven_segment.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/led_ws2812_chain.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/teletext.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_trace.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_decode.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32c_decode.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_alu.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_csrs_minimal.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32c_pipeline.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_minimal.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/riscv_i32_minimal_apb.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/hps_fpga_debug.v

#set fpga_hier "fpga_0\|io"
set fpga_hier "fpga_0"
set entity "cam_de1_hps_project"
#fpga_0|framebuffer_teletext:ftb|se_sram_srw_128x45:character_rom|se_sram_srw:ram
set_parameter -entity $entity -to "$fpga_hier\|ftb_lcd\|character_rom\|ram"      -name initfile $SRAMS_DIR/teletext.qmif
set_parameter -entity $entity -to "$fpga_hier\|ftb_vga\|character_rom\|ram"      -name initfile $SRAMS_DIR/teletext.qmif
set_parameter -entity $entity -to "$fpga_hier\|apb_rom\|ram"                 -name initfile $SRAMS_DIR/apb_vga_rom.qmif

#a Set parameters (e.g. SRAMs)
set bbc_hier "bbc_micro\|bbc"
set io_hier "bbc_micro\|io"
#set_parameter -entity "bbc_project" -to "$bbc_hier\|bbc\|basic\|ram"               -name initfile $SRAMS_DIR/basic2.rom.qmif
#set_parameter -entity "bbc_project" -to "$bbc_hier\|bbc\|os\|ram"                  -name initfile $SRAMS_DIR/os12.rom.qmif
#set_parameter -entity "bbc_project" -to "$bbc_hier\|bbc\|adfs\|ram"                -name initfile $SRAMS_DIR/dfs.rom.qmif
#set_parameter -entity "bbc_project" -to "$bbc_hier\|floppy\|ram"                   -name initfile $SRAMS_DIR/elite.qmif
#set_parameter -entity "bbc_project" -to "$bbc_hier\|bbc\|saa\|character_rom\|ram"  -name initfile $SRAMS_DIR/teletext.qmif
#set_parameter -entity "bbc_project" -to "$io_hier\|ftb\|character_rom\|ram"        -name initfile $SRAMS_DIR/teletext.qmif
#set_parameter -entity "bbc_project" -to "$io_hier\|bbc_ps2_kbd\|kbd_map\|ram"      -name initfile $SRAMS_DIR/ps2_bbc_kbd.qmif
#set_parameter -entity "bbc_project" -to "$io_hier\|apb_rom\|ram"                   -name initfile $SRAMS_DIR/apb_rom.qmif


