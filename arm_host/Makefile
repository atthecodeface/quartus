#
TARGET = ../new

#
CROSS_COMPILE = /soc_eds/DS-5/sw/gcc/bin/arm-linux-gnueabihf-
SOCEDS_DEST_ROOT = /soc_eds/embedded
CFLAGS = -static -g -Wall  -I${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include
LDFLAGS =  -g -Wall  
CC = $(CROSS_COMPILE)gcc
ARCH= arm

copy_out: ${TARGET}
	scp ${TARGET} gavinprivate@10.1.17.75:

build: $(TARGET)
$(TARGET): main.o hps_fpga.o
	$(CC) $(LDFLAGS)   $^ -o $@  
%.o : src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~ 
