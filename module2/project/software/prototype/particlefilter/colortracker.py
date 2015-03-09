from point import Point 
import numpy
from colormath.color_objects import LabColor, sRGBColor
from colormath.color_conversions import convert_color
from colormath.color_diff import delta_e_cie1976


# Constants
WINDOW_SIZE = 40
BLOCK_SIZE = 3

"""
Color tracker
"""
class ColorTracker:
    points = []

    """
    @param frame_width 
    @param frame_height
    @param color the reference color to track
    @param n number of points to track
    """
    def __init__(self, frame_width, frame_height, color, n=1):
        self.FRAME_WIDTH = frame_width
        self.FRAME_HEIGHT = frame_height
        self.reference_color = color
        self.n = n

        self.points = []
        for i in xrange(self.FRAME_WIDTH/BLOCK_SIZE):
            for j in xrange(self.FRAME_HEIGHT/BLOCK_SIZE):
                self.points.append(Point())
        
        self.deltas = numpy.zeros((320, 240))


    def track(self, frame):
        pid = 0

        # Delta of each pixel in the frame
        for j in xrange(self.FRAME_WIDTH):
            for i in xrange(self.FRAME_HEIGHT):
                pixel = frame[i, j]
                self.deltas[j, i] = self.poorcolordifference(self.reference_color, pixel)
                #print(i, j, pixel, self.deltas[i, j])

        # Find color difference with reference color for each block
        for blockX in xrange(self.FRAME_WIDTH/BLOCK_SIZE):
            for blockY in xrange(self.FRAME_HEIGHT/BLOCK_SIZE):
                blockXOffset = blockX * BLOCK_SIZE
                blockYOffset = blockY * BLOCK_SIZE
                delta = 0
                for i in xrange(BLOCK_SIZE):
                    for j in xrange(BLOCK_SIZE):
                        delta += self.deltas[blockXOffset + i, blockYOffset + j]

                point = self.points[pid]
                point.x = blockXOffset
                point.y = blockYOffset
                point.delta = delta / (BLOCK_SIZE ** 2)
                pid += 1


        # Sort points
        self.points.sort(lambda a, b : int(a.delta - b.delta))

        # Return best N results
        return self.points[:self.n]


    """
    Computationally simple color difference
    Assuming reference color is white
    @param rgb1 reference color
    @param rgb2 compare color
    """
    def poorcolordifference(self, rgb1, rgb2):
        d = 0
        for c in xrange(3):
            d += rgb1[c] - rgb2[c]

        return d

        
    """
    L*ab color difference
    """
    def colordifference(self, rgb1, rgb2):
        rgb1 = sRGBColor(rgb1[0], rgb1[1], rgb1[2])
        rgb2 = sRGBColor(rgb2[0], rgb2[1], rgb2[2])
        c1 = convert_color(rgb1, LabColor)
        c2 = convert_color(rgb2, LabColor)

        return delta_e_cie1976(c1, c2)
