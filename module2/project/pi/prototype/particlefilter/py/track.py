import cv 
from helper import *
from particlefilter import *
from colortracker import ColorTracker
from point import Point


# Constants


# Setup camera
CAMERA_INDEX = 0
cv.NamedWindow("Video", cv.CV_WINDOW_AUTOSIZE)
capture = cv.CaptureFromCAM(CAMERA_INDEX)

# Get width and height
frame = cv.QueryFrame(capture)
width, height = cv.GetSize(frame)
print(width, height)

# Get rid of the first few frames
"""
for i in xrange(100):
    frame = cv.QueryFrame(capture)
    cv.WaitKey(10)
"""

# Tracking algorithm
ct = ColorTracker(frame_width=320, frame_height=240, color=(255, 255, 255), n=5)
measurements = []

# Filter stuff
pf = ParticleFilter(320, 240, 500)

# Center particles on filter
pf.run([Point(160, 120, 0)])

x, y = (0, 0);

while True:
    frame = cv.QueryFrame(capture)

    measurements = ct.track(frame)
    best = pf.run(measurements)
    x, y = best.x, best.y

    for measurement in measurements:
        draw_box(frame, measurement.x, measurement.y, 5, (0, 0, 255))

    # BEST ESTIMATE
    draw_box(frame, x, y, 5, (255, 0, 0))

    draw_rect(frame, 0, 0, 320, 240, (0, 255, 0))

    cv.ShowImage("w0", frame)
    cv.WaitKey(1)
