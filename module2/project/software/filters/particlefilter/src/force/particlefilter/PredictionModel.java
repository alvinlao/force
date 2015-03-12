package force.particlefilter;

public class PredictionModel {
    private static float[] v = new float[2];

    /**
     * Attempt to predict the next state
     *
     * @param prevState best estimate of previous state
     * @param currentState best estimate of current state
     * @return best estimate of next state
     */
    public static float[] next(Particle prevState, Particle currentState) {
        return v;
    }
}
