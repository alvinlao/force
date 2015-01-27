#include <stdlib.h>
#include <stdio.h>
#include "sad.h"

int main() {
    int delta;
    Pixel *pixelA, *pixelB;
    Block *blockA, *blockB, *blockC, *emptyBlock;

    // Init pixels
    pixelA = PixelCreate(0, 0, 0);
    pixelB = PixelCreate(0, 0, 0);

    // Init blocks
    blockA = BlockCreate(0, 0);
    blockB = BlockCreate(50, 50);
    blockC = BlockCreate(100, 100);
    emptyBlock = BlockCreate(0, 0);
    
    Block *w = BlockCreate(10, 10);

    // Init video block
    VideoInitMemoryBlock(BLOCK_WIDTH, BLOCK_HEIGHT);

    // Test SADBlock
    printf("=======================\n");
    printf("Test SADBlock\n");
    printf("=======================\n");
    VideoCopyBlock(BlockGetX(blockA), BlockGetY(blockA));
    printf("AA: %d\n", SADBlock(blockA, blockA, pixelA, pixelB));

    VideoCopyBlock(BlockGetX(blockB), BlockGetY(blockB));
    printf("BB: %d\n", SADBlock(blockB, blockB, pixelA, pixelB));

    VideoCopyBlock(BlockGetX(blockC), BlockGetY(blockC));
    printf("CC: %d\n", SADBlock(blockC, blockC, pixelA, pixelB));

    VideoCopyBlock(BlockGetX(blockA), BlockGetY(blockA));
    printf("AB: %d\n", SADBlock(blockA, blockB, pixelA, pixelB));

    VideoCopyBlock(BlockGetX(blockA), BlockGetY(blockA));
    printf("AC: %d\n", SADBlock(blockA, blockC, pixelA, pixelB));

    VideoCopyBlock(BlockGetX(blockB), BlockGetY(blockB));
    printf("BC: %d\n", SADBlock(blockB, blockC, pixelA, pixelB));
    
    VideoCopyBlock(BlockGetX(blockC), BlockGetY(blockC));
    printf("C?: %d\n", SADBlock(blockC, emptyBlock, pixelA, pixelB));

    // Test SADCenterWindow
    printf("=======================\n");
    printf("Test SADCenterWindow\n");
    printf("=======================\n");
    printf("X0: %d\n", BlockGetX(w));
    printf("Y0: %d\n", BlockGetY(w));
    printf("Xf: %d\n", BlockGetX(w) + WINDOW_WIDTH);
    printf("Yf: %d\n", BlockGetY(w) + WINDOW_HEIGHT);

    printf("BlockX: %d\n", BlockGetX(blockC));
    printf("BlockY: %d\n", BlockGetY(blockC));

    SADCenterWindow(blockC, w);
    printf("X0: %d\n", BlockGetX(w));
    printf("Y0: %d\n", BlockGetY(w));
    printf("Xf: %d\n", BlockGetX(w) + WINDOW_WIDTH);
    printf("Yf: %d\n", BlockGetY(w) + WINDOW_HEIGHT);
    
    // Test SADTrack
    printf("=======================\n");
    printf("Test SADTrack\n");
    printf("=======================\n");
    Block *trackBlock = blockC;
    VideoCopyBlock(BlockGetX(trackBlock), BlockGetY(trackBlock));

    printf("X0: %d\n", BlockGetX(trackBlock));
    printf("Y0: %d\n", BlockGetY(trackBlock));
    SADTrack(trackBlock, emptyBlock, w, pixelA, pixelB);
    printf("X: %d\n", BlockGetX(emptyBlock));
    printf("Y: %d\n", BlockGetY(emptyBlock));
    printf("Delta: %d\n", SADBlock(trackBlock, emptyBlock, pixelA, pixelB));

    // Test destroys
    BlockDestroy(blockA);
    BlockDestroy(blockB);
    BlockDestroy(blockC);
    BlockDestroy(emptyBlock);
    BlockDestroy(w);

    return 0;
}
