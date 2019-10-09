#a Environment import
global env
source $env(VIVADO_SCRIPTS_DIR)/env.tcl

open_checkpoint ${output_file_base}.postroute.dcp

report_timing_summary -file ${output_file_base}.tim.sum
report_timing -sort_by group -max_paths 100 -path_type summary -file ${output_file_base}.tim.rpt
report_io -file ${output_file_base}.io.rpt
report_clocks -file ${output_file_base}.clks.rpt
report_clock_utilization -file ${output_file_base}.clkutil.rpt
report_utilization -file ${output_file_base}.util.rpt
report_power -file ${output_file_base}.pwr.rpt
report_ram_utilization -file ${output_file_base}.ram.rpt

