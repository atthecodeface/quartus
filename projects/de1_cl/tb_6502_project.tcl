#a Environment import
global env
set RTL_DIR        $env(RTL_DIR)
set SRAMS_DIR      $env(SRAMS_DIR)
set VERILOG_DIR    $env(VERILOG_DIR)
set QUARTUS_OUTPUT $env(QUARTUS_OUTPUT)
set QUARTUS_DIR    $env(QUARTUS_DIR)

#a Command notes
#b quartus_sh TCL commands
#   -------------
#   Tcl Commands:
#   -------------
#   
#   	assignment_group
#   	create_revision
#   	delete_revision
#   	execute_assignment_batch
#   	export_assignments
#   	get_all_assignment_names
#   	get_all_assignments
#   	get_all_global_assignments
#   	get_all_instance_assignments
#   	get_all_parameters
#   	get_all_quartus_defaults
#   	get_all_user_option_names
#   	get_assignment_info
#   	get_assignment_name_info
#   	get_current_project
#   	get_current_revision
#   	get_database_version
#   	get_global_assignment
#   	get_instance_assignment
#   	get_location_assignment
#   	get_name_info
#   	get_names
#   	get_parameter
#   	get_project_directory
#   	get_project_revisions
#   	get_top_level_entity
#   	get_user_option
#   	is_database_version_compatible
#   	is_fitter_in_qhd_mode
#   	is_project_open
#   	project_archive
#   	project_clean
#   	project_close
#   	project_exists
#   	project_new
#   	project_open
#   	project_restore
#   	remove_all_global_assignments
#   	remove_all_instance_assignments
#   	remove_all_parameters
#   	resolve_file_path
#   	revision_exists
#   	set_current_revision
#   	set_global_assignment
#   	set_high_effort_fmax_optimization_assignments
#   	set_instance_assignment
#   	set_io_assignment
#   	set_location_assignment
#   	set_parameter
#   	set_power_file_assignment
#   	set_user_option
#   	test_assignment_trait

#b set_instance_assignment
#   tcl> set_instance_assignment -long_help
#   ---------------------------------------------------------------------------
#   
#   Usage: set_instance_assignment [-h | -help] [-long_help] [-comment <comment>] [-disable] [-entity <entity_name>] [-fall] [-from <source>] -name <name> [-remove] [-rise] [-section_id <section id>] [-tag <data>] [-to <destination>] [<value>]
#   
#           -h | -help: Short help
#           -long_help: Long help with examples and possible return values
#   
#           -comment <comment>: Comment
#           -disable: Option to disable assignment
#           -entity <entity_name>: Entity to which to add assignment
#           -fall: Option applies to falling edge
#           -from <source>: Source of assignment
#           -name <name>: Assignment name
#           -remove: Option to remove assignment
#           -rise: Option applies to rising edge
#           -section_id <section id>: Section id
#           -tag <data>: Option to tag data to this assignment
#           -to <destination>: Destination of assignment
#           <value>: Assignment value
#   
#   ------------------------
#   Tcl Package and Version:
#   ------------------------
#   
#   Belongs to ::quartus::project 6.0
#   
#   ------------
#   Description:
#   ------------
#   
#   Sets or removes an instance assignment.
#   
#   Assignments created or modified by using this Tcl command are
#   not saved to the Quartus II Settings File (.qsf) unless you
#   explicitly call one of the following two Tcl commands:
#   
#   1) export_assignments
#   2) project_close (unless "-dont_export_assignments" is specified)
#   
#   These two Tcl commands reside in the ::quartus::project Tcl
#   package. You must save assignment changes before you run
#   Quartus(R) II command-line executables. Note, however, that
#   the Tcl commands "execute_flow" and "execute_module" (part
#   of the ::quartus::flow Tcl package) automatically call
#   "export_assignments" before they run command-line executables.
#   
#   For entity-specific assignments, use the "-entity" option to
#   force the assignment to specified entity. If the "-entity"
#   option is not specified, the value for the FOCUS_ENTITY_NAME
#   assignment is used. If the FOCUS_ENTITY_NAME value is not found,
#   the revision name is used.
#   
#   --------------
#   Example Usage:
#   --------------
#   
#   ## Specify a TSU_REQUIREMENT of 2ns from mypin to any register
#   set_instance_assignment -from "mypin" -to * -name TSU_REQUIREMENT 2ns
#   
#   ## Remove the TSU_REQUIREMENT from mypin to all registers
#   set_instance_assignment -from "mypin" -to * -name TSU_REQUIREMENT -remove
#   
#   ## Specify the entity to which the assignment is added,
#   ## use the -entity option
#   ## This is needed if the top-level entity name is other than
#   ## that of the project name
#   ## The following command generates a top_level entity
#   set_instance_assignment -from "mypin" -to * -entity top_level -name TSU_REQUIREMENT 2ns

