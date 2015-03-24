package force.pi.filters.kalman;

import force.pi.Point;

/**
 * A kalman filter state encapsulation for a point
 *
 */
public class PointState extends Point {
    float errorX, errorY;

    public PointState() {
        this(0, 0, 0);
    }

    public PointState(int x, int y, float error) {
        super(x, y);
        this.errorX = error;
        this.errorY = error;
    }

}
