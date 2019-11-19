global env
source $env(QUARTUS_SCRIPTS_DIR)/env.tcl

load_package flow

post_message -type info "Static timing analysis for project '$project_file' revision '$PROJECT_SYNTH_REVISION'"

project_open $project_file -revision $PROJECT_SYNTH_REVISION

execute_module -tool sta

project_close
