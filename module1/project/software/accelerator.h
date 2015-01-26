#ifndef ACCELERATOR_H
#define ACCELERATOR_H

#include "video.h"

typedef struct block {
    // Top Left
    Coordinate* coord;

    int width;
    int height;
} Block;

typedef struct window {
    // Top Left
    Coordinate* coord;

    int width;
    int height;
    
    // Size of a step
    int stepSize;
} Window;


int AcceleratorSADPixel(Pixel *, Pixel *);
int AcceleratorSADBlock(Block *, Block *);
Block * AcceleratorSADWindow(Block *prev, Window *w) {

#endif
