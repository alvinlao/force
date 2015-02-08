#include "sys/alt_stdio.h"
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <unistd.h>
#include "sad.h"

#define drawer_base (volatile int *) 0xb020
#define draw_base (volatile int *) 0x00089400
#define UP 1
#define DOWN 2
#define RIGHT 3
#define LEFT 4

// Test box params
#define BOX_X0 120
#define BOX_Y0 120
#define BOX_SPEED 5
#define MARKER_SIZE 8
typedef struct box {
	int x1, y1, x2, y2;
	int color;
	int horizontalDir, verticalDir;
	int speed;
} Box;



alt_up_pixel_buffer_dma_dev * initPixelBuffer();
Box * initBox(int x, int y, int w, int h, int s, int c);
void updateBox(Box *);
void drawBox(alt_up_pixel_buffer_dma_dev *, Box *);
void plotLine(alt_up_pixel_buffer_dma_dev* pixel_buffer, int x0, int y0, int x1, int y1, int color, int back_buffer);


alt_up_pixel_buffer_dma_dev* initPixelBuffer() {
	alt_up_pixel_buffer_dma_dev* pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/Pixel_Buffer_DMA");
	if (pixel_buffer == 0) {
		//printf("error initializing pixel buffer (check name in alt_up_pixel_buffer_dma_open_dev)\n");
	}

	// Set front buffer address
//	alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer, PIXEL_BUFFER_BASE);
//	alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
//	while (alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));

	// Set back buffer address
//	alt_up_pixel_buffer_dma_change_back_buffer_address(pixel_buffer, PIXEL_BUFFER_BASE);
//	alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
//	while (alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));
	alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);


	return pixel_buffer;
}

Box * initBox(int x, int y, int w, int h, int s, int c) {
	Box *box = malloc(sizeof(Box));
	box->x1 = x;
	box->y1 = y;
	box->x2 = x + w;
	box->y2 = y + h;
	box->horizontalDir = RIGHT;
	box->verticalDir = UP;
	box->speed = s;
	box->color = c;
	return box;
}

void updateBox(Box *box) {
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

	// Move box
	if (box->horizontalDir == LEFT) {
		box->x1 -= box->speed;
		box->x2 -= box->speed;
	} else {
		box->x1 += box->speed;
		box->x2 += box->speed;
	}
	if (box->verticalDir == DOWN) {
		box->y1 += box->speed;
		box->y2 += box->speed;
	} else {
		box->y1 -= box->speed;
		box->y2 -= box->speed;
	}
}

void drawBox(alt_up_pixel_buffer_dma_dev* pixel_buffer, Box *box) {
	IOWR_32DIRECT(draw_base, 0, 10);
	IOWR_32DIRECT(draw_base, 4, 20);
	IOWR_32DIRECT(draw_base, 8, 50);
	IOWR_32DIRECT(draw_base, 12, 60);
	IOWR_32DIRECT(draw_base, 16, 0xffff);
	IOWR_32DIRECT(draw_base, 20, 1);
	while(IORD_32DIRECT(draw_base, 20) == 0);
//	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, box->x1, box->y1, box->x2, box->y2, box->color, 1);
}

void setPixel(int buffer_start, int line_size, int x, int y, int color) {
	helper_plot_pixel(buffer_start, line_size, x, y, color, 1);
}

void plotLine(alt_up_pixel_buffer_dma_dev* pixel_buffer, int x0, int y0, int x1, int y1, int color, int backbuffer)
{
/*	int buffer_start;
	int color_mode = 1;
	register int line_size = (pixel_buffer->addressing_mode == ALT_UP_PIXEL_BUFFER_XY_ADDRESS_MODE) ? (1 << (pixel_buffer->y_coord_offset-color_mode)) : pixel_buffer->x_resolution;

	int dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;
	int dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1;
	int err = dx+dy, e2;  // error value e_xy

	if (backbuffer == 1)
		buffer_start = pixel_buffer->back_buffer_start_address;
	else
		buffer_start = pixel_buffer->buffer_start_address;

	for(;;) {
		setPixel(buffer_start, line_size, x0, y0, color);
		if (x0==x1 && y0==y1) break;
		e2 = 2*err;
		if (e2 >= dy) { err += dy; x0 += sx; } // e_xy+e_x > 0;
		if (e2 <= dx) { err += dx; y0 += sy; } // e_xy+e_y < 0;
   }*/
	IOWR_32DIRECT(draw_base, 0, x0);
	IOWR_32DIRECT(draw_base, 4, y0);
	IOWR_32DIRECT(draw_base, 8, x1);
	IOWR_32DIRECT(draw_base, 12, y1);
	IOWR_32DIRECT(draw_base, 16, color);
	IOWR_32DIRECT(draw_base, 20, 1);
	while(IORD_32DIRECT(draw_base, 20) == 0);
}

