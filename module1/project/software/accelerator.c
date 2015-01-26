#include "accelerator.h"

/*
 * Get SAD for pixel
 * @param prev the pixel to compare to
 * @param cur the current pixel
 * @return delta between previous pixel and current pixel
 */
int AcceleratorSADPixel(Pixel *prev, Pixel *cur) {
    return 0;
}

/*
 * Get SAD for block
 * @param prev The previous targeted block
 * @param cur The current block
 * @return delta between previous block and current block
 */
int AcceleratorSADBlock(Block *prev, Block *cur) {
    return 0;
}

/*
 * Get SAD for window
 * @param prev The previous targeted block
 * @param w The window
 * @return the minimum difference block
 */
Block * AcceleratorSADWindow(Block *prev, Window *w) {
    return NULL;
}
