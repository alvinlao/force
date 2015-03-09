from random import *
from numpy.random import normal

# Constants
WALK_SCALE = 6

class Particle:
    def __init__(self, maxX, maxY, weight):
        self.x = int(random() * maxX)
        self.y = int(random() * maxY)
        self.maxX = maxX
        self.maxY = maxY
        self.weight = weight

    """
    Do a guassian random walk
    @param mv movement vector 2 tuple
    """
    def walk(self, mv):
        self.x += int(normal(scale=WALK_SCALE) + mv[0])
        self.y += int(normal(scale=WALK_SCALE) + mv[1])

        # Bounds
        self.assert_bounds()


    """
    Make sure particle is inside bounds
    """
    def assert_bounds(self):
        self.x = max(self.x, 0)
        self.y = max(self.y, 0)
        self.x = min(self.x, self.maxX)
        self.y = min(self.y, self.maxY)

    def update_weight(self, measurement):
        pass

    def clone(self, particle):
        self.x = particle.x
        self.y = particle.y
        self.weight = particle.weight
        self.maxX = particle.maxX
        self.maxY = particle.maxY
