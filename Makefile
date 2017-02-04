
MODELSIM=/altera/modelsim_ase/linuxaloem
VLIB=$(MODELSIM)/vlib
VLOG=$(MODELSIM)/vlog
VSIM=$(MODELSIM)/vsim

all: sim_tb_6502
# all: compile_verilog compile_rtl sim_tb_6502

clean:
	rm -rf work
	$(VLIB) work

compile_verilog: verilog/*v
	($(VLOG) verilog/*v) && touch compile_verilog

compile_rtl: rtl/*v
	($(VLOG) rtl/*v) && touch compile_rtl

sim_tb_6502: compile_verilog compile_rtl
	$(VSIM) -batch tb_6502

sim_adc: compile_verilog compile_rtl
	./python/mif_to_hex.py mif/regression.base6502__Regress6502_Test6502_ALU__test_6502_adc.mif a.hex
	$(VSIM) -batch -nostdout -do 'source regress.tcl' -l a.log harness_tb_6502
	@echo "Now check that b.mti has 0: 02 03 in it"
	grep ' 0: 02 03' b.mti

sim_addsub: compile_verilog compile_rtl
	./python/mif_to_hex.py mif/regression.base6502__Regress6502_Test6502_ALU__test_6502_addsub.mif a.hex
	$(VSIM) -batch -nostdout -do 'source regress.tcl' -l a.log harness_tb_6502
	@echo "Now check that b.mti has  0: 12 34 in it"
	grep ' 0: 12 34' b.mti

# ./python/mif_to_hex.py mif/regression.base6502__Regress6502_Test6502_ALU__test_6502_adc.mif a.hex
# ./python/mif_to_hex.py mif/regression.base6502__Regress6502_Test6502_ALU__test_6502_addsub.mif a.hex
# mem display /tb_6502/imem/ram
# mem load -format mti -infile mif/regression.base6502__Regress6502_Test6502_ALU__test_6502_addsub.mif /tb_6502/imem/ram
# mem load -format mti -infile a.mti /tb_6502/imem/ram
# mem display -startaddress 512 -endaddress 600 /tb_6502/imem/ram
# mem save -addressradix h -dataradix h -startaddress 512 -endaddress 600 -outfile b.mti /tb_6502/imem/ram
# mem save -format mti -addressradix h -dataradix h -startaddress 512 -endaddress 600 -outfile b.mti /tb_6502/imem/ram
#mem load -format mti -infile b.mti /tb_6502/imem/ram
#mem display -addressradix h -dataradix h -startaddress 512 -endaddress 600 /tb_6502/imem/ram
#mem load -format hex -infile b.mti /tb_6502/imem/ram
#mem display -addressradix h -dataradix h -startaddress 0 -endaddress 100 /tb_6502/imem/ram
#mem load -format hex -infile mif/regression.base6502__Regress6502_Test6502_ALU__test_6502_adc.mif.hex /tb_6502/imem/ram
