/*
 * video.c
 */

#include <stdlib.h>
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

    // How to get rgb
    PixelGetRGB(p);
}
