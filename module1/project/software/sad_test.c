#include <stdlib.h>
#include <stdio.h>
#include "sad.h"

int main() {
    int delta;
    Block *blockA, *blockB, *blockC;

    blockA = BlockCreate(0, 0, BLOCK_WIDTH, BLOCK_HEIGHT);
    blockB = BlockCreate(50, 50, BLOCK_WIDTH, BLOCK_HEIGHT);
    blockC = BlockCreate(100, 100, BLOCK_WIDTH, BLOCK_HEIGHT);
    Window *w = WindowCreate(10, 10, WINDOW_WIDTH, WINDOW_HEIGHT, SEARCH_STEP);

    // Test SADBlock
    printf("=======================\n");
    printf("Test SADBlock\n");
    printf("=======================\n");
    delta = SADBlock(blockA, blockC);
    printf("Delta: %d\n", delta);

    // Test SADCenterWindow
    printf("=======================\n");
    printf("Test SADCenterWindow\n");
    printf("=======================\n");
    printf("X: %d\n", WindowGetX(w));
    printf("Y: %d\n", WindowGetY(w));
    printf("Width: %d\n", WindowGetWidth(w));
    printf("Height :%d\n", WindowGetHeight(w));

    printf("BlockX: %d\n", BlockGetX(blockC));
    printf("BlockY: %d\n", BlockGetY(blockC));

    SADCenterWindow(blockC, w);
    printf("X: %d\n", WindowGetX(w));
    printf("Y: %d\n", WindowGetY(w));
    printf("Width: %d\n", WindowGetWidth(w));
    printf("Height :%d\n", WindowGetHeight(w));
    
    // Test SADTrack
    printf("=======================\n");
    printf("Test SADTrack\n");
    printf("=======================\n");
    printf("AC: %d\n", SADBlock(blockA, blockC));
    printf("BC: %d\n", SADBlock(blockB, blockC));
    blockC = SADTrack(blockC, w);
    printf("X: %d\n", BlockGetX(blockC));
    printf("Y: %d\n", BlockGetY(blockC));

    // Test destroys
    BlockDestroy(blockA);
    BlockDestroy(blockB);
    BlockDestroy(blockC);
    WindowDestroy(w);

    return 0;
}
