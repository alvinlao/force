import sys
import math
import random

def getnoise(noise, x, y):
    x += random.randint(-1, 1) * noise
    y += random.randint(-1, 1) * noise
    return (x, y)
    
def line(noise=0, accuracy=30):
    x = 0
    y = 0

    while(x < 320 or y < 240):
        if x < 320:
            x += 1
        if y < 240:
            y += 1

        tx, ty = getnoise(noise, x, y)
        print("{0} {1} {2}".format(tx, ty, accuracy))

def sine(noise=0, accuracy=30):
    for x in xrange(20, 300):
        y = int(100 * math.sin(x * math.pi / (320 / 3)) + 120)
        
        x, y = getnoise(noise, x, y)

        print("{0} {1} {2}".format(x, y, accuracy))


def box(noise=0, accuracy=30):
    x0 = 30
    x1 = 290
    y0 = 20
    y1 = 220

    # Up -> left line
    for y in xrange(y0, y1):
        x = x0
        print("{0} {1} {2}".format(x, y, accuracy))

    # right -> top line
    for x in xrange(x0, x1):
        y = y1
        print("{0} {1} {2}".format(x, y, accuracy))

    # down -> right line
    for y in reversed(xrange(y0, y1)):
        x = x1
        print("{0} {1} {2}".format(x, y, accuracy))

    # left -> bottom line
    for x in reversed(xrange(x0, x1)):
        y = y0
        print("{0} {1} {2}".format(x, y, accuracy))

    
#line()
sine(5)
#box()
