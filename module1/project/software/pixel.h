/*
 * pixel.h
 */

#ifndef PIXEL_H
#define PIXEL_H

#include "coordinate.h"

typedef struct pixel {
    Coordinate *coordinate;
    int rgb;
} Pixel;


Pixel *PixelCreate(int x, int y, int rgb);
void PixelDestroy(Pixel *);

#endif
