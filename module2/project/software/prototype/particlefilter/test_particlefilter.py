import matplotlib.pyplot as plt
import math
from particlefilter import *
from point import Point

# Print all particle locations
def printparticles(particles):
    print("Particles:")
    for particle in particles:
        print(particle.x, particle.y, particle.weight)
    

pf = ParticleFilter(320, 240, 300)

#printparticles(pf.particles)

# Create measurements
print("Measurement:")
measurements = [Point(20, 20, 10)]
#measurements = [Point(100, 100, 10)]
for measurement in measurements:
    print(measurement.x, measurement.y)

# Gather particles
print("Run:")
for i in xrange(30):
    best = pf.run(measurements)
    #print(best.x, best.y)

# Move object
measurements = [Point(30, 30, 10), Point(10, 10, 500)]
#measurements = [Point(30, 30, 10)]
for i in xrange(5):
    best = pf.run(measurements)
    print("Best:")
    print(best.x, best.y)

x = []
y = []
s = []
for particle in pf.particles:
    x.append(particle.x)
    y.append(particle.y)
    s.append(math.pi * (500 * particle.weight)**2)

plt.scatter(x, y, s=s)
plt.xlim(0, 320)
plt.ylim(0, 240)
plt.show()
