#include <stdlib.h>
#include "block.h"

Block * BlockCreate(int x, int y, int width, int height) {
    Block * b = malloc(sizeof(Block));
    b->coord = CoordinateCreate(x, y);
    b->width = width;
    b->height = height;
    return b;
}

void BlockDestroy(Block *block) {
    CoordinateDestroy(block->coord);
    free(block);
}

int BlockGetX(Block *b) {
    return b->coord->x;
}

int BlockGetY(Block *b) {
    return b->coord->y;
}

int BlockGetWidth(Block *b) {
    return b->width;
}

int BlockGetHeight(Block *b) {
    return b->height;
}

void BlockSetX(Block *b, int x) {
    b->coord->x = x;
}

void BlockSetY(Block *b, int y) {
    b->coord->y = y;
}

void BlockSetWidth(Block *b, int width) {
    b->width = width;
}

void BlockSetHeight(Block *b, int height) {
    b->height = height;
}

