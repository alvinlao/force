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
int BlockGetX(Block *b);
int BlockGetY(Block *b);
int BlockGetWidth(Block *b);
int BlockGetHeight(Block *b);
void BlockSetX(Block *b, int x);
void BlockSetY(Block *b, int y);
void BlockSetWidth(Block *b, int width);
void BlockSetHeight(Block *b, int height);

#endif
