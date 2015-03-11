package force.particlefilter;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class ParticleFilter {
    // Number of particles to use. More is better.
    private static final int NUM_PARTICLES = 300;


    // Randoms
    private Random random;
    private WeightedRandom weightedRandom;

    // Best estimate
    private Particle best;

    // Measurements
    private Measurement previousMeanMeasurementPoint = new Measurement(Frame.WIDTH/2, Frame.HEIGHT/2, 0);
    private Measurement meanMeasurementPoint = new Measurement(Frame.WIDTH/2, Frame.HEIGHT/2, 0);

    // General movement direction
    private float[] motionVector = {0, 0};

    // Particles!
    private List<Particle> back_particles;
    private List<Particle> particles;

    // Particle weights
    private float[] particleWeights = new float[NUM_PARTICLES];


    public ParticleFilter() {
        // Random
        random = new Random();
        weightedRandom = new WeightedRandom();

        // Initialize lists
        back_particles = new ArrayList<Particle>();
        particles = new ArrayList<Particle>();

        // Initialize particles
        for (int i = 0; i < NUM_PARTICLES; ++i) {
            particles.add(new Particle());
            back_particles.add(new Particle());
        }
    }

    /**
     * Run the filter for one iteration
     *
     * @param measurements list of measurements
     * @return the estimate
     */
    public Point run(List<Measurement> measurements) {
        updateModel();
        updateMeasurement(measurements);

        updateBestEstimate();
        updateMotionVector(measurements);

        resample();

        return best;
    }


    /**
     * Predict next object location
     * 1) Move all particles according to motion vector
     * 2) Move all particles randomly (noise)
     */
    private void updateModel() {
        for (Particle p : particles) {
            p.walk(
                2 * random.nextDouble() - 1,
                2 * random.nextDouble() - 1,
                random.nextDouble() + 0.5,
                motionVector
            );
        }
    }


    /**
     * Use measurement to update weight of all particles
     */
    private void updateMeasurement(List<Measurement> measurements) {
        for (Particle p : particles) {
            p.updateWeight(measurements);
        }

        normalizeParticleWeights();
    }


    /**
     * Choose the best particle
     *
     * Current algorithm: Heaviest weighted particle
     * Alternative: Median around heaviest particle
     */
    private void updateBestEstimate() {
        best = particles.get(0);

        // Choose particle with the highest weight
        for (Particle p : particles) {
            if (p.weight > best.weight) {
                best = p;
            }
        }
    }


    /**
     * Normalize all particle weights
     */
    private void normalizeParticleWeights() {
        float total_weight = 0;
        for (Particle p : particles) {
            total_weight += p.weight;
        }

        for (Particle p : particles) {
            p.weight /= total_weight;
        }
    }


    /**
     * Redistribute the particles to weighted areas
     */
    private void resample() {
        // Swap particle lists
        List<Particle> temp = back_particles;
        back_particles = particles;
        particles = temp;

        // Set up weighted random
        for (int i = 0; i < NUM_PARTICLES; ++i) {
            particleWeights[i] = back_particles.get(i).weight;
        }

        weightedRandom.setWeights(particleWeights);

        // Perform resample
        for (int i = 0; i < NUM_PARTICLES; ++i) {
            int n = weightedRandom.next();
            particles.get(i).copy(back_particles.get(n));
        }
    }


    /**
     * Determine general direction the measurements moved toward
     *
     * NOTE: Motion vector is a unit vector
     * @param measurements list of measurements
     */
    private void updateMotionVector(List<Measurement> measurements) {
        updateMeanMeasurementPoint(measurements);

        motionVector[0] = meanMeasurementPoint.x - previousMeanMeasurementPoint.x;
        motionVector[1] = meanMeasurementPoint.y - previousMeanMeasurementPoint.y;
    }


    /**
     * Update the mean measured point
     * @param measurements
     */
    private void updateMeanMeasurementPoint(List<Measurement> measurements) {
        previousMeanMeasurementPoint.copy(meanMeasurementPoint);

        int x = 0;
        int y = 0;
        for (Measurement p : measurements) {
            x += p.x;
            y += p.y;
        }

        meanMeasurementPoint.x = x / measurements.size();
        meanMeasurementPoint.y = y / measurements.size();
    }
}
