#ifndef BLOCK_H
#define BLOCK_H

#include "coordinate.h"

typedef struct block {
    // Top Left
    Coordinate* coord;
} Block;

Block * BlockCreate(int x, int y);
void BlockDestroy(Block *block);
int BlockGetX(Block *b);
int BlockGetY(Block *b);
void BlockSetX(Block *b, int x);
void BlockSetY(Block *b, int y);

#endif
