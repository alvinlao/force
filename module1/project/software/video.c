/*
 * video.c
 */

#include <stdlib.h>
#include <stdio.h>
#include "video.h"

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

    // How to set RGB
    int rgb = x*y;
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
