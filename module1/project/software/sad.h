#ifndef SAD_H
#define SAD_H

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


int SADPixel(Pixel *, Pixel *);
int SADBlock(Block *, Block *);
Block * SADWindow(Block *prev, Window *);
Window * SADCenterWindow(Window *);

#endif
