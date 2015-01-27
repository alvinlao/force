#include <stdlib.h>
#include "pixel.h"

Pixel *PixelCreate(int x, int y, int rgb) {
    Pixel * p = malloc(sizeof(Pixel));
    p->coordinate = CoordinateCreate(x, y);
    PixelSetRGB(p, rgb);

    return p;
}

void PixelDestroy(Pixel *p) {
    CoordinateDestroy(p->coordinate);
    free(p);
}

// [5 bits red, 6 bits green, 5 bits blue]
void PixelSetRGB(Pixel *p, int rgb) {
    p->r = (char) (rgb & 0x1F);
    p->g = (char) (rgb & 0x3F);
    p->b = (char) (rgb & 0x1F);
}

int PixelGetRGB(Pixel *p) {
    int rgb = (p->r << 11) | (p->g << 5) | (p->b);
    return rgb;
}

void PixelSetCoord(Pixel *p, Coordinate *c) {
    p->coordinate = c;
}

int PixelGetX(Pixel *p) {
    return p->coordinate->x;
}

int PixelGetY(Pixel *p) {
    return p->coordinate->y;
}
