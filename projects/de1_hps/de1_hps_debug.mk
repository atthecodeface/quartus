ELF_FILE ?= "__PLEASE__SPECIFY__AN__ELF__FILE"
BIT_FILE ?= "__PLEASE__SPECIFY__A_BIT__FILE"
MMI_FILE ?= "__PLEASE__SPECIFY__AN_MMI__FILE"

${MAKE_PREFIX}.quartus_parametrize: ${MAKE_PREFIX}.${PROJECT_LEAF}.parametrize

${MAKE_PREFIX}.${PROJECT_LEAF}.parametrize:
	${PARAMETRIZE_VERILOG} --file verilog/framebuffer_teletext.v  --module character_rom --parameter 'initfile="${SRAM_CONTENTS}/teletext.qmif"'
	${PARAMETRIZE_VERILOG} --file verilog/de1_hps_debug.v         --module apb_rom --parameter 'initfile="${SRAM_CONTENTS}/apb_vga_rom.qmif"'
	touch ${MAKE_PREFIX}.${PROJECT_LEAF}.parametrize

