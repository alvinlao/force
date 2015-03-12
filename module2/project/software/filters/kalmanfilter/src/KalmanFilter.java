/**
 * Filter noise from measurements
 */
public class KalmanFilter {
    PointModel model;

    public KalmanFilter() {
        // Create our model
        int initialX = Frame.WIDTH / 2;
        int initialY = Frame.HEIGHT / 2;
        float initialError = 0.3f;

        model = new PointModel(initialX, initialY, initialError);
    }

    public Point run(Measurement measurement) {
        model.predict();
        model.update(measurement);

        return model.state;
    }
}
