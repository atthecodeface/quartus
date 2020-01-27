ELF_FILE ?= "__PLEASE__SPECIFY__AN__ELF__FILE"
BIT_FILE ?= "__PLEASE__SPECIFY__A_BIT__FILE"
MMI_FILE ?= "__PLEASE__SPECIFY__AN_MMI__FILE"

# Note
# make BIT_FILE=/vm_shared/vm_read_only/golden_bit/vcu108_riscv.191022-110940.bit ELF_FILE=/git/atcf_riscv_rust/target/riscv32imc-unknown-none-elf/release/microos MMI_FILE=/vm_shared/vm_read_only/golden_bit/riscv.191022-111936.mmi  PROJECT=vcu108/riscv/vcu108_riscv update_bootrom
# BIT_FILE=vivado_output/reprogrammed.bit  vivado -mode batch -source vivado/scripts/program.tcl

${MAKE_PREFIX}.vivado_parametrize: ${MAKE_PREFIX}.${PROJECT_LEAF}.parametrize

mmi: ${VIVADO_OUTPUT}/riscv.mmi

RAM := dut/riscv/mem
${VIVADO_OUTPUT}/riscv.mmi: ${VIVADO_OUTPUT}/${PROJECT_LEAF}__bram_dict.py 
	$(VIVADO_DIR)/scripts/create_mmi.py --py ${VIVADO_OUTPUT}/${PROJECT_LEAF}__bram_dict.py --ram ${RAM} --subpath '' --out ${VIVADO_OUTPUT}/riscv.mmi
	cp $(VIVADO_OUTPUT)/riscv.mmi golden_bit/riscv.`date +%y%m%d-%H%M%S`.mmi

.PHONY: update_bootrom
update_bootrom:
	rm -f link_to_elf.elf
	ln -s ${ELF_FILE} link_to_elf.elf
	${VIVADO_BIN}/updatemem --force  --proc ${RAM} --meminfo ${MMI_FILE} --data link_to_elf.elf --bit ${BIT_FILE} --out ${VIVADO_OUTPUT}/reprogrammed.bit
	rm -f link_to_elf.elf
	#cp $(VIVADO_OUTPUT)/$(PROJECT_LEAF).programmed.bit golden_bit/$(PROJECT_LEAF).`date +%y%m%d-%H%M%S`.bit

.PHONY: rv_boot_rom
rv_boot_rom: ${PROJECT_DIR}/rv_boot_rom

${PROJECT_DIR}/rv_boot_rom: ${ELF_FILE}
	${CDL_PYTHON_ENV} ${CDL_PYTHON_DIR}/dump.py --load_elf ${ELF_FILE} --mem ${PROJECT_DIR}/rv_boot_rom

${MAKE_PREFIX}.${PROJECT_LEAF}.parametrize:
	${PARAMETRIZE_VERILOG} --file verilog/framebuffer_teletext.v  --module character_rom --parameter 'initfile="teletext"'
	${PARAMETRIZE_VERILOG} --file verilog/subsys_minimal.v        --module apb_rom --parameter 'initfile="apb_rom"'
	${PARAMETRIZE_VERILOG} --file verilog/vcu108_debug.v          --module apb_rom --parameter 'initfile="apb_rom"'
	${PARAMETRIZE_VERILOG} --file verilog/riscv_i32_minimal.v     --module mem     --type bram__se_sram_srw_16384x32_we8
	${PARAMETRIZE_VERILOG} --file verilog/riscv_i32_minimal3.v    --module mem     --type bram__se_sram_srw_16384x32_we8
	touch ${MAKE_PREFIX}.${PROJECT_LEAF}.parametrize

