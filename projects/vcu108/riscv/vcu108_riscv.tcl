set project_part "xcvu095-ffva2104-2-e"
set project_file "vcu108_riscv"
set project_top "vcu108_project"

set project_synth_options ""
append project_synth_options " -top ${project_top}"
append project_synth_options " -part ${project_part}"
append project_synth_options " -verilog_define debug_module=vcu108_riscv"
append project_synth_options " -verilog_define dut_clk=clk_128_57"

# Read RTL files
set project_rtl_files {}
lappend project_rtl_files ${RTL_DIR}/xilinx/vcu108_project.v
lappend project_rtl_files ${RTL_DIR}/xilinx/vcu108_plls.v
lappend project_rtl_files ${RTL_DIR}/xilinx/cascaded_delay_pair.v
lappend project_rtl_files ${RTL_DIR}/xilinx/srams.v
lappend project_rtl_files ${RTL_DIR}/xilinx/tech.v
lappend project_rtl_files ${RTL_DIR}/xilinx/sram_brams.v
lappend project_rtl_files ${RTL_DIR}/xilinx/diff_ddr_deserializer4.v
lappend project_rtl_files ${RTL_DIR}/xilinx/diff_ddr_serializer4.v
lappend project_rtl_files ${RTL_DIR}/srw_srams.v
lappend project_rtl_files ${RTL_DIR}/chk_riscv_ifetch.v
lappend project_rtl_files ${RTL_DIR}/chk_riscv_trace.v
lappend project_rtl_files ${VERILOG_DIR}/vcu108_riscv.v
lappend project_rtl_files ${VERILOG_DIR}/apb_processor.v
lappend project_rtl_files ${VERILOG_DIR}/apb_master_mux.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_dprintf.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_rv_timer.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_gpio.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_uart_minimal.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_dprintf_uart.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_i2c_master.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_sram_interface.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_timer.v
lappend project_rtl_files ${VERILOG_DIR}/apb_target_axi4s.v
lappend project_rtl_files ${VERILOG_DIR}/axi4s32_fifo_4.v
lappend project_rtl_files ${VERILOG_DIR}/apb_logging.v
lappend project_rtl_files ${VERILOG_DIR}/gbe_axi4s32.v
lappend project_rtl_files ${VERILOG_DIR}/encode_8b10b.v
lappend project_rtl_files ${VERILOG_DIR}/decode_8b10b.v
lappend project_rtl_files ${VERILOG_DIR}/gbe_axi4s32.v
lappend project_rtl_files ${VERILOG_DIR}/sgmii_gmii_gasket.v
lappend project_rtl_files ${VERILOG_DIR}/i2c_interface.v
lappend project_rtl_files ${VERILOG_DIR}/i2c_master.v
lappend project_rtl_files ${VERILOG_DIR}/uart_minimal.v
lappend project_rtl_files ${VERILOG_DIR}/clock_timer.v
lappend project_rtl_files ${VERILOG_DIR}/clock_divider.v
lappend project_rtl_files ${VERILOG_DIR}/clocking_phase_measure.v
lappend project_rtl_files ${VERILOG_DIR}/clocking_eye_tracking.v
lappend project_rtl_files ${VERILOG_DIR}/csr_master_apb.v
lappend project_rtl_files ${VERILOG_DIR}/csr_target_apb.v
lappend project_rtl_files ${VERILOG_DIR}/csr_target_csr.v
lappend project_rtl_files ${VERILOG_DIR}/csr_target_timeout.v
lappend project_rtl_files ${VERILOG_DIR}/dprintf_2_mux.v
lappend project_rtl_files ${VERILOG_DIR}/dprintf_4_mux.v
lappend project_rtl_files ${VERILOG_DIR}/dprintf_4_fifo_4.v
lappend project_rtl_files ${VERILOG_DIR}/dprintf_4_async.v
lappend project_rtl_files ${VERILOG_DIR}/dprintf.v
lappend project_rtl_files ${VERILOG_DIR}/framebuffer_timing.v
lappend project_rtl_files ${VERILOG_DIR}/framebuffer_teletext.v
lappend project_rtl_files ${VERILOG_DIR}/teletext.v
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

# clk_50 for second divider
# clk_150 for video
# clk_128_57 for dut
set project_clks "clk_50 clk_150 clk_128_57 rx_clk_312_5 rx_clk_625 tx_clk_312_5 tx_clk_625"
set project_constraints_tcl {}
lappend project_constraints_tcl ${VIVADO_DIR}/boards/vcu108.tcl
lappend project_constraints_tcl ../vcu108_project.timing.tcl

