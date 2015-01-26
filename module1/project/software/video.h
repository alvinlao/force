/*
 * video.h
 * Interface for video in and out
 *
 */

#ifndef VIDEO_H
#define VIDEO_H

typedef struct pixel {
    int x;
    int y;
    int rgb;
} Pixel;

Pixel * VideoGetPixel(int x, int y);
void VideoSetPixel(Pixel *pixel);

#endif
