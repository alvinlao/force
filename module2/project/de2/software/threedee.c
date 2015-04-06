#include "sys/alt_stdio.h"
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"

#define blob_base (volatile int*) 0x00089400
#define piconnector_base (volatile int*) 0x00089480
unsigned int pixel_buffer_base_addr1;
unsigned int pixel_buffer_base_addr2;

volatile int edge_capture;


alt_up_pixel_buffer_dma_dev* pixel_buffer;

/*
 * Initialize the pixel buffer
 */
void initPixelBuffer() {
	pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/Pixel_Buffer_DMA");
	alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);
	// pixel_buffer_base_addr1 = PIXEL_BUFFER_BASE;
	// pixel_buffer_base_addr2 = PIXEL_BUFFER_BASE + 245760;

	// alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer,pixel_buffer_base_addr1);
	// alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer,pixel_buffer_base_addr2);
}

void swapBuffer(){
	alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
	while(alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));
}

void handle_button_interrupts(void* context, alt_u32 id){
	//cast the context pointer to an integer pointer
	volatile int* edge_capture_ptr = (volatile int*) context;
	
	//read the edge capture register on the button PIO and store value
	*edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE);

	//check which button was pressed
	if(*edge_capture_ptr == 0x2){
		// take screenshot
		printf("11111111111\n");
	} else if(*edge_capture_ptr == 0x4){
		printf("22222222222222\n");
	} else if(*edge_capture_ptr == 0x8){
		printf("333333333333333\n");
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



void SendData(long data){
	IOWR_32DIRECT(piconnector_base, 0, data);
	printf("sending %8x \n", data);
}

int main()
{
	initPixelBuffer();
	init_button_pio();
	
	printf("letsgo");
	while(1){
		IOWR_32DIRECT(blob_base, 0, 0xffffffff);
		int ready;
		do {
			ready = IORD_32DIRECT(blob_base, 0);
		} while(!ready);

		int ch1 = IORD_32DIRECT(blob_base, 4);
		int ch1x = (ch1>>16) & 0x1ff;
		int ch1y = (ch1>>8) & 0xff;

		int ch2 = IORD_32DIRECT(blob_base, 8);
		int ch2x = (ch2>>16) & 0x1ff;
		int ch2y = (ch2>>8) & 0xff;

		printf("ch1: (%3d, %3d)    ch2: (%3d,%3d)\n",ch1x,ch1y,ch2x,ch2y);
		SendData(ch1);
		SendData(ch2 | 0x80000000);
	}

  return 0;
}
