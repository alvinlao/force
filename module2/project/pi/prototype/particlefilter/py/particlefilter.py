import math
from scipy.stats import rv_discrete
from particle import Particle


# Constants
MEASUREMENT_BIAS = 0.85
PREVIOUS_WALK_BIAS = 0.5

MAX_MEASUREMENT_DELTA = 765.0
FRAME_DIAGONAL = 400
MAX_DISTANCE = FRAME_DIAGONAL


"""
Particle filter prototype
"""
class ParticleFilter:

    """
    @param numparticles Number of particles used for filter
    """
    def __init__(self, frame_width, frame_height, numparticles=20):
        self.FRAME_WIDTH = frame_width
        self.FRAME_HEIGHT = frame_height
        self.N = numparticles

        # Motion vector
        self.prev_best = None
        self.mv = (0, 0)

        # Initialize particles
        self.particle_domain = range(self.N)
        self.particles = []
        self.back_particles = []
        for i in xrange(self.N):
            self.particles.append(Particle(self.FRAME_WIDTH, self.FRAME_HEIGHT, 1.0/numparticles))
            self.back_particles.append(Particle(self.FRAME_WIDTH, self.FRAME_HEIGHT, 1.0/numparticles))


    """
    Main call
    Run the filter on a set of measurements
    @param measurements [Point]
    @return estimated position
    """
    def run(self, measurements):
        self.update_movement()
        self.update_measurement(measurements)
        best = self.getbestestimate()

        # Update motion vector
        self.update_motion_vector(best, measurements)

        # Redistribute particles
        self.resample()

        return best


    """
    Get the best estimated position

    Must be called while self.particles weight is pdf
    @return (x, y)
    """
    def getbestestimate(self):
        best = None
        for particle in self.particles:
            if best is None or particle.weight > best.weight:
                best = particle

        return best


    """
    Move the particles
    Motion model: Guassian Random walk
    """
    def update_movement(self):
        for particle in self.particles:
            particle.walk(self.mv)


    """
    Update the particles weights with measurements
    @post particle weight is pdf
    @param measurements [Point]
    """
    def update_measurement(self, measurements):
        for particle in self.particles:
            particle.weight = self.calculate_weight(particle, measurements)
        
        self.normalize()

    """
    Determine the general vector of old to new measurements
    """
    def update_motion_vector(self, best, measurements):
        if(self.prev_best is not None):
            # Determine measurement center
            x, y = 0, 0
            for measurement in measurements:
                x += measurement.x
                y += measurement.y

            num_measurements = len(measurements)
            x /= num_measurements
            y /= num_measurements

            mvx = (x - self.prev_best.x) * PREVIOUS_WALK_BIAS
            mvy = (y - self.prev_best.y) * PREVIOUS_WALK_BIAS
            self.mv = (mvx, mvy)

        self.prev_best = best
        

    """
    Compute a new weight
    W'' = (1 - C) * W + C * W'

    W'' new weight
    W' measurement
    W current weight
    C constant controlling new vs old bias

    @param particle 
    @param measurements 
    """
    def calculate_weight(self, particle, measurements):
        measurementweight = 0
        for measurement in measurements:
            measurementweight += self.measurement_weight(particle, measurement)

        measurementweight /= len(measurements)

        newweight = (1 - MEASUREMENT_BIAS) * particle.weight + (MEASUREMENT_BIAS * measurementweight)

        return newweight


    """
    Normalize particle weights
    """
    def normalize(self):
        # Normalize particle weights
        total_weight = reduce(lambda a, v : a + v.weight, self.particles, 0)

        for particle in self.particles:
            particle.weight = particle.weight / total_weight

        
    """
    Redistribute particles using current particle weights
    as probability distribution
    """
    def resample(self):
         # Swap particle buffers
        self.particles, self.back_particles = self.back_particles, self.particles
   
        # Create rv_discrete
        particle_weights = map(lambda p : p.weight, self.back_particles)
        pdf = rv_discrete(values=(self.particle_domain, particle_weights))

        # Resample
        for n in xrange(self.N):
            i = pdf.rvs()
            self.particles[n].clone(self.back_particles[i])
       


    """
    Calculate effect of measurement on particle
    """
    def measurement_weight(self, particle, measurement):
        #res = 1 - ((1.0/MAX_DISTANCE) * self.distance(particle, measurement)) ** 2
        res = self.decay(self.distance(particle, measurement), MAX_DISTANCE/8.0)
        accuracy_weight = self.decay(measurement.delta/MAX_MEASUREMENT_DELTA, 1)
        res *= accuracy_weight
        return res


    def decay(self, x, maxx):
        return 1 - 0.5 * math.log(x/maxx + 1)

    """
    Euclidean distance
    @a, b point or particle
    """
    def distance(self, a, b):
        return math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2))
