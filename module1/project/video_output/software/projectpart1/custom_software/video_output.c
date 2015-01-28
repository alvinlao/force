#include "sys/alt_stdio.h"
//#include <stdio.h>
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <unistd.h>
#include "sad.h"
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

	Pixel *pixelA, *pixelB;
	Block *blockToTrack, *resultBlockForTrack, *emptyBlock;

	// Init pixels
	pixelA = PixelCreate(0, 0, 0);
	pixelB = PixelCreate(0, 0, 0);

	// Init blocks
	blockToTrack = BlockCreate(160, 120);
	resultBlockForTrack = BlockCreate(50, 50);
	emptyBlock = BlockCreate(0, 0);

	Block *w = BlockCreate(15, 15);

	VideoInitMemoryBlock(BLOCK_WIDTH, BLOCK_HEIGHT);

	unsigned int addr = 0;

	unsigned int *curr_buffer_pixel_address;
	unsigned int curr_buffer_pixel;
	curr_buffer_pixel_address = &addr;
	curr_buffer_pixel = *curr_buffer_pixel_address;


	// Not sure how else to search thru the frame so saving to 2*2 array
	int i, j;
	unsigned int array[320][240];
	for(j = 0; j < 239; j++){
		for(i = 0; i < 319; i++){
			addr |= ((i & pixel_buffer->x_coord_mask) << pixel_buffer->x_coord_offset);
			addr |= ((j & pixel_buffer->y_coord_mask) << pixel_buffer->y_coord_offset);
		//	array[i][j] = *addr;
		}
	}

	while(1) {

		int i = 0;
		for (i = 0; i < 10000; i++) {
			// Lazy wait
		}

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



		/* TODO: assign things from the saved array
		 * write in order of operations for SAD to run
		 *
		 */
//		SADTrack(blockToTrack, resultBlockForTrack, w, pixelA, pixelB);


	}

    return 0;
}

