/*
 * coordinate.h
 */

#ifndef COORDINATE_H
#define COORDINATE_H

typedef struct coordinate {
    int x;
    int y;
} Coordinate;


Coordinate * CoordinateCreate(int x, int y);
void CoordinateDestroy(Coordinate *);

#endif
