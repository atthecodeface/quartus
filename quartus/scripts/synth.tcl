set PROJECT_NAME           [ lindex $argv 0 ]
set PROJECT_SYNTH_REVISION [ lindex $argv 1 ]

load_package flow

post_message -type info "Synthesizing project '$PROJECT_NAME' revision '$PROJECT_SYNTH_REVISION'"

project_open $PROJECT_NAME -revision $PROJECT_SYNTH_REVISION

execute_module -tool map

project_close
