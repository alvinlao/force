#include "exception.h"

volatile int edge_capture;

void handle_button_interrupts(void* context, alt_u32 id){
	//cast the context pointer to an integer pointer
	volatile int* edge_capture_ptr = (volatile int*) context;
	
	//read the edge capture register on the button PIO and store value
	*edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE);

	//check which button was pressed
	if(*edge_capture_ptr == 0x2){
		// take screenshot
		printf("Screenshot started.\n");
		SaveBmpSDCARD();
		printf("Screenshot finished.\n");
		printf("Screenshot taken.\n");
	} else if(*edge_capture_ptr == 0x4){
		RayTurnOnOff();
		printf("Ray turned on/off.\n");
	} else if(*edge_capture_ptr == 0x8){
		ChangeRayColor();
		printf("Ray colour changed.\n");
	} else {
		printf("Something pressed.\n");
	}

	//write to the edge capture register to reset it
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE, 0);
}

void init_button_pio(){
	volatile void* edge_capture_ptr = (void*) &edge_capture;

	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(BUTTON_PIO_BASE, 0xf);
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE, 0x0);
	alt_irq_register(BUTTON_PIO_IRQ, edge_capture_ptr, handle_button_interrupts);
}
