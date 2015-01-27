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

int main() {
    int delta;
    Block *prev, *cur;
    prev = BlockCreate(0, 0, 10, 10);
    cur = BlockCreate(20, 0, 10, 10);

    delta = SADBlock(prev, cur);
    printf("Delta: %d\n", delta);

    BlockDestroy(prev);
    BlockDestroy(cur);

    Window *w = WindowCreate(1, 2, 3, 4, 5);
    printf("X: %d\n", WindowGetX(w));
    printf("Y: %d\n", WindowGetY(w));
    printf("Width: %d\n", WindowGetWidth(w));
    printf("Height :%d\n", WindowGetHeight(w));
    
    WindowDestroy(w);
    return 0;
}
