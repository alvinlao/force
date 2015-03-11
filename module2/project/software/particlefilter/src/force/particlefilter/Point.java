package force.particlefilter;

public class Point {
    public int x;
    public int y;
    public float weight;

    public Point() {
        x = 0;
        y = 0;
        weight = 0f;
    }

    public Point(int x, int y, float weight) {
        this.x = x;
        this.y = y;
        this.weight = weight;
    }

    /**
     * Copy another point's values into this point
     * @param other source point
     */
    void copy(Point other) {
        x = other.x;
        y = other.y;
        weight = other.weight;
    }

    /**
     * The distance between this and another point
     *
     * @param other point
     * @return distance
     */
    double distance(Point other) {
        double dx = Math.pow((other.x - this.x), 2);
        double dy = Math.pow((other.y - this.y), 2);
        return Math.sqrt(dx + dy);
    }
}
