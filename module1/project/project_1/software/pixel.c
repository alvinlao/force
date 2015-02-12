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

/**
 * Separates the RGB value into the corresponding Red, Green, and Blue values.
 */
// [5 bits red, 6 bits green, 5 bits blue]
void PixelSetRGB2(Pixel *p, int rgb) {
    p->r = (char) (rgb & 0x1F);
    p->g = (char) ((rgb >> 5) & 0x3F);
    p->b = (char) ((rgb >> 11) & 0x1F);
}

int PixelGetRGB(Pixel *p) {
    int rgb = (p->r << 11) | (p->g << 5) | (p->b);
    return rgb;
}

void PixelSetX(Pixel *p, int x) {
    p->coordinate->x = x;
}

void PixelSetY(Pixel *p, int y) {
    p->coordinate->y = y;
}

int PixelGetX(Pixel *p) {
    return p->coordinate->x;
}

int PixelGetY(Pixel *p) {
    return p->coordinate->y;
}
