#include "sys/alt_stdio.h"
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"

#define blob_base (volatile int*) 0x00089400
#define piconnector_base (volatile int*) 0x00089480

void SendData(long data){
	IOWR_32DIRECT(piconnector_base, 0, data);
	printf("sending %8x \n", data);
}

int main()
{
	printf("letsgo");
	while(1){
		IOWR_32DIRECT(blob_base, 0, 0xffffffff);
		int ready;
		do {
			ready = IORD_32DIRECT(blob_base, 0);
		} while(!ready);

		int ch1 = IORD_32DIRECT(blob_base, 4);
		int ch1x = (ch1>>16) & 0x1ff;
		int ch1y = (ch1>>8) & 0xff;

		int ch2 = IORD_32DIRECT(blob_base, 8);
		int ch2x = (ch2>>16) & 0x1ff;
		int ch2y = (ch2>>8) & 0xff;

		printf("ch1: (%3d, %3d)    ch2: (%3d,%3d)\n",ch1x,ch1y,ch2x,ch2y);
		SendData(ch1);
		SendData(ch2 | 0x80000000);
	}

  return 0;
}
