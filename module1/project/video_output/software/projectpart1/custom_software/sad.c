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
 * @param track The tracked block
 * @param candidate The candidate block
 * @param pixelA Empty pixel
 * @param pixelB Empty pixel
 * @return sum of absolute differences of the whole block
 */
int SADBlock(Block *track, Block *candidate, Pixel *pixelA, Pixel *pixelB) {
    int delta = 0;
    int i, j;
    int x = BlockGetX(candidate);
    int y = BlockGetY(candidate);
    for(i = 0; i < BLOCK_WIDTH; ++i) {
        for(j = 0; j < BLOCK_HEIGHT; ++j) {
            PixelSetX(pixelA, i);
            PixelSetY(pixelA, j);
            PixelSetX(pixelB, x + i);
            PixelSetY(pixelB, y + j);
            
            VideoGetPixelBlock(pixelA);
            VideoGetPixel(pixelB);

            delta += SADPixel(pixelA, pixelB);
        }
    }

    return delta;
}

/*
 * Given a target block, find minimal SAD block among all candidates inside window
 *
 * NOTE: The empty structs are to prevent dynamic allocation
 *
 * @param targetBlock The block we are comparing to
 * @param resultBlock used for calculations. Holds final result
 * @param window search window
 * @param pixelA empty pixel for calculations
 * @param pixelB empty pixel for calculations
 * @return void
 */
void SADTrack(Block *targetBlock, Block *resultBlock, Block *window, Pixel *pixelA, Pixel *pixelB) {
    int searchesX = ((WINDOW_WIDTH - BLOCK_WIDTH) / SEARCH_STEP) + 1;
    int searchesY = ((WINDOW_HEIGHT - BLOCK_HEIGHT) / SEARCH_STEP) + 1;

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

            // Use result block for intermediate calculations
            BlockSetX(resultBlock, x);
            BlockSetY(resultBlock, y);

            curBlockDelta = SADBlock(targetBlock, resultBlock, pixelA, pixelB);

            if(curBlockDelta <= bestBlockDelta) {
                bestBlockX = x;
                bestBlockY = y;
                bestBlockDelta = curBlockDelta;
            }
        }
    }

    // Place results in block
    BlockSetX(resultBlock, bestBlockX);
    BlockSetY(resultBlock, bestBlockY);

    // Center window
    SADCenterWindow(resultBlock, window);

    // Save best block to memory
    VideoCopyBlock(bestBlockX, bestBlockY);
}

/*
 * @param b is the block we are centering on
 * @param w is the window
 */
void SADCenterWindow(Block *b, Block *w) {
    int blockXMid = BlockGetX(b) + (BLOCK_WIDTH/2);
    int blockYMid = BlockGetY(b) + (BLOCK_HEIGHT/2);
    int newWindowX = blockXMid - (WINDOW_WIDTH/2);
    int newWindowY = blockYMid - (WINDOW_HEIGHT/2);

    // Assert bounds
    if(newWindowX < 0) newWindowX = 0;
    if(newWindowY < 0) newWindowY = 0;
    if(newWindowX + WINDOW_WIDTH > FRAME_WIDTH) newWindowX = FRAME_WIDTH - WINDOW_WIDTH;
    if(newWindowY + WINDOW_HEIGHT > FRAME_HEIGHT) newWindowY = FRAME_HEIGHT - WINDOW_HEIGHT;

    // Place results in block
    BlockSetX(w, newWindowX);
    BlockSetY(w, newWindowY);
}

/*
 * Initializes required data structures for SADTrack
 * @param x0 target starting position x
 * @param x1 target starting position y
 */
void SADInit(int x0, int y0, Block **targetBlock, Block **resultBlock, Block **window, Pixel **pixelA, Pixel **pixelB) {
	// Create blocks
	*targetBlock = BlockCreate(x0, y0);
	*resultBlock = BlockCreate(0, 0);

	// Create window
	*window = BlockCreate(0, 0);
	SADCenterWindow(*targetBlock, *window);

	// Create pixels
	*pixelA = PixelCreate(0, 0, 0);
	*pixelB = PixelCreate(0, 0, 0);
}
