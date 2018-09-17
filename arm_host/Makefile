#
BIN = bin

BINS  = ${BIN}/run_riscv
BINS += ${BIN}/peek
BINS += ${BIN}/poke

#
CROSS_COMPILE = /soc_eds/DS-5/sw/gcc/bin/arm-linux-gnueabihf-
SOCEDS_DEST_ROOT = /soc_eds/embedded
CFLAGS = -static -g -Wall  -I${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include
LDFLAGS =  -g -Wall  
CC = $(CROSS_COMPILE)gcc
ARCH= arm

copy_out: ${BINS}
	scp -r ${BINS} gavinprivate@10.1.17.75:arm_host_bin

build: ${BINS}

${BIN}/run_riscv: main.o hps_fpga.o
	$(CC) $(LDFLAGS)   $^ -o $@  

${BIN}/peek: peek.o hps_fpga.o
	$(CC) $(LDFLAGS)   $^ -o $@  

${BIN}/poke: poke.o hps_fpga.o
	$(CC) $(LDFLAGS)   $^ -o $@  

%.o : src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 
