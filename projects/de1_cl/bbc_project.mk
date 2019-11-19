$(eval $(call sram.qmif_from_mif,16384,8,1,adfs.rom))
$(eval $(call sram.qmif_from_mif,16384,8,1,dfs.rom))
$(eval $(call sram.qmif_from_mif,16384,8,1,basic2.rom))
$(eval $(call sram.qmif_from_mif,16384,8,1,os12.rom))
$(eval $(call sram.qmif_from_mif,32768,32,0,elite))

bbc_rom_mif:
	(cd $(CDL_HARDWARE); make bbc_data roms)
	(cp $(CDL_HARDWARE)/roms/*mif ${MIF_DIR})

${MIF_DIR}/adfs.rom.mif:   bbc_rom_mif
${MIF_DIR}/dfs.rom.mif:    bbc_rom_mif
${MIF_DIR}/basic2.rom.mif: bbc_rom_mif
${MIF_DIR}/os12.rom.mif:   bbc_rom_mif

