/**
 * A model of what we are tracking
 */
public class PointModel {
    public static final int MODEL_NOISE = 0;

    // [0, 1] Predict how much error our model has
    public static final float PREDICTION_ERROR = 0.05f;

    PointState state;

    public PointModel(int initialX, int initialY, float initialError) {
        state = new PointState();

        state.x = initialX;
        state.y = initialY;
        state.errorX = initialError;
        state.errorY = initialError;
    }

    /**
     * Make a prediction of what happens next
     */
    public void predict() {
        float stepX = 1;
        float stepY = 1;

        // Generate noise
        double noiseX = (2 * Math.random() - 1) * MODEL_NOISE;
        double noiseY = (2 * Math.random() - 1) * MODEL_NOISE;

        // Update state
        state.x = (int) (stepX * state.x + noiseX);
        state.y = (int) (stepY * state.y + noiseY);

        // Update error
        state.errorX = state.errorX * stepX * stepX + PREDICTION_ERROR;
        state.errorY = state.errorY * stepY * stepY + PREDICTION_ERROR;
    }

    /**
     * Update the model based on the newest measurement
     *
     * @param measurement measurement
     */
    public void update(Measurement measurement) {
        // Compute kalman gain
        float gainX = state.errorX / (state.errorX + measurement.accuracyRating);
        float gainY = state.errorY / (state.errorY + measurement.accuracyRating);

        // Update prediction
        state.x += gainX * (measurement.x - state.x);
        state.y += gainY * (measurement.y - state.y);

        // Update error
        state.errorX = (1 - gainX) * state.errorX;
        state.errorY = (1 - gainY) * state.errorY;
    }
}
