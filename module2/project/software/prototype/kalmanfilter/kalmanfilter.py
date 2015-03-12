import math
import numpy as np
from numpy.distutils import npy_pkg_config
from particle import Particle
from point import *
from kalman import *

class KalmanFilter:
    def __init__(self, frame_width, frame_height, kalman_params):
        self.FRAME_WIDTH = frame_width
        self.FRAME_HEIGHT = frame_height
        self.kalman = kalman_params

    def run(self):
        self.kf_predict()
        self.kf_update()

    def kf_predict(self):
        self.kalman.X = np.dot(self.kalman.A, self.kalman.X)
        self.kalman.P = self.kalman.A.dot(self.kalman.P).dot(np.transpose(self.kalman.A))

    def kf_update(self):
        inverse = self.kalman.P + self.kalman.R
        #print inverse
        self.kalman.G = np.dot(self.kalman.P, np.linalg.inv(inverse))
        self.kalman.P = np.dot(np.identity(4) - self.kalman.G, self.kalman.P)
        self.kalman.X = self.kalman.X + np.dot(self.kalman.G, self.kalman.Z - self.kalman.X)

    def get_position(self):
        pos = Point(0, 0, 0)
        return pos