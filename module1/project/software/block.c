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
