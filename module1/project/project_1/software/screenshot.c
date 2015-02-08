#include <stdlib.h>
#include <stdio.h>
#include "screenshot.h"
#include <io.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <altera_up_sd_card_avalon_interface.h>

alt_up_pixel_buffer_dma_dev *ScreenShotPixelBuffer;


char screenCapture[FRAME_WIDTH*FRAME_HEIGHT];
char bmpArray[54 + FRAME_WIDTH*FRAME_HEIGHT];
int bmpCount = 0;

void ScreenShotInit(alt_up_pixel_buffer_dma_dev *pixelBuffer) {
	ScreenShotPixelBuffer = pixelBuffer;
}

void SavePixelArray(){
	int i,j;
	unsigned int addr;
	int count = 0;
	for (i = 1; i < FRAME_WIDTH; i++){
		for (j = 1; j < FRAME_HEIGHT; i++){
			addr = 0;
			addr |= ((i & ScreenShotPixelBuffer->x_coord_mask) << ScreenShotPixelBuffer->x_coord_offset);
			addr |= ((j & ScreenShotPixelBuffer->y_coord_mask) << ScreenShotPixelBuffer->y_coord_offset);

			screenCapture[count] = IORD_32DIRECT(ScreenShotPixelBuffer->buffer_start_address, addr);
			count++;
		}
	}
}

void SaveBmpSDCARD(){



	SavePixelArray();
	
	alt_up_sd_card_dev *device_reference = NULL;
	int connected = 0;
	char a;
    char name = "scrnshot.bmp";
	
	device_reference = alt_up_sd_card_open_dev("/dev/SD_CARD_INTERFACE");
	if (device_reference != NULL) {
		while(1) {
			if ((connected == 0) && (alt_up_sd_card_is_Present())) {
				printf("Card connected.\n");
				if (alt_up_sd_card_is_FAT16()) {
					printf("FAT16 file system detected.\n");
					alt_up_sd_card_find_first(device_reference, a);
					if(a == "scrnshot.bmp"){
						printf("FILE FOUND: %s\n", a);
						write_bmp(name, FRAME_WIDTH, FRAME_HEIGHT, screenCapture);
					}
					else {
						while(alt_up_sd_card_find_next(a) != -1) {
							if(a == "scrnshot.bmp"){
								printf("FILE FOUND: %s\n", a);
								write_bmp(name, FRAME_WIDTH, FRAME_HEIGHT, screenCapture);
							}
						}
					}
				} else {
					printf("Unknown file system.\n");
				}
				connected = 1;
			} else if ((connected == 1) && (alt_up_sd_card_is_Present() == false)) {
				printf("Card disconnected.\n");
				connected = 0;
			}
		}
	}
	else{
		printf("twas null\n");
	}
}
