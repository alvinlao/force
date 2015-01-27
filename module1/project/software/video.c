/*
 * video.c
 */

#include <stdlib.h>
#include "video.h"

/*
 * Get the pixel at the given coordinate
 *
 * @param coordinate Coordinate of the desired pixel
 * @return Pixel* pointer to a pixel
 */
Pixel * VideoGetPixel(Coordinate *coordinate) {
    // TODO: Access hardware
    // This is just test code
    int x = coordinate->x;
    int y = coordinate->y;

    return PixelCreate(x, y, x*y);
}

/*
 * Set the pixel
 * 
 * @param pixel desired pixel
 */
void VideoSetPixel(Pixel *pixel) {
    // TODO: Access hardware
}
