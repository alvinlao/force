//#include <stdio.h>
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <unistd.h>
#define drawer_base (volatile int *) 0xb020

int main()
{
	alt_up_pixel_buffer_dma_dev* pixel_buffer;
	pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/pixel_buffer_dma");
	if (pixel_buffer == 0) {
		//printf("error initializing pixel buffer (check name in alt_up_pixel_buffer_dma_open_dev)\n");
	}

	while(1) {
		int x1, x2, y1, y2, colour, max_x, max_y;
		max_x = 20;
		max_y = 20;
		x1 = rand() % (320 - max_x);
		x2 = (rand() % max_x) + x1;
		y1 = rand() % (240 - max_y);
		y2 = (rand() % max_y) + y1;
		colour = rand() % 65535;

		alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer, PIXEL_BUFFER_BASE);
		alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
		while (alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));
		//alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);

		int hw = 0;
		if (hw) {
			   IOWR_32DIRECT(drawer_base,0,x1); // Set x1
			   IOWR_32DIRECT(drawer_base,4,y1); // Set y1
			   IOWR_32DIRECT(drawer_base,8,x2); // Set x2
			   IOWR_32DIRECT(drawer_base,12,y2); // Set y2
			   IOWR_32DIRECT(drawer_base,16,colour);  // Set colour
			   IOWR_32DIRECT(drawer_base,20,1);  // Start drawing
			   while(IORD_32DIRECT(drawer_base,20)==0); // wait until done
		} else {
			   alt_up_pixel_buffer_dma_draw_box(pixel_buffer, x1,y1,x2,y2,colour,0);
		}
	}
    return 0;
}

