#include "sys/alt_irq.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"

volatile int edge_capture;

static void init_button_pio(){
	void* edge_capture_ptr = (void*) &edge_capture;
	
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(BUTTON_PIO_BASE, 0xf);
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE, 0x0);
	alt_irq_resgister(BUTTON_PIO_IQR, edge_capture_ptr, hande_button_interrupts);
}

static void handle_button_interrupts(void* context, alt_u32 id){
	
	//cast the context pointer to an integer pointer
	volatile int* edge_capture_ptr = (volatile int*) context;
	
	//read the edge capture register on the button PIO and store value
	*edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE);
	
	//write to the edge caputer register to reset it
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE, 0);
	
	//reset interrupt capability for the button PIO
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(BUTTON_PIO_BASE, 0xf);
	
	//check which button was pressed
	if(*edge_capture_ptr == 1){
		// take screenshot
		SaveBmpSDCARD();
	}
	if(*edge_capture_ptr == 2){
		// do things
	}
	if(*edge_capture_ptr == 3){
		// do things
	}
	if(*edge_capture_ptr == 4){
		// do things
	}
}
