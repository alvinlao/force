/*
 * video.h
 * Interface for video in and out
 *
 */

#ifndef VIDEO_H
#define VIDEO_H

#include "coordinate.h"
#include "pixel.h"

// width and height of camera frame
#define FRAME_WIDTH 320
#define FRAME_HEIGHT 160

void VideoGetPixel(Pixel *pixel);
void VideoSetPixel(Pixel *pixel);

#endif
