package force.particlefilter;

import java.util.List;

public class Particle extends Point {
    // [0, 1] : How strongly do we take into account a new measurement?
    private static final float MEASUREMENT_BIAS = 0.10f;
    // [0, 1] : How much do we move the particle each update step
    private static final float MOVEMENT_BIAS = 0.5f;
    // [0, ~) : How much random noise do we add?
    private static final int RANDOM_DRIFT = 10;

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
     * Predict where the real object will be
     * Move the particle there
     * Add noise
     *
     * @param rx random walk x direction [-1, 1]
     * @param ry random walk y direction [-1, 1]
     * @param rv [0.5, 1.5] amount of motion vector to take
     * @param motionVector unit direction
     */
    public void predict(double rx, double ry, double rv, float[] motionVector) {
        int dx = (int) Math.ceil(MOVEMENT_BIAS * rv * motionVector[0]);
        int dy = (int) Math.ceil(MOVEMENT_BIAS * rv * motionVector[1]);

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
     * @param measurement
     */
    public void updateWeight(Measurement measurement) {
        weight = (1 - MEASUREMENT_BIAS) * weight + MEASUREMENT_BIAS * measurement.weightOf(this);
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
