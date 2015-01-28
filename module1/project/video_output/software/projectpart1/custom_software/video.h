/*
 * video.h
 * Interface for video in and out
 *
 */

#ifndef VIDEO_H
#define VIDEO_H

#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include "coordinate.h"
#include "pixel.h"

// width and height of camera frame
#define FRAME_WIDTH 320
#define FRAME_HEIGHT 160

void VideoInit(alt_up_pixel_buffer_dma_dev *pixelBuffer);
void VideoInitMemoryBlock(int width, int height);
void VideoCopyBlock(int, int);
void VideoGetPixelBlock(Pixel *);
void VideoGetPixel(Pixel *);
void VideoSetPixel(Pixel *);

#endif