int main()
{
	// Setup pixel buffer
	alt_up_pixel_buffer_dma_dev* pixel_buffer = initPixelBuffer();
/*
	// Setup tracking algorithm
	Block *targetBlock, *resultBlock, *window;
	Pixel *pixelA, *pixelB;
	SADInit(BOX_X0, BOX_Y0, &targetBlock, &resultBlock, &window, &pixelA, &pixelB);
	VideoInit(pixel_buffer);
	VideoInitMemoryBlock(BLOCK_WIDTH, BLOCK_HEIGHT);

	// Setup box
	Box *box = initBox(BOX_X0, BOX_Y0, BLOCK_WIDTH, BLOCK_HEIGHT, BOX_SPEED, 0x0ff0);
	Box *marker = initBox(0, 0, MARKER_SIZE, MARKER_SIZE, 0, 0xf000);

	// Draw first frame and copy track block into memory
	drawBox(pixel_buffer, box);
	VideoCopyBlock(BOX_X0, BOX_Y0, pixelA);
*/
	// Spam
//	printf("Window: (%d, %d)\n", BlockGetX(window), BlockGetY(window));
//	printf("Block: (%d, %d)\n", BlockGetX(targetBlock), BlockGetY(targetBlock));
//	printf("Front buffer addr: %x\n", pixel_buffer->buffer_start_address);
//	printf("Back buffer addr: %x\n", pixel_buffer->back_buffer_start_address);


	printf("Here we go...\n");

	// Main loop
	while(1) {
		/*
		 * Video in is drawing on the front buffer faster than our algorithm
		 * We swap buffers so that the back buffer holds a static frame.
		 * The algorithm runs on the back buffer.
		 */
//		alt_up_pixel_buffer_dma_swap_buffers(pixel_buffer);
//		while (alt_up_pixel_buffer_dma_check_swap_buffers_status(pixel_buffer));

		// Apply algorithm
//		SADTrack(targetBlock, resultBlock, window, pixelA, pixelB);
//
//		int track_x = BlockGetX(resultBlock);
//		int track_y = BlockGetY(resultBlock);
//		printf("Block: (%d, %d)\n", track_x, track_y);
//
//		// Draw marker
//		marker->x1 = track_x;
//		marker->y1 = track_y;
//		marker->x2 = track_x + MARKER_SIZE;
//		marker->y2 = track_y + MARKER_SIZE;
//		drawBox(pixel_buffer, 0);

		plotLine(pixel_buffer, FRAME_WIDTH/2 - 20, 0, FRAME_WIDTH/2 + 20, FRAME_HEIGHT, 0xffff, 1);
		plotLine(pixel_buffer, FRAME_WIDTH/2 - 20, FRAME_HEIGHT, FRAME_WIDTH/2 + 20, 0, 0xffff, 1);

		plotLine(pixel_buffer, 0, FRAME_HEIGHT/2, FRAME_WIDTH, FRAME_HEIGHT/2, 0xffff, 1);
		plotLine(pixel_buffer, FRAME_WIDTH/2, 0, FRAME_WIDTH/2, FRAME_HEIGHT, 0xffff, 1);
		plotLine(pixel_buffer, 0, 0, FRAME_WIDTH, FRAME_HEIGHT, 0xffff, 1);
		plotLine(pixel_buffer, 0, FRAME_HEIGHT, FRAME_WIDTH, 0, 0xffff, 1);
		plotLine(pixel_buffer, 0, FRAME_HEIGHT/2, FRAME_WIDTH/2, 0, 0xffff, 1);
//		drawBox(pixel_buffer, marker);
	}

    return 0;
}
