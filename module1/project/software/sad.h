#ifndef SAD_H
#define SAD_H

#include "video.h"
#include "pixel.h"
#include "block.h"
#include "window.h"

int SADPixel(Pixel *, Pixel *);
int SADBlock(Block *, Block *);
Block * SADWindow(Block *prev, Window *);
Window * SADCenterWindow(Window *);

#endif
