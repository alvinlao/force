import cv
import time
from sad import *

# Setup camera
CAMERA_INDEX = 0
cv.NamedWindow("Video", cv.CV_WINDOW_AUTOSIZE)
capture = cv.CaptureFromCAM(CAMERA_INDEX)

# Get width and height
frame = cv.QueryFrame(capture)
width, height = cv.GetSize(frame)

#Get rid of the first few frames
for i in xrange(100):
    frame = cv.QueryFrame(capture)
    cv.WaitKey(10)

prev_frame = cv.CloneImage(frame)
windowx, windowy = width/2 - WINDOW_SIZE/2 , height/2 - WINDOW_SIZE/2
x, y = windowx, windowy
    
"""
while True:
    cv.WaitKey(10)
    frame = cv.QueryFrame(capture)
    print "New"
    print block_step(frame, frame, x, y, x, y)
    print block_step(frame, frame, x+25, y, x, y)
    print block_step(frame, frame, x+100, y, x, y)

    draw_box(frame, x, y, BLOCK_SIZE, RED)
    draw_box(frame, x+25, y, BLOCK_SIZE, BLUE)
    draw_box(frame, x+100, y, BLOCK_SIZE, GREEN)

    cv.ShowImage("w0", frame)
    pass
"""

while True:
    frame = cv.QueryFrame(capture)

    # Block coords
    #print block_step(prev_frame, frame, x, y, x, y)
    print "{0}, {1}".format(x, y)
    x, y = step(prev_frame, frame, windowx, windowy, x, y)

    prev_frame = cv.CloneImage(frame)

    draw_box(frame, x, y, BLOCK_SIZE, RED)
    draw_box(frame, windowx, windowy, WINDOW_SIZE, GREEN)

    cv.ShowImage("w0", frame)

    #print "{0}, {1}".format(windowx, windowy)
    #print "{0}, {1}".format(x, y)

    windowx, windowy = center_window(x, y, width, height)

    cv.WaitKey(10)
