/*
 * video.h
 * Interface for video in and out
 *
 */

#ifndef VIDEO_H
#define VIDEO_H

#include "coordinate.h"
#include "pixel.h"

Pixel * VideoGetPixel(Coordinate *coordinate);
void VideoSetPixel(Pixel *pixel);

#endif
