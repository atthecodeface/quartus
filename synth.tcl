load_package flow
help
#load_package design
post_message -type info "Stuff"
#set IMPORTED_PROJECT_NAME [ lindex $argv 0 ]
#set PR_SYNTH_REV [ lindex $argv 1 ]
#set PR_FIT_REV [ lindex $argv 2 ]
#project_open $prj_name -revision $synth_rev
project_open bbc_project
execute_module -tool syn
project_close
