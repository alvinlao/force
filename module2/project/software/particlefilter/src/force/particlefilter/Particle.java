package force.particlefilter;

import java.util.List;

public class Particle extends Point {
    // [0, 1] : How strongly do we take into account a new measurement?
    private static final float MEASUREMENT_BIAS = 0.75f;
    // [0, 1] : How much do we move the particle each update step
    private static final float MOVEMENT_BIAS = 0.5f;
    // [0, ~) : How much random noise do we add?
    private static final int RANDOM_DRIFT = 5;

    public Particle() {
        super(0, 0, 0);

        x = (int) (Frame.WIDTH * Math.random());
        y = (int) (Frame.HEIGHT * Math.random());
        weight = 1;
    }

    public Particle(int x, int y, float weight) {
        super(x, y, weight);
    }


    /**
     * Move the particle
     * @param rx random walk x direction [-1, 1]
     * @param ry random walk y direction [-1, 1]
     * @param rv [0.5, 1.5] amount of motion vector to take
     * @param motionVector unit direction
     */
    public void walk(double rx, double ry, double rv, float[] motionVector) {
        float dx = (float) (MOVEMENT_BIAS * rv * motionVector[0]);
        float dy = (float) (MOVEMENT_BIAS * rv * motionVector[1]);

        // Noise + movement
        this.x += (rx * RANDOM_DRIFT) + dx;
        this.y += (ry * RANDOM_DRIFT) + dy;

        assertBounds();
    }

    /**
     * Update this particle's weight based on new measurements
     * using this formula:
     *
     * new weight = (1-C) * previous weight + C * weight from measurements
     * C : MEASUREMENT_BIAS
     *
     * @param measurements
     */
    public void updateWeight(List<Measurement> measurements) {
        float totalMeasurementWeight = 0;
        for (Measurement measurement : measurements) {
            totalMeasurementWeight += measurement.weightOf(this);
        }

        float measurementWeight = totalMeasurementWeight / measurements.size();

        weight = (1 - MEASUREMENT_BIAS) * weight + MEASUREMENT_BIAS * measurementWeight;
    }

    /**
     * Make sure particle is inside the frame
     */
    private void assertBounds() {
        x = Math.min(x, Frame.WIDTH);
        y = Math.min(y, Frame.HEIGHT);
        x = Math.max(x, 0);
        y = Math.max(y, 0);
    }
}
