package force.particlefilter;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * Particle Filter
 *
 * Goal:
 * Attempt to reduce raw measurement noise and produce a more accurate estimation
 *
 * This particle filter is designed specifically for tracking
 * a writing pen. See the prediction model for more details.
 *
 */
public class ParticleFilter {
    // Number of particles to use. More is better.
    private static final int NUM_PARTICLES = 300;


    // Randoms
    private Random random;
    private WeightedRandom weightedRandom;

    // Best estimate
    private Particle previousBest = new Particle();
    private Particle best = new Particle();

    // Measurements
    private Measurement previousProcessedMeasurementPoint = new Measurement(Frame.WIDTH/2, Frame.HEIGHT/2, 0);
    private Measurement processedMeasurementPoint = new Measurement(Frame.WIDTH/2, Frame.HEIGHT/2, 0);

    // Our state model
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

        processMeasurements(measurements);
        updateMeasurement();

        updateBestEstimate();
        updateMotionVector();

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
            p.predict(
                    2 * random.nextDouble() - 1,
                    2 * random.nextDouble() - 1,
                    random.nextDouble() + 0.5,
                    motionVector
            );
        }
    }


    /**
     * Process the incoming measurements
     *
     * TODO Currently just performs an average of all measurements. Use a more sophisticated algorithm.
     *
     * @param measurements measurements
     */
    private void processMeasurements(List<Measurement> measurements) {
        previousProcessedMeasurementPoint.copy(processedMeasurementPoint);

        // Average all measurements...
        processedMeasurementPoint.x = 0;
        processedMeasurementPoint.y = 0;
        processedMeasurementPoint.weight = 0;
        for (Measurement measurement : measurements) {
            processedMeasurementPoint.x += measurement.x;
            processedMeasurementPoint.y += measurement.y;
            processedMeasurementPoint.weight += measurement.weight;
        }

        processedMeasurementPoint.x /= measurements.size();
        processedMeasurementPoint.y /= measurements.size();
        processedMeasurementPoint.weight /= measurements.size();
    }


    /**
     * Use measurement to update weight of all particles
     */
    private void updateMeasurement() {
        for (Particle p : particles) {
            p.updateWeight(processedMeasurementPoint);
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
        Particle candidate = particles.get(0);

        // Choose particle with the highest weight
        for (Particle p : particles) {
            if (p.weight > candidate.weight) {
                candidate = p;
            }
        }

        previousBest.copy(best);
        best.copy(candidate);
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
     */
    private void updateMotionVector() {
        motionVector = PredictionModel.next(previousBest, best);

        motionVector[0] = processedMeasurementPoint.x - previousProcessedMeasurementPoint.x;
        motionVector[1] = processedMeasurementPoint.y - previousProcessedMeasurementPoint.y;
    }
}
