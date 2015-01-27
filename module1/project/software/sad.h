#ifndef SAD_H
#define SAD_H

#include "video.h"
#include "pixel.h"
#include "block.h"
#include "window.h"

// width and height of tracking block
#define BLOCK_WIDTH 50
#define BLOCK_HEIGHT 50
// width and height of window
#define WINDOW_WIDTH 100
#define WINDOW_HEIGHT 100
// pixels to move block per step inside window
#define SEARCH_STEP 1
// width and height of camera frame
#define FRAME_WIDTH 1000
#define FRAME_HEIGHT 1000
// max delta
#define MAX_DELTA 1000000000

int SADPixel(Pixel *, Pixel *);
int SADBlock(Block *, Block *);
Block * SADTrack(Block *prev, Window *);
Window * SADCenterWindow(Block *, Window *);

#endif
