global env
source $env(QUARTUS_SCRIPTS_DIR)/env.tcl

load_package flow

post_message -type info "Asm project '$project_file' revision '$PROJECT_SYNTH_REVISION'"

project_open $project_file -revision $PROJECT_SYNTH_REVISION

execute_module -tool asm

project_close
