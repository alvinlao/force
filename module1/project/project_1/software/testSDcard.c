#include <stdio.h>
#include "exception.h"

alt_up_pixel_buffer_dma_dev* initPixelBuffer();

alt_up_pixel_buffer_dma_dev* initPixelBuffer() {
	alt_up_pixel_buffer_dma_dev* pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/Pixel_Buffer_DMA");
	alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);
	return pixel_buffer;
}


int main(void) {
	// Set up interrupts
	//init_button_pio();

	alt_up_pixel_buffer_dma_dev* pixel_buffer = initPixelBuffer();
	ScreenShotInit(pixel_buffer);
	SaveBmpSDCARD();
	while (1) {

	}

	return 0;
}
