open_hw
connect_hw_server
refresh_hw_server
get_hw_targets
open_hw_target [get_hw_targets]
create_hw_bitstream -hw_device [current_hw_device] $env(BIT_FILE)
program_hw_device
close_hw
