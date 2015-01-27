#include <stdlib.h>
#include <stdio.h>
#include "sad.h"

/*
 * Runtime: O(S*S*N*N)
 *
 * S = (WINDOW_SIZE - BLOCK_SIZE) / SEARCH_STEP
 * N = BLOCK_SIZE
 */

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

Block * SADTrack(Block *b, Window *w) {
    int searchesX = ((WindowGetWidth(w) - BlockGetWidth(b)) / SEARCH_STEP) - 1;
    int searchesY = ((WindowGetHeight(w) - BlockGetHeight(b)) / SEARCH_STEP) - 1;

    // It would be cheaper to use primitives, but this is cleaner
    Block *bestBlock = BlockCreate(0, 0, BLOCK_WIDTH, BLOCK_HEIGHT);
    Block *curBlock = BlockCreate(0, 0, BLOCK_WIDTH, BLOCK_HEIGHT);
    int bestBlockDelta = MAX_DELTA;
    int curBlockDelta = 0;

    int i, j, x, y;
    int windowOriginX = WindowGetX(w);
    int windowOriginY = WindowGetY(w);
    for(i = 0; i < searchesX; ++i) {
        for(j = 0; j < searchesY; ++j) {
            x = windowOriginX + (i * SEARCH_STEP);
            y = windowOriginY + (j * SEARCH_STEP);
            BlockSetX(curBlock, x);
            BlockSetY(curBlock, y);

            curBlockDelta = SADBlock(b, curBlock);
            if(curBlockDelta < bestBlockDelta) {
                printf("%d, %d\n", x, y);
                BlockSetX(bestBlock, x);
                BlockSetY(bestBlock, y);
                bestBlockDelta = curBlockDelta;
            }
        }
    }
    return bestBlock;
}

Window * SADCenterWindow(Block *b, Window *w) {
    int blockXMid = BlockGetX(b) + (BlockGetWidth(b)/2);
    int blockYMid = BlockGetY(b) + (BlockGetHeight(b)/2);
    int newWindowX = blockXMid - (WindowGetWidth(w)/2);
    int newWindowY = blockYMid - (WindowGetHeight(w)/2);

    // Assert bounds
    if(newWindowX < 0) newWindowX = 0;
    if(newWindowY < 0) newWindowY = 0;
    if(newWindowX > FRAME_WIDTH) newWindowX = FRAME_WIDTH - WindowGetWidth(w);
    if(newWindowY > FRAME_HEIGHT) newWindowY = FRAME_HEIGHT - WindowGetHeight(w);

    // Update assertions
    WindowSetX(w, newWindowX);
    WindowSetY(w, newWindowY);
    
    return w;
}
