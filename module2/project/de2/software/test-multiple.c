#include "sys/alt_stdio.h"
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"

#define tracker_1_base (volatile int*) 0x00089400
#define tracker_2_base (volatile int*) 0x00089440
#define piconnector_base (volatile int*) 0x00089480

void drawBoxOutline (int x1, int y1, int x2, int y2, int color){

int outline_width = 1;

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

void outLine(int x,int y, int color){
	drawBoxOutline(x-5,y-5,x+5,y+5,color);
}


void SendData(long data){
	IOWR_32DIRECT(piconnector_base, 0, data);
	printf("sending %8x \n", data);
}

int main()
{
	while(1){
		IOWR_32DIRECT(tracker_1_base, 0, 0xffffffff);
		int ready;
		do {
			ready = IORD_32DIRECT(tracker_1_base, 0);
		} while(!ready);
		
		int i;
		for(i = 4;i<21;i+=4){
			int buffer = IORD_32DIRECT(tracker_1_base, i);
			int acc = buffer & 0x000003FF;
			int posy = (buffer >> 10) & 0x000000FF;
			int posx = (buffer >> 18) & 0x000001FF;
			outline(posx,posy,i*10000);
		}
	}

  return 0;
}
