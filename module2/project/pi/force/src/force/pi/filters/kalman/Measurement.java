package force.pi.filters.kalman;

public class Measurement extends Point {
    public static final int MAX_ACCURACY = 255 * 3;

    // (0, 1] : 0 is no noise. 1 is all noise
    float accuracyRating;

    public void set(int x, int y, int accuracy) throws Exception {
        this.x = x;
        this.y = y;

        this.accuracyRating = accuracy;

        // Make sure accuracy is [0, MAX_ACCURACY]
        if(accuracy < 0 || accuracy > MAX_ACCURACY)
            throw new Exception("Measurement accuracy out of bounds [0, " + MAX_ACCURACY + "]: " + accuracy);

        // Normalize
        this.accuracyRating /= MAX_ACCURACY;

        // Accuracy can't be 0!!
        this.accuracyRating = Math.max(0.001f, this.accuracyRating);
    }
}
