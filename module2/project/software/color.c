#include "sys/alt_stdio.h"
#include "sys/alt_timestamp.h"
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include "coordinate.h"
#include "exception.h"
#include "sad.h"

// Hardware memory locations of the two track hardware accelerators
#define tracker_1_base (volatile int*) 0x00089400
#define tracker_2_base (volatile int*) 0x00089440

// 16.8 MHz clock
// Delay to run algorithms once per frame
#define TIMER_DELAY 440000

// lightsaber length = length of handle * EXTEND MULTIPLIER
#define EXTEND_MULTIPLIER 1.5

// Tracking confidence threshold
#define threshold 30

int outline_width = 0;
int rayColor = 0;
double ray_TurnOnOff_Effect = 0.05;
// lower number is faster

double ray_scale_factor = 0;
unsigned char rayStatus = 0;
// 0 = Off
// 1 = Turning On
// 2 On
// 3 = Turning Off

#define draw_base (volatile int*) 0x00089480

alt_up_pixel_buffer_dma_dev* pixel_buffer;

/*
 * Initialize the pixel buffer
 */
void initPixelBuffer() {
	pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/Pixel_Buffer_DMA");
	alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);
}

/*
 * Plots a line using the hardware accelerator
 * @param x0
 * @param y0
 * @param x1
 * @param y1
 * @param color 16 bit color (r, g, b)
 */
void plotLine(int x0, int y0, int x1, int y1, int color)
{
	IOWR_32DIRECT(draw_base, 0, x0);
	IOWR_32DIRECT(draw_base, 4, y0);
	IOWR_32DIRECT(draw_base, 8, x1);
	IOWR_32DIRECT(draw_base, 12, y1);
	IOWR_32DIRECT(draw_base, 16, color);
	IOWR_32DIRECT(draw_base, 24, 1);
	IOWR_32DIRECT(draw_base, 20, 1);
	while(IORD_32DIRECT(draw_base, 20) == 0);
	int i = 0;
	for(i = 0; i < 10000; i ++);
}


void drawBoxOutline (int x1, int y1, int x2, int y2, int color);

/*
 * Helper function
 * Draw a box outline around a point
 * @param x
 * @param y
 * @param color
 */
void outLine(int x,int y, int color){
	drawBoxOutline(x-5,y-5,x+5,y+5,color);
}

/*
 * Draws a box outline
 * @param x1 
 * @param y1
 * @param x2
 * @param y2 
 * @param color 16 bit color (r 5bits, g 6bits, b 5bits)
 */
void drawBoxOutline (int x1, int y1, int x2, int y2, int color){
	int topRecX1 = x1;
	int topRecX2 = x2;
	int topRecY1 = y1;
	int topRecY2 = y1 + outline_width;

	int bottomRecX1 = x1;
	int bottomRecX2 = x2+1;
	int bottomRecY1 = y2;
	int bottomRecY2 = y2 + outline_width;

	int leftRecX1 = x1;
	int leftRecX2 = x1 + outline_width;
	int leftRecY1 = y1;
	int leftRecY2 = y2;

	int rightRecX1 = x2;
	int rightRecX2 = x2 + outline_width;
	int rightRecY1 = y1;
	int rightRecY2 = y2;

	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, topRecX1, topRecY1, topRecX2, topRecY2, color, 1);
	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, bottomRecX1, bottomRecY1, bottomRecX2, bottomRecY2, color, 1);
	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, leftRecX1, leftRecY1, leftRecX2, leftRecY2, color, 1);
	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, rightRecX1, rightRecY1, rightRecX2, rightRecY2, color, 1);
	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, topRecX1, topRecY1, topRecX2, topRecY2, color, 0);
	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, bottomRecX1, bottomRecY1, bottomRecX2, bottomRecY2, color, 0);
	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, leftRecX1, leftRecY1, leftRecX2, leftRecY2, color, 0);
	alt_up_pixel_buffer_dma_draw_box(pixel_buffer, rightRecX1, rightRecY1, rightRecX2, rightRecY2, color, 0);
}

/*
 * Read tracking hardware accelerator output
 * @param memory address of the tracker
 * @param Coordinate a pointer to store the results
 */
void getTrackPosition(int tracker_base, Coordinate * c) {
	IOWR_32DIRECT(tracker_base, 0, 0xffffffff);
	while(IORD_32DIRECT(tracker_base, 16) != 0);

	c->x = IORD_32DIRECT(tracker_base, 4);
	c->y = IORD_32DIRECT(tracker_base, 8);
	c->acc = IORD_32DIRECT(tracker_base, 12);
}

/*
 * Get tracking position from hardware accelerator
 * @deprecated
 */
void GetPos(base, color) {
	IOWR_32DIRECT(base, 0, 0xffffffff);
	int ready;
	do {
		ready = IORD_32DIRECT(base, 16);
	} while(!ready);

	int x = IORD_32DIRECT(base, 4);
	int y = IORD_32DIRECT(base, 8);
	int accuracy = IORD_32DIRECT(base, 12);
	outLine(x,y,color);
	printf("%3d, %3d acc:%3d \n", x, y,accuracy);
}

/*
 * Is the coordinate inside the camera frame?
 * @return boolean
 */
char isBounded(Coordinate * c) {
	return 0 <= c->x && c->x < FRAME_WIDTH && 0 <= c->y && c->y < FRAME_HEIGHT;
}

