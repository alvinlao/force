/*
 * video.h
 * Interface for video in and out
 *
 */

#ifndef VIDEO_H
#define VIDEO_H

#include "coordinate.h"
#include "pixel.h"

void VideoGetPixel(Pixel *pixel);
void VideoSetPixel(Pixel *pixel);

#endif
