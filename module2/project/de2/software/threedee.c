#include "sys/alt_stdio.h"
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"

#define blob_base (volatile int*) 0x00089400
#define piconnector_base (volatile int*) 0x00089480

alt_up_pixel_buffer_dma_dev* pixel_buffer;

void initPixelBuffer() {
	pixel_buffer = alt_up_pixel_buffer_dma_open_dev("/dev/Pixel_Buffer_DMA");
	alt_up_pixel_buffer_dma_clear_screen(pixel_buffer, 0);
}
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
		IOWR_32DIRECT(blob_base, 0, 0xffffffff);
		int ready;
		do {
			ready = IORD_32DIRECT(blob_base, 0);
		} while(!ready);

		int count = IORD_32DIRECT(blob_base, 20);

		int buffer = IORD_32DIRECT(blob_base, 4);
		int x1 = buffer & 0x1ff;
		int y1 = (buffer>>9) & 0xff;
		int buffer2 = IORD_32DIRECT(blob_base, 8);
		int x2 = buffer2 & 0x1ff;
		int y2 = (buffer2>>9) & 0xff;
		drawBoxOutline(x1,y1,x2,y2,0x7E0);

		printf("%3d %3d %3d %3d %3d\n",count,x1,y1,x2,y2);
	}

  return 0;
}
