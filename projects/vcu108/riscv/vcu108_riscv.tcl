set project_part "xcvu095-ffva2104-2-e"
set project_file "vcu108_riscv"
set project_top "vcu108_project"

set project_synth_options ""
append project_synth_options " -top ${project_top}"
append project_synth_options " -part ${project_part}"
append project_synth_options " -verilog_define debug_module=vcu108_riscv"

# Read RTL files
set project_rtl_files {}
lappend project_rtl_files ${RTL_DIR}/vcu108_project.v
lappend project_rtl_files ${RTL_DIR}/vcu108_plls.v
lappend project_rtl_files ${RTL_DIR}/srams.v
lappend project_rtl_files ${RTL_DIR}/srw_srams.v
lappend project_rtl_files ${VERILOG_DIR}/vcu108_debug.v
lappend project_rtl_files ${VERILOG_DIR}/apb_processor.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_dprintf.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_gpio.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_uart_minimal.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_dprintf_uart.v
lappend project_rtl_files ${VERILOG_DIR}/uart_minimal.v
lappend project_rtl_files ${VERILOG_DIR}/clock_divider.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_sram_interface.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_timer.v
lappend project_rtl_files ${VERILOG_DIR}/csr_master_apb.v
lappend project_rtl_files ${VERILOG_DIR}/csr_target_apb.v
lappend project_rtl_files ${VERILOG_DIR}/csr_target_csr.v
lappend project_rtl_files ${VERILOG_DIR}/csr_target_timeout.v
lappend project_rtl_files ${VERILOG_DIR}/dprintf_2_mux.v
lappend project_rtl_files ${VERILOG_DIR}/dprintf_4_mux.v
lappend project_rtl_files ${VERILOG_DIR}/dprintf_4_fifo_4.v
lappend project_rtl_files ${VERILOG_DIR}/dprintf.v
lappend project_rtl_files ${VERILOG_DIR}/framebuffer_timing.v
lappend project_rtl_files ${VERILOG_DIR}/framebuffer_teletext.v
lappend project_rtl_files ${VERILOG_DIR}/teletext.v

set project_constraints_tcl {}
lappend project_constraints_tcl ${VIVADO_DIR}/boards/vcu108.tcl
lappend project_constraints_tcl vcu108_riscv.timing.tcl

