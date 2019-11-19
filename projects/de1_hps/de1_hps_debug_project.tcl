#a Project globals
set project_part "xcvu095-ffva2104-2-e"
set project_file "de1_hps_debug"
set project_top "de1_hps_project"

#a Source files
lappend project_constraints_tcl $QUARTUS_DIR/devices/cyclone_5_SE_M_F31.tcl
lappend project_constraints_tcl $QUARTUS_DIR/boards/de1.tcl
lappend project_constraints_tcl $QUARTUS_DIR/boards/de1_hps.tcl

puts "Sourced TCL files"

lappend project_global_assignments "-name SDC_FILE      de1_hps_debug.sdc"
lappend project_global_assignments "-name VERILOG_MACRO de1_hps_dut_module=de1_hps_debug"
lappend project_global_assignments "-name VERILOG_MACRO dut_clk=clk_100"


lappend project_rtl_files $RTL_DIR/altera/de1_hps_project.v
lappend project_rtl_files $RTL_DIR/altera/srams.v
lappend project_rtl_files $RTL_DIR/srw_srams.v
lappend project_rtl_files $RTL_DIR/mrw_srams.v
lappend project_rtl_files $RTL_DIR/chk_riscv_ifetch.v
lappend project_rtl_files $RTL_DIR/chk_riscv_trace.v
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
lappend project_rtl_files $VERILOG_DIR/clock_timer.v
lappend project_rtl_files $VERILOG_DIR/clock_divider.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_debug.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_minimal_apb.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_minimal.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32c_pipeline.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32c_decode.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_decode.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_alu.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_dmem_request.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_dmem_read_data.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_trace.v
lappend project_rtl_files $VERILOG_DIR/riscv_csrs_decode.v
lappend project_rtl_files $VERILOG_DIR/riscv_csrs_machine_only.v
lappend project_rtl_files $VERILOG_DIR/riscv_csrs_machine_debug.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_pipeline_control.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_pipeline_control_flow.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_pipeline_control_fetch_data.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_pipeline_control_fetch_req.v
lappend project_rtl_files $VERILOG_DIR/riscv_i32_pipeline_trap_interposer.v


