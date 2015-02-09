#ifndef SCREENSHOT_H
#define SCREENSHOT_H

#include "bmp.h"
#include "video.h"

void ScreenShotInit(alt_up_pixel_buffer_dma_dev *pixelBuffer);
void SavePixelArray();
void SaveBmpSDCARD();

#endif
