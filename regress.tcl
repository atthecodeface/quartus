echo "Starting"
mem load -format hex -infile a.hex /harness_tb_6502/tb/imem/ram
echo "Running"
run 1000000ns
echo "Done running, saving memory"
mem save    -addressradix h -dataradix h -startaddress 0 -endaddress 600 -outfile b.mti /harness_tb_6502/tb/imem/ram
echo "Quit"
quit
