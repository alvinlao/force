/*
 * pixel.h
 */

#ifndef PIXEL_H
#define PIXEL_H

#include "coordinate.h"

typedef struct pixel {
    Coordinate *coordinate;
    char r;
    char g;
    char b;
} Pixel;


Pixel *PixelCreate(int x, int y, int rgb);
void PixelDestroy(Pixel *);
void PixelSetRGB(Pixel *, int);

#endif
