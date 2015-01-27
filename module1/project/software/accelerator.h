#ifndef ACCELERATOR_H
#define ACCELERATOR_H

#include "video.h"
#include "sad.h"

int AcceleratorSADPixel(Pixel *, Pixel *);
int AcceleratorSADBlock(Block *, Block *);
Block * AcceleratorSADWindow(Block *prev, Window *w);

#endif
