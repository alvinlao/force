#ifndef SAD_H
#define SAD_H

#include "video.h"
#include "pixel.h"
#include "block.h"

// width and height of tracking block
#define BLOCK_WIDTH 8
#define BLOCK_HEIGHT 8
// width and height of window
#define WINDOW_WIDTH 24
#define WINDOW_HEIGHT 24
// pixels to move block per step inside window
#define SEARCH_STEP 1
// max delta
#define MAX_DELTA 1000000000

int SADPixel(Pixel *, Pixel *);
int SADBlock(Block *, Block *, Pixel *, Pixel *);
void SADTrack(Block *, Block *, Block *, Pixel *, Pixel *);
void SADCenterWindow(Block *, Block *);
void SADInit(int, int, Block **, Block **, Block **, Pixel **, Pixel **);

#endif
