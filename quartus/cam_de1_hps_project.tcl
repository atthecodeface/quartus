#a Environment import
global env
set RTL_DIR        $env(RTL_DIR)
set SRAMS_DIR      $env(SRAMS_DIR)
set VERILOG_DIR    $env(VERILOG_DIR)
set QUARTUS_OUTPUT $env(QUARTUS_OUTPUT)
set QUARTUS_DIR    $env(QUARTUS_DIR)

#a Source files
source pins.tcl
source hps.tcl
source de1.tcl
source cam_de1.tcl

puts "Sourced all files"
set_global_assignment -name VERILOG_FILE $RTL_DIR/cam_de1_hps_project.v

puts "Sourced verilog files"
set_global_assignment -name SDC_FILE $QUARTUS_DIR/cam_de1_hps_project.sdc

#a Set parameters (e.g. SRAMs)
set bbc_hier "bbc_micro\|bbc"
set io_hier "bbc_micro\|io"
#set_parameter -entity "bbc_project" -to "$bbc_hier\|bbc\|basic\|ram"               -name initfile $SRAMS_DIR/basic2.rom.qmif
#set_parameter -entity "bbc_project" -to "$bbc_hier\|bbc\|os\|ram"                  -name initfile $SRAMS_DIR/os12.rom.qmif
#set_parameter -entity "bbc_project" -to "$bbc_hier\|bbc\|adfs\|ram"                -name initfile $SRAMS_DIR/dfs.rom.qmif
#set_parameter -entity "bbc_project" -to "$bbc_hier\|floppy\|ram"                   -name initfile $SRAMS_DIR/elite.qmif
#set_parameter -entity "bbc_project" -to "$bbc_hier\|bbc\|saa\|character_rom\|ram"  -name initfile $SRAMS_DIR/teletext.qmif
#set_parameter -entity "bbc_project" -to "$io_hier\|ftb\|character_rom\|ram"        -name initfile $SRAMS_DIR/teletext.qmif
#set_parameter -entity "bbc_project" -to "$io_hier\|bbc_ps2_kbd\|kbd_map\|ram"      -name initfile $SRAMS_DIR/ps2_bbc_kbd.qmif
#set_parameter -entity "bbc_project" -to "$io_hier\|apb_rom\|ram"                   -name initfile $SRAMS_DIR/apb_rom.qmif


