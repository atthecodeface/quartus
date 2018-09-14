#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h"
#include "soc_cv_av/socal/alt_gpio.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

int main() {

	void *virtual_base;
    void *lw_axi_base;
	int fd;
	int loop_count;

	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}

    lw_axi_base        = (void *)(virtual_base + (ALT_LWFPGASLVS_OFST & HW_REGS_MASK));
	
    fprintf(stderr, "Alt_lwFPGA slave offst %08x\n", (uint32_t)ALT_LWFPGASLVS_OFST );
    fprintf(stderr, "HW_REGS_MASK %08x\n", (uint32_t)HW_REGS_MASK );
    fprintf(stderr, "lw_axi_base  %08x\n", (uint32_t)lw_axi_base );
	volatile uint32_t *timer_base;
	uint32_t *dprintf_address, *dprintf_address_c;
	uint32_t *dprintf_data,  *dprintf_data_c;
    // APB sel is 4;16 - if CSR then that must be 2, and CSR sel is 4;12
    timer_base        = (void *)(lw_axi_base + 0x00000);
    dprintf_address   = (void *)(lw_axi_base + 0x20000);
    dprintf_data      = (void *)(lw_axi_base + 0x20020);
    dprintf_address_c = (void *)(lw_axi_base + 0x20040);
    dprintf_data_c    = (void *)(lw_axi_base + 0x20060);

	loop_count = 0;
	while( loop_count < 60 ) {
		
		// control led
        uint32_t tim_val;
        tim_val = timer_base[0];
        dprintf_data[0] = 0x41424383;
        dprintf_data[1] = (loop_count<<16) | 0x2087;
        dprintf_data[2] = tim_val;
        dprintf_data[3] = 0xff000000;
        dprintf_address_c[0] = 40*10;

		// wait 100ms
		usleep( 100*1000 );
		
		// update led mask
        loop_count++;
		
	} // while
	

	// clean up our memory mapping and exit
	
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}
