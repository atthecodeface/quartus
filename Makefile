# make PROJECT=vcu108/riscv/vcu108_riscv ELF_FILE=/git/atcf_riscv_rust/target/riscv32imc-unknown-none-elf/release/microos clean vivado_report vivado_bitstream
ROOT              ?= $(CURDIR)
ROOT_REL          ?= .
RTL_DIR           ?= $(ROOT)/rtl
VERILOG_DIR       ?= $(ROOT)/verilog
SCRIPTS_DIR       ?= $(ROOT)/scripts
PYTHON_DIR        ?= $(ROOT)/python
MIF_DIR           ?= $(ROOT)/mif
MAKE_TARGETS      ?= $(ROOT)/make
SRAM_CONTENTS     ?= $(ROOT)/sram_contents

CDL_HARDWARE      ?= $(ROOT)/../cdl_hardware

CDL_PYTHON_DIR    := ${CDL_HARDWARE}/python
CDL_PYTHON_ENV    := PYTHONPATH=${CDL_HARDWARE}/python:${PYTHONPATH}

H=@echo

all: sim_adc
# all: compile_verilog compile_rtl sim_tb_6502

.PHONY: help
help: help_toplevel help_quartus help_vivado help_sim help_sram

.PHONY: help_toplevel
help_toplevel:
	$H
	$H "****************************************************************"
	$H "To initialize the make system"
	$H "****************************************************************"
	$H "   make clean"
	$H
	$H "The Makefile splits into a few sub-makes:"
	$H " Makefile.verilog"
	$H "   Create verilog files from CDL and SRAMs for FPGAs from descriptions"
	$H " Makefile.sim"
	$H "   Simulation makefile, with its own help (below)"
	$H " Makefile.quartus"
	$H "   Quartus synthesis, fit, timing makefile, with its own help (below)"
	$H " Makefile.vivado"
	$H "   Vivado synthesis, place, route, reports makefile, with its own help (below)"
	$H " Makefile.sram"
	$H "   SRAM generation makefile, with its own help (below)"
	$H
	$H "Projects available:"
	$H "  de1_cl/bbc_project        - working (if you have the ROMs)        (synth fit)"
	$H "  de1_hps/hps_debug         - working (needs HPS modules generated) (synth pins fit)"
	$H "  de1_cl_hps/hps_fpga_debug - working (needs HPS modules generated) (synth pins fit)"
	$H "  vcu108/basic              - working"
	$H "  vcu108/basic_pll          - working"
	$H "  vcu108/riscv/vcu108_riscv - working"
	$H "  vcu108/riscv/vcu108_riscv_3 - in progress"

.PHONY: clean

clean:
	rm -rf $(MAKE_TARGETS)
	mkdir $(MAKE_TARGETS)

include $(SCRIPTS_DIR)/Makefile.project
include $(SCRIPTS_DIR)/Makefile.sram
include $(SCRIPTS_DIR)/Makefile.sim
include $(SCRIPTS_DIR)/Makefile.verilog
include $(SCRIPTS_DIR)/Makefile.quartus
include $(SCRIPTS_DIR)/Makefile.vivado

ifneq ($(PROJECT_INCLUDE),)
-include ${PROJECT_INCLUDE}
endif
