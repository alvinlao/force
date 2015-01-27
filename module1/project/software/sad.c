#include <stdlib.h>
#include <stdio.h>
#include "sad.h"

/*
 * Runtime: O(S*S*N*N)
 *
 * S = (WINDOW_SIZE - BLOCK_SIZE) / SEARCH_STEP
 * N = BLOCK_SIZE
 */

/*
 * Perform SAD on two pixels
 * @param a pixel A
 * @param b pixel B
 * @return sum of absolute difference of all three color components
 */
int SADPixel(Pixel *a, Pixel *b) {
    char dr, dg, db;
    dr = abs(a->r - b->r);
    dg = abs(a->g - b->g);
    db = abs(a->b - b->b);
    
    return dr + dg + db;
}

/*
 * Perform SAD on a block of pixels
 * @param prev The comparate block
 * @param cur The candidate block
 * @param pixelA Empty pixel
 * @param pixelB Empty pixel
 * @return sum of absolute differences of the whole block
 */
int SADBlock(Block *prev, Block *cur, Pixel *pixelA, Pixel *pixelB) {
    int delta = 0;
    int i, j;
    Pixel *prevPixel, *curPixel;
    for(i=0; i < BLOCK_WIDTH; ++i) {
        for(j=0; j < BLOCK_HEIGHT; ++j) {
            PixelSetCoord(pixelA, prev->coord);
            PixelSetCoord(pixelB, cur->coord);
            
            VideoGetPixel(pixelA);
            VideoGetPixel(pixelB);

            delta += SADPixel(pixelA, pixelB);
        }
    }
    return delta;
}

/*
 * The empty structs are to prevent dynamic allocation
 *
 * @param prevBlock The block we are looking for
 * @param resBlock an empty block to hold the result
 * @param window search window
 * @param pixelA empty pixel for calculations
 * @param pixelB empty pixel for calculations
 * @return void
 */
void SADTrack(Block *prevBlock, Block *resBlock, Block *window, Pixel *pixelA, Pixel *pixelB) {
    int searchesX = ((WINDOW_WIDTH - BLOCK_WIDTH) / SEARCH_STEP) - 1;
    int searchesY = ((WINDOW_HEIGHT - BLOCK_HEIGHT) / SEARCH_STEP) - 1;

    // Avoiding dynamic allocation in a hot path
    int bestBlockX, bestBlockY;
    int bestBlockDelta = MAX_DELTA;
    int curBlockDelta = 0;

    int i, j, x, y;
    int windowOriginX = BlockGetX(window);
    int windowOriginY = BlockGetY(window);
    for(i = 0; i < searchesX; ++i) {
        for(j = 0; j < searchesY; ++j) {
            x = windowOriginX + (i * SEARCH_STEP);
            y = windowOriginY + (j * SEARCH_STEP);
            BlockSetX(resBlock, x);
            BlockSetY(resBlock, y);

            curBlockDelta = SADBlock(prevBlock, resBlock, pixelA, pixelB);
            if(curBlockDelta < bestBlockDelta) {
                bestBlockX = x;
                bestBlockY = y;
                bestBlockDelta = curBlockDelta;
            }
        }
    }

    // Place results in block
    BlockSetX(resBlock, bestBlockX);
    BlockSetY(resBlock, bestBlockY);
}

/*
 * @param b is the block we are centering on
 * @param w is the window
 */
void SADCenterWindow(Block *b, Block *w) {
    int blockXMid = BlockGetX(b) + (BLOCK_WIDTH/2);
    int blockYMid = BlockGetY(b) + (BLOCK_WIDTH/2);
    int newWindowX = blockXMid - (WINDOW_WIDTH/2);
    int newWindowY = blockYMid - (WINDOW_HEIGHT/2);

    // Assert bounds
    if(newWindowX < 0) newWindowX = 0;
    if(newWindowY < 0) newWindowY = 0;
    if(newWindowX > FRAME_WIDTH) newWindowX = FRAME_WIDTH - WINDOW_WIDTH;
    if(newWindowY > FRAME_HEIGHT) newWindowY = FRAME_HEIGHT - WINDOW_HEIGHT;

    // Place results in block
    BlockSetX(w, newWindowX);
    BlockSetY(w, newWindowY);
}
