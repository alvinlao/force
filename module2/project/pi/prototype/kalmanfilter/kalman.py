from array import array
from numpy import *
from point import *

class Kalman:
    def __init__(self, X, A, Z, R):
        self.X = X # The estimate
        self.A = A # Matrix to calculate results
        #self.P = array([[1], [1], [1], [1]]) # The error
        self.P = identity(4)

        self.Z = Z # The measurement
        self.R = R # The average noise
        self.G = dot(self.P, linalg.inv(self.P + self.R)) # The gain
