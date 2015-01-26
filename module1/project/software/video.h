/*
 * video.h
 * Interface for video in and out
 *
 */

#ifndef VIDEO_H
#define VIDEO_H

typedef struct coordinate {
    int x;
    int y;
} Coordinate;

typedef struct pixel {
    Coordinate *coordinate;
    int rgb;
} Pixel;


Pixel * VideoGetPixel(Coordinate *coordinate);
void VideoSetPixel(Pixel *pixel);

#endif
