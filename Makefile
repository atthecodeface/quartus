
ROOT              ?= $(CURDIR)
ROOT_REL          ?= .
RTL_DIR           ?= $(ROOT)/rtl
VERILOG_DIR       ?= $(ROOT)/verilog
SCRIPTS_DIR       ?= $(ROOT)/scripts
PYTHON_DIR        ?= $(ROOT)/python
MIF_DIR           ?= $(ROOT)/mif
MAKE_TARGETS      ?= $(ROOT)/make
SRAM_CONTENTS     ?= $(ROOT)/sram_contents

ALTERA=/altera

H=@echo

all: sim_adc
# all: compile_verilog compile_rtl sim_tb_6502

.PHONY: help
help: help_toplevel help_synth help_sim help_sram

.PHONY: help_toplevel
help_toplevel:
	$H
	$H "****************************************************************"
	$H "To initialize the make system"
	$H "****************************************************************"
	$H "   make clean"
	$H
	$H "****************************************************************"
	$H "To regenerate the modules from qsys (on repo init or change of qsys)"
	$H "****************************************************************"
	$H "   make regnerate_modules"
	$H
	$H "The Makefile splits into a few sub-makes:"
	$H " Makefile.sim"
	$H "   Simulation makefile, with its own help (below)"
	$H " Makefile.synth"
	$H "   Synthesis, fit, timing makefile, with its own help (below)"
	$H " Makefile.sram"
	$H "   SRAM generation makefile, with its own help (below)"

.PHONY: clean

clean:
	rm -rf $(MAKE_TARGETS)
	mkdir $(MAKE_TARGETS)

include $(SCRIPTS_DIR)/Makefile.sram
include $(SCRIPTS_DIR)/Makefile.sim
include $(SCRIPTS_DIR)/Makefile.synth
