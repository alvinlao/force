#ifndef WINDOW_H
#define WINDOW_H

#include "block.h"

typedef struct window {
    // Top Left
    Block * block;
    
    // Size of a step
    int stepSize;
} Window;

Window * WindowCreate(int x, int y, int width, int height, int stepSize);
void WindowDestroy(Window *);
int WindowGetWidth(Window *);
int WindowGetHeight(Window *);
int WindowGetX(Window *);
int WindowGetY(Window *);

#endif
