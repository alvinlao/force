package force.pi.filters.kalman;

import force.pi.Frame;
import force.pi.Measurement;
import force.pi.Point;

/**
 * Filter noise from measurements
 */
public class KalmanFilter {
    public static final int MODEL_NOISE = 0;

    // [0, 1] Predict how much error our model has
    public static final float PREDICTION_ERROR = 0.05f;

    PointState state;

    public KalmanFilter() {
        // Create our model
        int initialX = Frame.WIDTH / 2;
        int initialY = Frame.HEIGHT / 2;
        float initialError = 0.3f;

        state = new PointState();

        state.x = initialX;
        state.y = initialY;
        state.errorX = initialError;
        state.errorY = initialError;
    }

    public Point run(Measurement measurement) {
        predict();
        update(measurement);

        return state;
    }

    /**
     * Make a prediction of what happens next
     */
    public void predict() {
        // Predict the object stays in the same place
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
        // Compute Kalman gain
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
