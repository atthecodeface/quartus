
ROOT:=$(CURDIR)
ROOT_REL:=.
RTL_DIR=$(ROOT)/rtl
VERILOG_DIR=$(ROOT)/verilog
SCRIPTS_DIR=$(ROOT)/scripts
PYTHON_DIR=$(ROOT)/python
MIF_DIR=$(ROOT)/mif
MAKE_TARGETS=$(ROOT)/make

ALTERA=/altera


all: sim_adc
# all: compile_verilog compile_rtl sim_tb_6502

help: help_synth he
	@echo "To initialize the make system:"
	@echo "   make clean"
	@echo "To make a modelsim simulation, do"
	@echo "   make sim_adc"

.PHONY: clean

clean:
	rm -rf $(MAKE_TARGETS)
	mkdir $(MAKE_TARGETS)

include $(SCRIPTS_DIR)/Makefile.sram
include $(SCRIPTS_DIR)/Makefile.sim
include $(SCRIPTS_DIR)/Makefile.synth
