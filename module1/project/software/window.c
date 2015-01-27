#include <stdlib.h>
#include "window.h"

Window * WindowCreate(int x, int y, int width, int height, int stepSize) {
    Window * w = malloc(sizeof(Window));
    w->block = BlockCreate(x, y, width, height);
    w->stepSize = stepSize;
    return w;
}

void WindowDestroy(Window *w) {
    BlockDestroy(w->block);
    free(w);
}

int WindowGetWidth(Window *w) {
    return w->block->width;
}

int WindowGetHeight(Window *w) {
    return w->block->height;
}

int WindowGetX(Window *w) {
    return w->block->coord->x;
}

int WindowGetY(Window *w) {
    return w->block->coord->y;
}

