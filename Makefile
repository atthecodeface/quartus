
ROOT:=$(CURDIR)
QUARTUS_DIR=$(ROOT)/quartus
SCRIPTS_DIR=$(ROOT)/scripts
RTL_DIR=$(ROOT)/rtl
VERILOG_DIR=$(ROOT)/verilog
QUARTUS_OUTPUT=$(ROOT)/quartus_output
MODELSIM_WORK_NAME=modelsim_lib
MODELSIM_WORK=$(ROOT)/$(MODELSIM_WORK_NAME)
MAKE_TARGETS=$(ROOT)/make
QUARTUS_DB=$(ROOT)/quartus/db
QUARTUS_IDB=$(ROOT)/quartus/incremental_db

ALTERA=/altera
MODELSIM=$(ALTERA)/modelsim_ase/linuxaloem
VLIB=$(MODELSIM)/vlib
VLOG=$(MODELSIM)/vlog
VSIM=$(MODELSIM)/vsim
QUARTUS=$(ALTERA)/quartus/bin
QUARTUS_SH=RTL_DIR=$(RTL_DIR) VERILOG_DIR=$(VERILOG_DIR) QUARTUS_OUTPUT=$(QUARTUS_OUTPUT) QUARTUS_DIR=$(QUARTUS_DIR) $(QUARTUS)/quartus_sh

all: sim_adc
# all: compile_verilog compile_rtl sim_tb_6502

help:
	@echo "To initialize the make system:"
	@echo "   make clean"
	@echo "To make a modelsim simulation, do"
	@echo "   make sim_adc"

clean:
	rm -rf $(MODELSIM_WORK) $(QUARTUS_OUTPUT) $(MAKE_TARGETS) $(QUARTUS_DB) $(QUARTUS_IDB)
	mkdir $(MAKE_TARGETS)
	$(VLIB) $(MODELSIM_WORK_NAME)

compile: $(MAKE_TARGETS)/compile_verilog $(MAKE_TARGETS)/compile_rtl

$(MAKE_TARGETS)/compile_verilog: verilog/*v
	($(VLOG) -work $(MODELSIM_WORK) $(VERILOG_DIR)/*v) && touch $(MAKE_TARGETS)/compile_verilog

$(MAKE_TARGETS)/compile_rtl: rtl/*v
	$(VLOG) -work $(MODELSIM_WORK) $(ALTERA)/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v
	$(VLOG) -work $(MODELSIM_WORK) $(ALTERA)/quartus/eda/sim_lib/cyclonev_atoms.v
	($(VLOG) -work $(MODELSIM_WORK) $(RTL_DIR)/*v) && touch $(MAKE_TARGETS)/compile_rtl

#sim_tb_6502: compile
#	$(VSIM) -batch tb_6502

sim_adc_gui: compile $(SCRIPTS_DIR)/regress.tcl
	./python/mif_to_hex.py mif/regression.base6502__Regress6502_Test6502_ALU__test_6502_adc.mif $(MODELSIM_WORK)/a.hex
	$(VSIM) -do 'source $(SCRIPTS_DIR)/regress.tcl' -l $(MODELSIM_WORK)/a.log -lib $(MODELSIM_WORK) harness_tb_6502

sim_adc: compile $(SCRIPTS_DIR)/regress.tcl
	./python/mif_to_hex.py mif/regression.base6502__Regress6502_Test6502_ALU__test_6502_adc.mif $(MODELSIM_WORK)/a.hex
	$(VSIM) -batch -nostdout -do 'source $(SCRIPTS_DIR)/regress.tcl' -l $(MODELSIM_WORK)/a.log -lib $(MODELSIM_WORK) harness_tb_6502
	@echo "Now check that b.mti has 0: 02 03 in it"
	grep ' 0: 02 03' $(MODELSIM_WORK)/b.mti

sim_addsub: compile $(SCRIPTS_DIR)/regress.tcl
	./python/mif_to_hex.py mif/regression.base6502__Regress6502_Test6502_ALU__test_6502_addsub.mif $(MODELSIM_WORK)/a.hex
	$(VSIM) -batch -nostdout -do 'source $(SCRIPTS_DIR)/regress.tcl' -l $(MODELSIM_WORK)/a.log -lib $(MODELSIM_WORK) harness_tb_6502
	@echo "Now check that b.mti has  0: 12 34 in it"
	grep ' 0: 12 34' $(MODELSIM_WORK)/b.mti

.PHONY:synth fit timing
synth: $(MAKE_TARGETS)/synth.complete

fit: $(MAKE_TARGETS)/fit.complete

timing: $(MAKE_TARGETS)/timing.complete

retime:
	rm -f $(MAKE_TARGETS)/timing.complete
	make timing

$(MAKE_TARGETS)/synth.complete: $(SCRIPTS_DIR)/synth.tcl
	(cd $(QUARTUS_DIR); $(QUARTUS_SH) -t $(SCRIPTS_DIR)/synth.tcl bbc_project bbc_project) && date > $(MAKE_TARGETS)/synth.complete

$(MAKE_TARGETS)/fit.complete: $(MAKE_TARGETS)/synth.complete
	(cd $(QUARTUS_DIR); $(QUARTUS_SH) -t $(SCRIPTS_DIR)/fit.tcl bbc_project bbc_project) && date > $(MAKE_TARGETS)/fit.complete

$(MAKE_TARGETS)/timing.complete: $(MAKE_TARGETS)/fit.complete
	(cd $(QUARTUS_DIR); $(QUARTUS_SH) -t $(SCRIPTS_DIR)/timing.tcl bbc_project bbc_project) && date > $(MAKE_TARGETS)/timing.complete

quartus_shell:
	$(QUARTUS_SH) -s

quartus_gui:
	(cd $(QUARTUS_DIR); $(QUARTUS_SH) -g)
