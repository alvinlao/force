#include "sys/alt_stdio.h"
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <unistd.h>
#include "sad.h"

#define drawer_base (volatile int *) 0xb020
#define UP 1
#define DOWN 2
#define RIGHT 3
#define LEFT 4

// Test box params
#define BOX_X0 120
#define BOX_Y0 120
typedef struct box {
	int x1, y1, x2, y2;
	int color;
	int horizontalDir, verticalDir;
} Box;



alt_up_pixel_buffer_dma_dev * initPixelBuffer();
void initBox(Box *);
void drawBox(alt_up_pixel_buffer_dma_dev *, Box *);


alt_up_pixel_buffer_dma_dev* initPixelBuffer() {
	alt_up_pixel_buffer_dma_dev* pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/pixel_buffer_dma");
	if (pixel_buffer == 0) {
		//printf("error initializing pixel buffer (check name in alt_up_pixel_buffer_dma_open_dev)\n");
	}

	alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer, PIXEL_BUFFER_BASE);
	alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
	while (alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));
	alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);

	return pixel_buffer;
}

void initBox(Box *box) {
	box->x1 = BOX_X0;
	box->y1 = BOX_Y0;
	box->x2 = box->x1 + BLOCK_WIDTH;
	box->y2 = box->y1 + BLOCK_HEIGHT;
	box->horizontalDir = RIGHT;
	box->verticalDir = UP;
	box->color = 0x0ff0;
}

void drawBox(alt_up_pixel_buffer_dma_dev* pixel_buffer, Box *box) {

	// Set direction change
	if (box->horizontalDir == RIGHT) {
		if (box->x2 >= FRAME_WIDTH) {
			box->horizontalDir = LEFT;
		}
	} else {
		if (box->x1 <= 0) {
			box->horizontalDir = RIGHT;
		}
	}

	if (box->verticalDir == DOWN) {
		if (box->y2 >= FRAME_HEIGHT) {
			box->verticalDir = UP;
		}
	} else {
		if (box->y1 <= 0) {
			box->verticalDir = DOWN;
		}
	}

	// Clean edges
	if (box->horizontalDir == LEFT) {
		alt_up_pixel_buffer_dma_draw_line(pixel_buffer, box->x2, box->y1, box->x2, box->y2, 0x0000, 0);
	} else {
		alt_up_pixel_buffer_dma_draw_line(pixel_buffer, box->x1, box->y1, box->x1, box->y2, 0x0000, 0);
	}
	if (box->verticalDir == DOWN) {
		alt_up_pixel_buffer_dma_draw_line(pixel_buffer, box->x1, box->y1, box->x2, box->y1, 0x0000, 0);
	} else {
		alt_up_pixel_buffer_dma_draw_line(pixel_buffer, box->x1, box->y2, box->x2, box->y2, 0x0000, 0);
	}

	// Move box
	if (box->horizontalDir == LEFT) {
		box->x1--;
		box->x2--;
	} else {
		box->x1++;
		box->x2++;
	}
	if (box->verticalDir == DOWN) {
		box->y1++;
		box->y2++;
	} else {
		box->y1--;
		box->y2--;
	}


	// Draw
	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, box->x1, box->y1, box->x2, box->y2, box->color, 0);
}

int main()
{
	// Setup pixel buffer
	alt_up_pixel_buffer_dma_dev* pixel_buffer = initPixelBuffer();

	// Setup tracking algorithm
	Block *targetBlock, *resultBlock, *window;
	Pixel *pixelA, *pixelB;
	SADInit(BOX_X0, BOX_Y0, &targetBlock, &resultBlock, &window, &pixelA, &pixelB);
	VideoInit(pixel_buffer);
	VideoInitMemoryBlock(BLOCK_WIDTH, BLOCK_HEIGHT);

	// Setup box
	Box box;
	initBox(&box);

	printf("Window: (%d, %d)\n", BlockGetX(window), BlockGetY(window));
	printf("Block: (%d, %d)\n", BlockGetX(targetBlock), BlockGetY(targetBlock));
	printf("Here we go...\n");

	// Main loop
	while(1) {
		int i = 0;
		// Lazy wait
		for (i = 0; i < 10000; i++);

		// Move and draw box
		drawBox(pixel_buffer, &box);

		// Apply algorithm
		SADTrack(targetBlock, resultBlock, window, pixelA, pixelB);

		printf("Block: (%d, %d)\n", BlockGetX(resultBlock), BlockGetY(resultBlock));
	}

    return 0;
}

