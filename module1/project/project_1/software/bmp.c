#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "bmp.h"

int read_bmp(const char *filename, int *width, int *height, unsigned char *rgb)
{
    // Not implemented
}

int write_bmp(const char *name, int width, int height, char *rgb)
{
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

    short int file = alt_up_sd_card_fopen(name, 1);
    if (file == NULL) return(0);
  
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
  
    line = malloc(bytesPerLine);
    if (line == NULL)
    {
        fprintf(stderr, "Can't allocate memory for BMP file.\n");
        return(0);
    }

    for (i = height - 1; i >= 0; i--)
    {
        for (j = 0; j < width; j++)
        {
            ipos = 3 * (width * i + j);
            line[3*j] = rgb[ipos + 2];
            line[3*j+1] = rgb[ipos + 1];
            line[3*j+2] = rgb[ipos];
        }
        fwritecustom(line, bytesPerLine, 1, file);
    }

    free(line);
    alt_up_sd_card_fclose(file);

    return(1);
}

void fwritecustom(const void *ptr, size_t size, size_t nmemb, short int file_handle){
	int i;
	for (i = 0; i < size; i++){
		alt_up_sd_card_write(file_handle, (ptr+i));
	}
}
