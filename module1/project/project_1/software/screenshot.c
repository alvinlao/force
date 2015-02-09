#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "screenshot.h"
#include <io.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <altera_up_sd_card_avalon_interface.h>
#include "pixel.h"

alt_up_pixel_buffer_dma_dev *ScreenShotPixelBuffer;

//char screenCapture[width*height];
short screenCapture[FRAME_WIDTH*FRAME_HEIGHT*3];

void ScreenShotInit(alt_up_pixel_buffer_dma_dev *pixelBuffer) {
	ScreenShotPixelBuffer = pixelBuffer;
}

void SavePixelArray(){
	int i,j;
	Pixel p;
	unsigned int addr;
	int count = 0;
	printf("test sd\n");
	for (i = 1; i < FRAME_WIDTH; i++){
		for (j = 1; j < FRAME_HEIGHT; j++){

			addr = 0;
			addr |= ((i & ScreenShotPixelBuffer->x_coord_mask) << ScreenShotPixelBuffer->x_coord_offset);
			addr |= ((j & ScreenShotPixelBuffer->y_coord_mask) << ScreenShotPixelBuffer->y_coord_offset);

			int rgb;
			rgb = IORD_32DIRECT(ScreenShotPixelBuffer->buffer_start_address, addr);
			PixelSetRGB(&p, rgb);
			screenCapture[count] = p.r;
			count++;
			screenCapture[count] = p.g;
			count++;
			screenCapture[count] = p.b;
			count++;
		}
	}
}

void SaveBmpSDCARD(){
	SavePixelArray();
	printf("after savepixelarray\n");
	int count, width, height;
	width = FRAME_WIDTH;
	height = FRAME_HEIGHT;

	alt_up_sd_card_dev *device_reference = NULL;
	int connected = 0;
	char *a;
    char *name = "SCRNSHOT.BMP";

    a = "";
	
	device_reference = alt_up_sd_card_open_dev("/dev/SD_CARD_INTERFACE");
	printf("device ref: %s\n", device_reference);
	if (device_reference != NULL) {
		if ((connected == 0) && (alt_up_sd_card_is_Present())) {
			printf("Card connected.\n");
			if (alt_up_sd_card_is_FAT16()) {
				printf("FAT16 file system detected.\n");

				short int file = alt_up_sd_card_fopen(name, 1);
				printf("file: %i\n", file);
				//write_bmp(name, width, height, screenCapture, file);
				int i, j, ipos;
				    int bytesPerLine;
				    unsigned char *line;

				    struct BMPHeader bmph;

				    /* The length of each line must be a multiple of 4 bytes */
				    bytesPerLine = (3 * (width + 1) / 4) * 4;

					/* Initialize bmp header*/
				    strcpy(bmph.bfType, "BM");
				    bmph.bfOffBits = 54;
				    bmph.bfSize = bmph.bfOffBits + bytesPerLine * height;
				    bmph.bfReserved = 0;
				    bmph.biSize = 40;
				    bmph.biWidth = width;
				    bmph.biHeight = height;
				    bmph.biPlanes = 1;
				    bmph.biBitCount = 16;
				    bmph.biCompression = 0;
				    bmph.biSizeImage = bytesPerLine * height;
				    bmph.biXPelsPerMeter = 0;
				    bmph.biYPelsPerMeter = 0;
				    bmph.biClrUsed = 0;
				    bmph.biClrImportant = 0;

				    //short int file = alt_up_sd_card_fopen(name, 1);

				    printf("file handle: %i\n", file);
				    printf("name: %s\n", name);

				   // if (file == NULL) return(0);

				    fwritecustom(&bmph.bfType, 2, 1, file);
				    fwritecustom(&bmph.bfSize, 4, 1, file);
				    fwritecustom(&bmph.bfReserved, 4, 1, file);
				    fwritecustom(&bmph.bfOffBits, 4, 1, file);
				    fwritecustom(&bmph.biSize, 4, 1, file);
				    fwritecustom(&bmph.biWidth, 4, 1, file);
				    fwritecustom(&bmph.biHeight, 4, 1, file);
				    fwritecustom(&bmph.biPlanes, 2, 1, file);
				    fwritecustom(&bmph.biBitCount, 2, 1, file);
				    fwritecustom(&bmph.biCompression, 4, 1, file);
				    fwritecustom(&bmph.biSizeImage, 4, 1, file);
				    fwritecustom(&bmph.biXPelsPerMeter, 4, 1, file);
				    fwritecustom(&bmph.biYPelsPerMeter, 4, 1, file);
				    fwritecustom(&bmph.biClrUsed, 4, 1, file);
				    fwritecustom(&bmph.biClrImportant, 4, 1, file);

				    printf("Header intialized for bmp\n");

				    line = malloc(bytesPerLine);
				    if (line == NULL)
				    {
				        printf(stderr, "Can't allocate memory for BMP file.\n");
				    //    return(0);
				    }

				    for (i = height - 1; i >= 0; i--)
				    {
				        for (j = 0; j < width; j++)
				        {
				            ipos = 3 * (width * i + j);
				            line[3*j] = screenCapture[ipos + 2];
				            line[3*j+1] = screenCapture[ipos + 1];
				            line[3*j+2] = screenCapture[ipos];
				        }
				        fwritecustom(line, bytesPerLine, 1, file);
				    }

				    free(line);
				alt_up_sd_card_fclose(file);
				printf("file closed\n");

				/*
				alt_up_sd_card_find_first(device_reference, a);
				printf("a: %s name: %s\n", a, name);
				if(strcmp(a, name) == 0){
					printf("FILE FOUND: %s\n", a);
					write_bmp(a, width, height, screenCapture);
				}
				else {
					while(alt_up_sd_card_find_next(a) != -1) {
						printf("a: %s name: %s\n", a, name);
						if(strcmp(a, name) == 0){
							printf("FILE FOUND: %s\n", a);
							write_bmp(a, width, height, screenCapture);
						}
					}
				}
				*/
			} else {
				printf("Unknown file system.\n");
			}
			connected = 1;
		} else if ((connected == 1) && (alt_up_sd_card_is_Present() == false)) {
			printf("Card disconnected.\n");
			connected = 0;
		}
	}
	else{
		printf("twas null\n");
	}
}
