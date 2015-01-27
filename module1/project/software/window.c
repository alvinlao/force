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
    return BlockGetWidth(w->block);
}

int WindowGetHeight(Window *w) {
    return BlockGetHeight(w->block);
}

int WindowGetX(Window *w) {
    return BlockGetX(w->block);
}

int WindowGetY(Window *w) {
    return BlockGetY(w->block);
}

void WindowSetX(Window *w, int x) {
    BlockSetX(w->block, x);
}

void WindowSetY(Window *w, int y) {
    BlockSetY(w->block, y);
}

void WindowSetWidth(Window *w, int width) {
    BlockSetWidth(w->block, width);
}

void WindowSetHeight(Window *w, int height) {
    BlockSetHeight(w->block, height);
}

