#include <stdlib.h>
#include "coordinate.h"

Coordinate * CoordinateCreate(int x, int y) {
    Coordinate * c = malloc(sizeof(Coordinate));
    c->x = x;
    c->y = y;
    return c;
}

void CoordinateDestroy(Coordinate *coord) {
    free(coord);
}
