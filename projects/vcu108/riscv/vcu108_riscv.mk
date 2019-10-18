ELF_FILE = "__PLEASE__SPECIFY__AN__ELF__FILE"
update_bootrom:
	$(VIVADO_DIR)/scripts/create_mmi.py --py ${VIVADO_OUTPUT}/${PROJECT_LEAF}__bram_dict.py --ram dut/riscv/mem --out ${VIVADO_OUTPUT}/riscv.mmi
	${VIVADO_BIN}/updatemem --force  --proc dut/riscv/mem --meminfo ${VIVADO_OUTPUT}/riscv.mmi --data ${ELF_FILE} --bit ${VIVADO_OUTPUT}/${PROJECT_LEAF}.bit --out ${VIVADO_OUTPUT}/${PROJECT_LEAF}.programmed.bit

${MAKE_PREFIX}.vivado_parametrize: ${PROJECT_DIR}/rv_boot_rom

.PHONY: rv_boot_rom
rv_boot_rom: ${PROJECT_DIR}/rv_boot_rom

${PROJECT_DIR}/rv_boot_rom: ${ELF_FILE}
	${CDL_PYTHON_ENV} ${CDL_PYTHON_DIR}/dump.py --load_elf ${ELF_FILE} --mem ${PROJECT_DIR}/rv_boot_rom
