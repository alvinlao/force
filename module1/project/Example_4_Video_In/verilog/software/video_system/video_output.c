#include "sys/alt_stdio.h"
//#include <stdio.h>
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <unistd.h>
#define drawer_base (volatile int *) 0x0000

int main()
{
	alt_up_pixel_buffer_dma_dev* pixel_buffer;
	pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/pixel_buffer_dma");
	if (pixel_buffer == 0) {
		//printf("error initializing pixel buffer (check name in alt_up_pixel_buffer_dma_open_dev)\n");
	}

	char *pixelEn = (char*) 0xb070;
	long *rgb = (long *) 0xb060;
	int *positionX = (int *) 0xb040;
	int *positionY = (int *) 0xb050;
	unsigned int addr = 0;

	alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer, PIXEL_BUFFER_BASE);
	alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
	while (alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));
	alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);

	while(1) {

		alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer, PIXEL_BUFFER_BASE);
		alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
		while (alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));
		alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);

//		int hw = 1;
//
//		if (*pixelEn > 0) {
//			if (hw) {
//				addr = 0;
//				addr |= ((*positionX & pixel_buffer->x_coord_mask) << pixel_buffer->x_coord_offset);
//				addr |= ((*positionY & pixel_buffer->y_coord_mask) << pixel_buffer->y_coord_offset);
//				IOWR_16DIRECT(pixel_buffer->back_buffer_start_address, addr, *rgb);
//				IOWR_32DIRECT(drawer_base,0,*positionX); // Set x1
//				IOWR_32DIRECT(drawer_base,4,*positionY); // Set y1
//				IOWR_32DIRECT(drawer_base,8,*positionX); // Set x2
//				IOWR_32DIRECT(drawer_base,12,*positionY); // Set y2
//				IOWR_32DIRECT(drawer_base,16,*rgb);  // Set colour
//				IOWR_32DIRECT(drawer_base,20,1);  // Start drawing
//				while(IORD_32DIRECT(drawer_base,20)==0); // wait until done
//			} else {
////				alt_up_pixel_buffer_dma_draw(pixel_buffer, 0xffff, 10, 10);
//				alt_up_pixel_buffer_dma_draw(pixel_buffer, *rgb, *positionX, *positionY);
//			}
//		}
//			alt_up_pixel_buffer_dma_draw(pixel_buffer, *rgb, *positionX, *positionY);
				IOWR_32DIRECT(drawer_base,0,0); // Set x1
				IOWR_32DIRECT(drawer_base,4,0); // Set y1
				IOWR_32DIRECT(drawer_base,8,100); // Set x2
				IOWR_32DIRECT(drawer_base,12,100); // Set y2
				IOWR_32DIRECT(drawer_base,16,0x0FF0);  // Set colour
				IOWR_32DIRECT(drawer_base,20,1);  // Start drawing
	}
    return 0;
}

