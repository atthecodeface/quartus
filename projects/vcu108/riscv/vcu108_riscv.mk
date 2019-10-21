ELF_FILE = "__PLEASE__SPECIFY__AN__ELF__FILE"
update_bootrom:
	$(VIVADO_DIR)/scripts/create_mmi.py --py ${VIVADO_OUTPUT}/${PROJECT_LEAF}__bram_dict.py --ram dut/riscv/mem --subpath '' --out ${VIVADO_OUTPUT}/riscv.mmi
	rm -f link_to_elf.elf
	ln -s ${ELF_FILE} link_to_elf.elf
	${VIVADO_BIN}/updatemem --force  --proc dut/riscv/mem --meminfo ${VIVADO_OUTPUT}/riscv.mmi --data link_to_elf.elf --bit ${VIVADO_OUTPUT}/${PROJECT_LEAF}.bit --out ${VIVADO_OUTPUT}/${PROJECT_LEAF}.programmed.bit
	rm -f link_to_elf.elf
	cp $(VIVADO_OUTPUT)/$(PROJECT_LEAF).programmed.bit golden_bit/$(PROJECT_LEAF).`date +%y%m%d-%H%M%S`.bit

${MAKE_PREFIX}.vivado_parametrize: ${PROJECT_DIR}/rv_boot_rom

.PHONY: rv_boot_rom
rv_boot_rom: ${PROJECT_DIR}/rv_boot_rom

${PROJECT_DIR}/rv_boot_rom: ${ELF_FILE}
	${CDL_PYTHON_ENV} ${CDL_PYTHON_DIR}/dump.py --load_elf ${ELF_FILE} --mem ${PROJECT_DIR}/rv_boot_rom
