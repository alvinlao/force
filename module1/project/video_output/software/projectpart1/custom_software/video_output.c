#include "sys/alt_stdio.h"
//#include <stdio.h>
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <unistd.h>
#define drawer_base (volatile int *) 0xb020
#define UP 1
#define DOWN 0
#define RIGHT 1
#define LEFT 0
#define MAX_WIDTH 320
#define MAX_DEPTH 240

int main()
{
	alt_up_pixel_buffer_dma_dev* pixel_buffer;
	pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/pixel_buffer_dma");
	if (pixel_buffer == 0) {
		//printf("error initializing pixel buffer (check name in alt_up_pixel_buffer_dma_open_dev)\n");
	}

//	char *pixelEn = (char*) 0xb070;
//	long *rgb = (long *) 0xb060;
//	int *positionX = (int *) 0xb040;
//	int *positionY = (int *) 0xb050;
//	unsigned int addr = 0;

	alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer, PIXEL_BUFFER_BASE);
	alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
	while (alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));
	alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);

	int x1 = 120;
	int y1 = 120;
	int x2 = 140;
	int y2 = 140;
	int leftRightDir = RIGHT;
	int upDownDir = DOWN;
	int colour = 0x0ff0;

	while(1) {

//		alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer, PIXEL_BUFFER_BASE);
//		alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
//		while (alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));
//		alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);

		int i = 0;
		for (i = 0; i < 10000; i++) {
			// Lazy wait
		}

//		alt_up_pixel_buffer_dma_draw_box(pixel_buffer, x1, y1, x2, y2, 0x0000, 0);

		if (leftRightDir == RIGHT) {
			if (x2 >= MAX_WIDTH) {
				leftRightDir = LEFT;
			}
		} else {
			if (x1 <= 0) {
				leftRightDir = RIGHT;
			}
		}

		// Set direction change
		if (upDownDir == DOWN) {
			if (y2 >= MAX_DEPTH) {
				upDownDir = UP;
			}
		} else {
			if (y1 <= 0) {
				upDownDir = DOWN;
			}
		}

		// Clean edges
		if (leftRightDir == LEFT) {
			alt_up_pixel_buffer_dma_draw_line(pixel_buffer, x2, y1, x2, y2, 0x0000, 0);
		} else {
			alt_up_pixel_buffer_dma_draw_line(pixel_buffer, x1, y1, x1, y2, 0x0000, 0);
		}
		if (upDownDir == DOWN) {
			alt_up_pixel_buffer_dma_draw_line(pixel_buffer, x1, y1, x2, y1, 0x0000, 0);
		} else {
			alt_up_pixel_buffer_dma_draw_line(pixel_buffer, x1, y2, x2, y2, 0x0000, 0);
		}

		// Move box
		if (leftRightDir == LEFT) {
			x1--;
			x2--;
		} else {
			x1++;
			x2++;
		}
		if (upDownDir == DOWN) {
			y1++;
			y2++;
		} else {
			y1--;
			y2--;
		}

		alt_up_pixel_buffer_dma_draw_box(pixel_buffer, x1, y1, x2, y2, colour, 0);

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
	}
    return 0;
}