#b set_io_assignment
#   tcl> set_io_assignment -long_help
#   ---------------------------------------------------------------------------
#   
#   Usage: set_io_assignment [-h | -help] [-long_help] [-comment <comment>] [-disable] [-fall] [-io_standard <io standard>] -name <name> [-remove] [-rise] [-tag <data>] [<value>]
#   
#           -h | -help: Short help
#           -long_help: Long help with examples and possible return values
#   
#           -comment <comment>: Comment
#           -disable: Option to disable assignment
#           -fall: Option applies to falling edge
#           -io_standard <io standard>: Option to specify the io standard
#           -name <name>: Assignment name
#           -remove: Option to remove assignment
#           -rise: Option applies to rising edge
#           -tag <data>: Option to tag data to this assignment
#           <value>: Assignment value
#   
#   ------------------------
#   Tcl Package and Version:
#   ------------------------
#   
#   Belongs to ::quartus::project 6.0
#   
#   ------------
#   Description:
#   ------------
#   
#   Sets or removes an io assignment.
#   
#   Assignments created or modified by using this Tcl command are
#   not saved to the Quartus II Settings File (.qsf) unless you
#   explicitly call one of the following two Tcl commands:
#   
#   1) export_assignments
#   2) project_close (unless "-dont_export_assignments" is specified)
#   
#   These two Tcl commands reside in the ::quartus::project Tcl
#   package. You must save assignment changes before you run
#   Quartus(R) II command-line executables. Note, however, that
#   the Tcl commands "execute_flow" and "execute_module" (part
#   of the ::quartus::flow Tcl package) automatically call
#   "export_assignments" before they run command-line executables.
#   
#   --------------
#   Example Usage:
#   --------------
#   
#   ## Specify LVTTL as the IO Standard for OUTPUT_PIN_LOAD assignment
#   set_io_assignment 30 -name OUTPUT_PIN_LOAD -io_standard LVTTL

#b set_global_assignment
#   tcl> set_global_assignment -long_help
#   ---------------------------------------------------------------------------
#   
#   Usage: set_global_assignment [-h | -help] [-long_help] [-comment <comment>] [-disable] [-entity <entity_name>] [-fall] -name <name> [-remove] [-rise] [-section_id <section id>] [-tag <data>] [<value>]
#   
#           -h | -help: Short help
#           -long_help: Long help with examples and possible return values
#   
#           -comment <comment>: Comment
#           -disable: Option to disable assignment
#           -entity <entity_name>: Entity to which to add assignment
#           -fall: Option applies to falling edge
#           -name <name>: Assignment name
#           -remove: Option to remove assignment
#           -rise: Option applies to rising edge
#           -section_id <section id>: Section id
#           -tag <data>: Option to tag data to this assignment
#           <value>: Assignment value
#   
#   ------------------------
#   Tcl Package and Version:
#   ------------------------
#   
#   Belongs to ::quartus::project 6.0
#   
#   ------------
#   Description:
#   ------------
#   
#   Sets or removes a global assignment.
#   
#   Assignments created or modified by using this Tcl command are not
#   saved to the Quartus II Settings File (.qsf) unless you explicitly
#   call one of the following two Tcl commands (from the
#   ::quartus::project Tcl package):
#   
#   1) export_assignments
#   2) project_close (unless -dont_export_assignments is specified as an
#   argument to project_close)
#   
#   You must save assignment changes before you run Quartus(R) II
#   command-line executables. Note, however, that the Tcl commands
#   execute_flow and execute_module (from the ::quartus::flow Tcl
#   package) call "export_assignments" before they run
#   command-line executables.
#   
#   For entity-specific assignments, use the -entity option to force the
#   assignment to specified entity. If the -entity option is not
#   specified, the value for the FOCUS_ENTITY_NAME assignment is used. If
#   the FOCUS_ENTITY_NAME value is not found, the revision name is used.
#   
#   If the Quartus II Settings File contains a USER_LIBRARIES assignment
#   and you call set_global_assignment to set a SEARCH_PATH or
#   USER_LIBRARIES assignment, the existing USER_LIBRARIES assignment
#   expands into one or more SEARCH_PATH assignments.
#   
#   Note that values that begin with a dash ("-") should be enclosed in a
#   backslash followed by a quote. In the following example, -02 is
#   enclosed by \" at the beginning and the end.
#   
#   set_global_assignment -name ARM_CPP_COMMAND_LINE \"-O2\"
#   
#   --------------
#   Example Usage:
#   --------------
#   
#   ## Specify Stratix as the family to use when compiling
#   set_global_assignment -name FAMILY Stratix
#   
#   ## If the family name has empty spaces, use quotes
#   set_global_assignment -name FAMILY "Stratix GX"
#   
#   ## or remove any empty space
#   set_global_assignment -name FAMILY StratixGX

