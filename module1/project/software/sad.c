#include <stdlib.h>
#include <stdio.h>
#include "sad.h"

/*
 * Runtime: O(S*S*N*N)
 *
 * S = (WINDOW_SIZE - BLOCK_SIZE) / SEARCH_STEP
 * N = BLOCK_SIZE
 */

// width and height of tracking block
#define BLOCK_WIDTH 50
#define BLOCK_HEIGHT 50
// width and height of window
#define WINDOW_WIDTH 100
#define WINDOW_HEIGHT 100
// pixels to move block per step inside window
#define SEARCH_STEP 10


int SADPixel(Pixel *prev, Pixel *cur) {
    return abs(cur->rgb - prev->rgb);
}

int SADBlock(Block *prev, Block *cur) {
    int delta = 0;
    int i, j;
    Pixel *prevPixel, *curPixel;
    for(i=0; i < cur->width; ++i) {
        for(j=0; j < cur->height; ++j) {
            prevPixel = VideoGetPixel(prev->coord);
            curPixel = VideoGetPixel(cur->coord);
            delta += SADPixel(prevPixel, curPixel);
        }
    }
    return delta;
}

Block * SADWindow(Block *prev, Window *w) {
    return NULL;
}

Window * SADCenterWindow(Window *w) {
    return NULL;
}

Block * create_block(int x, int y, int width, int height) {
    Block * block = malloc(sizeof(Block));
    block->coord = malloc(sizeof(Coordinate));
    block->coord->x = x;
    block->coord->y = y;

    block->width = width;
    block->height = height;
    return block;
}

void destroy_block(Block *block) {
    free(block->coord);
    free(block);
}

int main() {
    int delta;
    Block *prev, *cur;
    prev = create_block(0, 0, 10, 10);
    cur = create_block(20, 0, 10, 10);

    delta = SADBlock(prev, cur);
    printf("Delta: %d\n", delta);

    destroy_block(prev);
    destroy_block(cur);

    return 0;
}
