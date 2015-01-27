#ifndef BLOCK_H
#define BLOCK_H

#include "coordinate.h"

typedef struct block {
    // Top Left
    Coordinate* coord;

    int width;
    int height;
} Block;

Block * BlockCreate(int x, int y, int width, int height);
void BlockDestroy(Block *block);

#endif