#b set_location_assignment
#   tcl> set_location_assignment -long_help
#   ---------------------------------------------------------------------------
#   
#   Usage: set_location_assignment [-h | -help] [-long_help] [-comment <comment>] [-disable] [-fall] [-remove] [-rise] [-tag <data>] -to <destination> [<value>]
#   
#           -h | -help: Short help
#           -long_help: Long help with examples and possible return values
#   
#           -comment <comment>: Comment
#           -disable: Option to disable assignment
#           -fall: Option applies to falling edge
#           -remove: Option to remove assignment
#           -rise: Option applies to rising edge
#           -tag <data>: Option to tag data to this assignment
#           -to <destination>: Destination of assignment
#           <value>: Assignment value
#   
#   ------------------------
#   Tcl Package and Version:
#   ------------------------
#   
#   Belongs to ::quartus::project 6.0
#   
#   ------------
#   Description:
#   ------------
#   
#   Sets or removes a location assignment.
#   
#                   Valid location assignments, and settings for those
#                   assignments for your design are determined by the
#                   target device, package type, and pin count.
#   
#                   To explore possible assignments and settings for your
#                   design and device, in the Quartus II Assignment
#                   Editor, specify Location for Assignment Name, and then
#                   click Browse in the Value column. In the Location
#                   dialog box, explore assignable device resources in the
#                   Element list, and then use the lists that appear
#                   (based on the element selected) to determine locations
#                   of resources that can be specified as the value for
#                   the assignment.
#   
#   Valid locations are pin locations, I/O bank locations, or edge locations. Pin locations include pin names,
#   such as PIN_A3. I/O bank locations include IOBANK_1 up to IOBANK_ n, where n is the number of I/O
#   banks in the device.
#   Use one of the following valid edge location values:
#   * EDGE_BOTTOM
#   * EDGE_LEFT
#   * EDGE_TOP
#   * EDGE_RIGHT
#
#   Assignments created or modified by using this Tcl
#   command are not saved to the Quartus II Settings File
#   (.qsf) unless you explicitly call one of the following
#   two Tcl commands:
#   
#   1) export_assignments
#   
#                   2) project_close (unless "-dont_export_assignments" is
#                   specified)
#   
#   These two Tcl commands reside in the
#   ::quartus::project Tcl package. You must save
#   assignment changes before you run Quartus(R) II
#   command-line executables. Note, however, that the Tcl
#   commands "execute_flow" and "execute_module" (part of
#   the ::quartus::flow Tcl package) automatically call
#   "export_assignments" before they run command-line
#   executables.
#   
#   --------------
#   Example Usage:
#   --------------
#   
#   set_location_assignment -to dst LOC
#
# other examples:
#   set_location_assignment PIN_P2 -to clk2
#   set_location_assignment PIN_AE4 -to ticket[0]
#   set_location_assignment PIN_J23 -to ticket[2]
#   set_location_assignment PIN_Y12 -to timeo[1]
#   set_location_assignment PIN_N2 -to reset

#b Setting up I/O
#   set_location_assignment PIN M20 -to address[10]
#   set_instance_assignment -name IO_STANDARD "2.5 V" -to address[10]
#   set_instance_assignment -name CURRENT_STRENGTH_NEW "MAXIMUM CURRENT" -to address[10]
#   set_instance_assignment -name SLEW_RATE 2 -to e[0]
#
# Can one use:
# PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING (ON)
# PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION (ON)

#a Project globals
set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE 5CSEMA5F31C6
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 15.0.0
set_global_assignment -name PROJECT_CREATION_TIME_DATE "15:24:28  FEBRUARY 04, 2017"
set_global_assignment -name LAST_QUARTUS_VERSION 15.0.0
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY $QUARTUS_OUTPUT
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

#a Project files
# add_file altclkctrl/synthesis/altclkctrl.qip SYNTHESIS
# set_global_assignment -name QIP_FILE altclkctrl/synthesis/altclkctrl.qip
set_global_assignment -name VERILOG_FILE $RTL_DIR/tb_6502_project.v
set_global_assignment -name VERILOG_FILE $RTL_DIR/srams.v
set_global_assignment -name VERILOG_FILE $RTL_DIR/clock_gate_module.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/tb_6502.v
set_global_assignment -name VERILOG_FILE $VERILOG_DIR/cpu6502.v


set_global_assignment -name TOP_LEVEL_ENTITY tb_6502_project

set_global_assignment -name SDC_FILE $QUARTUS_DIR/tb_6502_project.sdc

#a Set parameters (e.g. SRAMs)
set_parameter -to "imem" -entity "tb_6502_project" -name initfile $SRAMS_DIR/b.mif
