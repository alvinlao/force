#include <stdlib.h>
#include "block.h"

Block * BlockCreate(int x, int y) {
    Block * b = malloc(sizeof(Block));
    b->coord = CoordinateCreate(x, y);
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

void BlockSetX(Block *b, int x) {
    b->coord->x = x;
}

void BlockSetY(Block *b, int y) {
    b->coord->y = y;
}
