ELF_FILE = "__PLEASE__SPECIFY__AN__ELF__FILE"
BIT_FILE = "__PLEASE__SPECIFY__A_BIT__FILE"

${MAKE_PREFIX}.vivado_parametrize: ${MAKE_PREFIX}.${PROJECT_LEAF}.parametrize

${VIVADO_OUTPUT}/riscv.mmi:
	$(VIVADO_DIR)/scripts/create_mmi.py --py ${VIVADO_OUTPUT}/${PROJECT_LEAF}__bram_dict.py --ram dut/riscv/mem --subpath '' --out ${VIVADO_OUTPUT}/riscv.mmi

update_bootrom: ${VIVADO_OUTPUT}/riscv.mmi
	rm -f link_to_elf.elf
	ln -s ${ELF_FILE} link_to_elf.elf
	${VIVADO_BIN}/updatemem --force  --proc dut/riscv/mem --meminfo ${VIVADO_OUTPUT}/riscv.mmi --data link_to_elf.elf --bit ${BIT_FILE} --out ${VIVADO_OUTPUT}/reprogrammed.bit
	rm -f link_to_elf.elf
	#cp $(VIVADO_OUTPUT)/$(PROJECT_LEAF).programmed.bit golden_bit/$(PROJECT_LEAF).`date +%y%m%d-%H%M%S`.bit

.PHONY: rv_boot_rom
rv_boot_rom: ${PROJECT_DIR}/rv_boot_rom

${PROJECT_DIR}/rv_boot_rom: ${ELF_FILE}
	${CDL_PYTHON_ENV} ${CDL_PYTHON_DIR}/dump.py --load_elf ${ELF_FILE} --mem ${PROJECT_DIR}/rv_boot_rom

${MAKE_PREFIX}.${PROJECT_LEAF}.parametrize:
	${PARAMETRIZE_VERILOG} --file verilog/framebuffer_teletext.v  --module character_rom --parameter 'initfile="teletext"'
	${PARAMETRIZE_VERILOG} --file verilog/vcu108_riscv.v          --module apb_rom --parameter 'initfile="apb_rom"'
	${PARAMETRIZE_VERILOG} --file verilog/vcu108_debug.v          --module apb_rom --parameter 'initfile="apb_rom"'
	${PARAMETRIZE_VERILOG} --file verilog/riscv_i32_minimal.v     --module mem     --type bram__se_sram_srw_16384x32_we8
	touch ${MAKE_PREFIX}.${PROJECT_LEAF}.parametrize