/*
 * Is the coordinate above the screen?
 * @return boolean
 */
char violateTopBound(Coordinate * c) {
	return c->y < 0;
}

/*
 * Is the coordinate past the right of the screen?
 * @return boolean
 */
char violateRightBound(Coordinate * c) {
	return c->x > FRAME_WIDTH;
}

/*
 * Is the coordinate past the bottom of the screen?
 * @return boolean
 */
char violateBottomBound(Coordinate * c) {
	return c->y > FRAME_HEIGHT;
}

/*
 * Is the coordinate past the left of the screen?
 * @return boolean
 */
char violateLeftBound(Coordinate * c) {
	return c->x < 0;
}

/*
 * Calculate the coordinate of the lightsaber's tip
 * "Extends" the handle coordinates with scaled vector addition
 * @param fromCoord Bottom handle coordinate
 * @param toCoord Top handle coordinate
 * @param rayEndCoord Coordinate to store result
 */
void extend(Coordinate * fromCoord, Coordinate * toCoord, Coordinate * rayEndCoord) {
	rayEndCoord->x = toCoord->x + ray_scale_factor * (toCoord->x - fromCoord->x);
	rayEndCoord->y = toCoord->y + ray_scale_factor * (toCoord->y - fromCoord->y);

	char vertical = fromCoord->x == toCoord->x;
	float m, b;
	if(!vertical) {
		m = (toCoord->y - fromCoord->y) / (float) (toCoord->x - fromCoord->x);
		b = rayEndCoord->y - (m * rayEndCoord->x);
	}

	if(violateTopBound(rayEndCoord)) {
		rayEndCoord->y = 0;
		if(!vertical) {
			rayEndCoord->x = (rayEndCoord->y - b) / m;
		}
	} else if(violateRightBound(rayEndCoord)) {
		rayEndCoord->x = FRAME_WIDTH;
		rayEndCoord->y = (m * rayEndCoord->x) + b;
	} else if(violateBottomBound(rayEndCoord)) {
		rayEndCoord->y = FRAME_HEIGHT;
		if(!vertical) {
			rayEndCoord->x = (rayEndCoord->y - b) / m;
		}
	} else if(violateLeftBound(rayEndCoord)) {
		rayEndCoord->x = 0;
		rayEndCoord->y = (m * rayEndCoord->x) + b;
	}
}

/**
 * Turns on and off the ray.
 */
void RayTurnOnOff(){
	if(rayStatus == 0 || rayStatus == 3){
		//turn on
		rayStatus = 1;

	}else{
		//turn off
		rayStatus = 3;
	}
}

/**
 * Changes the colour of the ray.
 */
void ChangeRayColor() {
	int temp = 0;
	rayColor = rayColor + 123;
	if (rayColor >= 0xffff) {
		temp = rayColor - 0xffff;
	}

}

int main() {
	printf("Here we goo....\n");

	// Set up interrupts
	init_button_pio();

	initPixelBuffer();
	ScreenShotInit(pixel_buffer);

    // Setup coordinate structs
	Coordinate* fromCoord = CoordinateCreate(0, 0);
	Coordinate* toCoord = CoordinateCreate(0, 0);
	Coordinate* rayEndCoord = CoordinateCreate(0, 0);

	Coordinate* tmpFrom = CoordinateCreate(0,0);
	Coordinate* tmpTo= CoordinateCreate(0,0);

    // Timer frequency
	printf("%d\n", alt_timestamp_freq);

	rayColor = 0x7f00;
	//int i, j;
	/*//int prev_ax, prev_ay, prev_bx, prev_by;
	getTrackPosition(tracker_1_base, fromCoord);
	getTrackPosition(tracker_2_base, toCoord);*/

	while(1) {
		alt_timestamp_start();

		if(rayStatus==0){
			//ray is turned off
			ray_scale_factor = 0;
		}
		else if (rayStatus == 1){
			//ray is turning on
			ray_scale_factor = ray_scale_factor + ray_TurnOnOff_Effect;
			if(ray_scale_factor >= EXTEND_MULTIPLIER)
			{
				rayStatus=2;
			}
		}
		else if (rayStatus == 2){
			//ray is turned on
			ray_scale_factor = EXTEND_MULTIPLIER;
		}else{
			//ray is turning off
			ray_scale_factor = ray_scale_factor - ray_TurnOnOff_Effect;
			if(ray_scale_factor <= 0)
			{
				rayStatus=0;
			}
		}

        // Get track positions
		getTrackPosition(tracker_1_base, tmpFrom);
		getTrackPosition(tracker_2_base, tmpTo);

		//Skip Low Accuracy Reads
		if (tmpFrom->acc > threshold){
			fromCoord->x = tmpFrom->x;
			fromCoord->y = tmpFrom->y;
			fromCoord->acc = tmpFrom->acc;
		}
		if (tmpTo->acc > threshold){
			toCoord->x = tmpTo->x;
			toCoord->y = tmpTo->y;
			toCoord->acc = tmpTo->acc;
		}

        // Draw lightsaber
		IOWR_32DIRECT(draw_base, 24, 0);
		extend(fromCoord, toCoord, rayEndCoord);
		plotLine(toCoord->x, toCoord->y, rayEndCoord->x, rayEndCoord->y, rayColor);

		while(alt_timestamp() < TIMER_DELAY);
	}
	return 0;
}
