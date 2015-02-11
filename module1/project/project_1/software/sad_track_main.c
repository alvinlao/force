#include "sys/alt_stdio.h"
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <unistd.h>

#define draw_base (volatile int*) 0x00089480
#define SAD_TRACK_BASE (volatile int *) 0x00089440

alt_up_pixel_buffer_dma_dev* pixel_buffer;
void drawBox(int x1, int y1, int x2, int y2, int color) {
	IOWR_32DIRECT(draw_base, 0, x1);
	IOWR_32DIRECT(draw_base, 4, y1);
	IOWR_32DIRECT(draw_base, 8, x2);
	IOWR_32DIRECT(draw_base, 12, y2);
	IOWR_32DIRECT(draw_base, 16, color);
	IOWR_32DIRECT(draw_base, 20, 1);
	while(IORD_32DIRECT(draw_base, 20) == 0);
//	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, x1, y1, x2, y2, color, 1);
}

/*
 * Helper: Print out the current SAD state
 */
void printState() {
	int state = IORD_32DIRECT(SAD_TRACK_BASE, 16);
	printf("State: %d\n", state);
}

void printXY() {
	int x = IORD_32DIRECT(SAD_TRACK_BASE, 4);
	int y = IORD_32DIRECT(SAD_TRACK_BASE, 8);
	printf("XY: (%d, %d)\n", x, y);
}

void printPixel() {
	int val = IORD_32DIRECT(SAD_TRACK_BASE, 20);
	int b = ((val & 0x001F) >> 0) / 32.0 * 255;
	int g = ((val & 0x07E0) >> 5) / 64.0 * 255;
	int r = ((val & 0xF800) >> 11) / 32.0 * 255;
	printf("Pixel: (%d,%d,%d)\n", r, g, b);
}

void printSAD() {
	int val = IORD_32DIRECT(SAD_TRACK_BASE, 24);
	printf("SAD: %d\n", val);
}

void printWinXY() {
	int xy = IORD_32DIRECT(SAD_TRACK_BASE, 28);
	int x = (xy & 0xffff0000) >> 16;
	int y = (xy & 0x0000ffff) >> 0;

	printf("WINXY: (%d, %d)\n", x, y);
}

void printInitializedRefBlock() {
	int val = IORD_32DIRECT(SAD_TRACK_BASE, 32);
	printf("INIT: %d\n", val);
}

void printCounter() {
	int val = IORD_32DIRECT(SAD_TRACK_BASE, 36);
	printf("C: %d\n", val);
}

void printRefBlock() {
	int val = IORD_32DIRECT(SAD_TRACK_BASE, 40);
	int b = ((val & 0x001F) >> 0) / 32.0 * 255;
	int g = ((val & 0x07E0) >> 5) / 64.0 * 255;
	int r = ((val & 0xF800) >> 11) / 32.0 * 255;

	printf("Ref: (%d,%d,%d)\n", r, g, b);
}

/*
 * Start the MACHINE
 */
void startSAD() {
	// Write a 1 to 0x0001
	// To start SAD
	IOWR_32DIRECT(SAD_TRACK_BASE, 4, 1);
}

void waitSAD() {
	while(IORD_32DIRECT(SAD_TRACK_BASE, 12) == 0);
}

int main()
{
	printf("Here we go...\n");

	pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/Pixel_Buffer_DMA");

//
//	startSAD();
//	waitSAD();
//	printRefBlock();
//	printWinXY();

	int i;
	int x1 = 159, y1 = 119;
	int x2 = 161, y2 = 121;
	int vx = -1;
	int x, y;

	// Main loop
	while(1) {
		// Lazy delay
		for(i=0;i<5000000;i++);

		// Move box
//		drawBox(x1, y1, x2, y2, 0xffffff);
//		if(x1 < 0) vx = 1;
//		if(x2 > 320) vx = -1;
//
//		x1 += vx;
//		x2 += vx;
		drawBox(0, 118, 320, 118, 0xffffff);
		drawBox(0, 119, 320, 119, 0xffffff);
		drawBox(0, 120, 320, 120, 0xffffff);
		// Yawn
		startSAD();
		waitSAD();
		printRefBlock();
		printSAD();
		printXY();


//		x = IORD_32DIRECT(SAD_TRACK_BASE, 4);
//		y = IORD_32DIRECT(SAD_TRACK_BASE, 8);
//		drawBox(x, y, x+10, y+10, 0xff000);
//		printPixel();
//		printXY();
	}

    return 0;
}
