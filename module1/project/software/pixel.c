#include <stdlib.h>
#include "pixel.h"

Pixel *PixelCreate(int x, int y, int rgb) {
    Pixel * p = malloc(sizeof(Pixel));
    p->coordinate = CoordinateCreate(x, y);
    p->rgb = rgb;
    return p;
}

void PixelDestroy(Pixel *p) {
    CoordinateDestroy(p->coordinate);
    free(p);
}
