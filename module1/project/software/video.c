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
    Pixel * pixel = malloc(sizeof(Pixel));

    if(coordinate->x > 10)
        pixel->rgb = 20;
    else
        pixel->rgb = 10;

    return pixel;
}

/*
 * Set the pixel
 * 
 * @param pixel desired pixel
 */
void VideoSetPixel(Pixel *pixel) {
}
