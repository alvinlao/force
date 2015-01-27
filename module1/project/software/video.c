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
    Pixel * pixel = malloc(sizeof(Pixel));
    pixel->rgb = coordinate->x * coordinate->y;
    return pixel;
}

/*
 * Set the pixel
 * 
 * @param pixel desired pixel
 */
void VideoSetPixel(Pixel *pixel) {
    // TODO: Access hardware
}
