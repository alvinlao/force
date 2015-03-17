package force.pi.filters.kalman;

import force.pi.Point;

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
