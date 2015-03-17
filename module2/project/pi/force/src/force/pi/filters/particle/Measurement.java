package force.pi.filters.particle;

public class Measurement extends Point {
    private static final int MAX_MEASUREMENT_WEIGHT = 255 * 3;

    // [0, 1] : How much do we care about the measurement's accuracy? Higher = care more
    private static final float ACCURACY_BIAS = 0.85f;

    public Measurement() {
        this(0, 0, 0);
    }

    /**
     * Measurement constructor
     *
     * @param x x
     * @param y y
     * @param weight [0, MAX_MEASUREMENT_WEIGHT] 0 is more accurate
     */
    public Measurement(int x, int y, float weight) {
        super(x, y, weight);

        this.weight = Math.min(weight, MAX_MEASUREMENT_WEIGHT);
        this.weight = Math.max(weight, 0);
    }

    /**
     * Determine the weight of a particle based on measurement
     * Based on distance of particle from measurement and weight of this measurement
     *
     * @param p particle
     * @return weight [0, 1]
     */
    public float weightOf(Particle p) {
        // The 8 is magic (Chosen so that the x-intercept is close to Frame.DIAGONAL)
        double distance = decay(distance(p), Frame.DIAGONAL/8.0);
        double accuracy = ACCURACY_BIAS * decay(weight/MAX_MEASUREMENT_WEIGHT, 1);

        return (float) (distance * accuracy);
    }

    /**
     * Our decay formula
     *
     * y = 1 - (0.5 * log(x/maxX + 1))
     *
     * @param x input [0, maxX]
     * @param maxX Max domain range
     * @return y [0, 1]
     */
    private double decay(double x, double maxX) {
        return 1 - (0.5f * Math.log(x / maxX + 1));
    }
}
