#include "sys/alt_stdio.h"
#include "io.h"
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"

#define tracker_1_base (volatile int*) 0x00089400
#define tracker_2_base (volatile int*) 0x00089440
#define piconnector_base (volatile int*) 0x00089480

long GetPosData(base) {
	IOWR_32DIRECT(base, 0, 0xffffffff);
	int ready;
	do {
		ready = IORD_32DIRECT(base, 0);
	} while(!ready);

	return(IORD_32DIRECT(base, 0));
}

void SendData(long data){
	IOWR_32DIRECT(piconnector_base, 0, data);
	printf("sending %8x \n", data);
}

int main()
{
	while(1){
		IOWR_32DIRECT(tracker_1_base, 0, 0xffffffff);
		IOWR_32DIRECT(tracker_2_base, 0, 0xffffffff);
		int ready;
		do {
			ready = IORD_32DIRECT(tracker_1_base, 16);
		} while(!ready);
		SendData(IORD_32DIRECT(tracker_1_base, 0));
		do {
			ready = IORD_32DIRECT(tracker_2_base, 16);
		} while(!ready);
		SendData(0x80000000 | IORD_32DIRECT(tracker_2_base, 0));
	}

  return 0;
}
