/*
 * video.c
 */

#include <stdlib.h>
#include <stdio.h>
#include "video.h"
#include <io.h>
#include "altera_up_avalon_video_pixel_buffer_dma.h"


// TODO Replace with hardware
int *mem;
int BlockWidth, BlockHeight;
alt_up_pixel_buffer_dma_dev *VideoPixelBuffer;


/*
 * Initialize video module
 */
void VideoInit(alt_up_pixel_buffer_dma_dev *pixelBuffer) {
	VideoPixelBuffer = pixelBuffer;
}

/*
 * Initialize memory for saving pixel block
 * @param width 
 */
void VideoInitMemoryBlock(int width, int height) {
    BlockWidth = width;
    BlockHeight = height;
    mem = malloc(sizeof(int) * width * height);
}

/*
 * Copy a block of pixels from pixel buffer to static buffer
 *
 * @param x left coordinate
 * @param y top coordinate
 * @param p pixel for intermediate calculations
 */
void VideoCopyBlock(int x, int y, Pixel *p) {
    int i, j;
    for(i=0; i<BlockWidth; ++i) {
        for(j=0; j<BlockHeight; ++j) {
        	PixelSetX(p, x+i);
        	PixelSetY(p, y+j);
        	VideoGetPixel(p);
            mem[i*BlockWidth + j] = PixelGetRGB(p);
        }
    }
}

/*
 * Get pixel from static buffer
 *
 * @param pixel with target coordinates
 * NOTE: 0 <= x <= BLOCK_WIDTH, 0 <= y <= BLOCK_HEIGHT
 */
void VideoGetPixelBlock(Pixel *p) {
    // TODO Access hardware
    // How to get coords
    int x = PixelGetX(p);
    int y = PixelGetY(p);

    // How to set RGB
    int rgb = mem[x*BlockWidth + y];
    PixelSetRGB(p, rgb);
}

/*
 * Get the pixel at the given coordinate
 *
 * @param pixel contains the coordinates of desired pixel. This will hold the pixel color on return.
 */
void VideoGetPixel(Pixel *p) {
    // TODO: Access hardware

    // How to access coords
    int x = PixelGetX(p);
    int y = PixelGetY(p);

    // Assert bounds
    if(x < 0 || x > FRAME_WIDTH || y < 0 || y > FRAME_HEIGHT) {
        fprintf(stderr, "VideoGetPixel: coordinates outside video bounds.");
        PixelSetRGB(p, 0);
        return;
    }
    unsigned int addr = 0;
	addr |= ((x & VideoPixelBuffer->x_coord_mask) << VideoPixelBuffer->x_coord_offset);
	addr |= ((y & VideoPixelBuffer->y_coord_mask) << VideoPixelBuffer->y_coord_offset);

	int rgb;
    rgb = (IORD_32DIRECT(VideoPixelBuffer, addr));
    PixelSetRGB(p, rgb);
}

/*
 * Set the pixel
 * 
 * @param pixel contains target coords and color
 */
void VideoSetPixel(Pixel *p) {
    // TODO: Access hardware

    // How to access coords
    int x = PixelGetX(p);
    int y = PixelGetY(p);

    // Assert bounds
    if(x < 0 || x > FRAME_WIDTH || y < 0 || y > FRAME_HEIGHT) {
        fprintf(stderr, "VideoSetPixel: coordinates outside video bounds.");
        return;
    }

    // How to get rgb
    PixelGetRGB(p);
}
