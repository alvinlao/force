package force.pi;

/**
 * 3D Point
 */
public class Point3D {
    public float x, y, z;

    /**
     * Default Point3D constructor
     */
    public Point3D() {
        x = 0;
        y = 0;
        z = 0;
    }

    /**
     * Point3D constructor
     * @param x - The x position
     * @param y - The y position
     * @param z - The z position
     */
    public Point3D(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /**
     * Copies the coordinates from another point to this point.
     * @param other - The point to copy from.
     */
    public void copy(Point3D other) {
        this.x = other.x;
        this.y = other.y;
        this.z = other.z;
    }

    /**
     * Computes the distance from one point to another point.
     * @param other - The point to compute the distance from.
     * @return
     */
    public double distance(Point3D other) {
        double dx = Math.pow((other.x - this.x), 2);
        double dy = Math.pow((other.y - this.y), 2);
        double dz = Math.pow((other.z - this.z), 2);
        return Math.sqrt(dx + dy + dz);
    }


    /**
     * Dot product
     * @param v
     * @param w
     * @return
     */
    public static double dot(Point3D v, Point3D w) {
        return (v.x * w.x) + (v.y * w.y) + (v.z * w.z);
    }

    /**
     * Scale a vector
     * Saves result in vector
     * @param s
     * @param v
     */
    public static void scale(double s, Point3D v) {
        v.x *= s;
        v.y *= s;
        v.z *= s;
    }

    /**
     * Subtract two vectors
     * @param res
     * @param v
     * @param w
     * @return
     */
    public static void sub(Point3D res, Point3D v, Point3D w) {
        res.x = v.x - w.x;
        res.y = v.y - w.y;
        res.z = v.z - w.z;
    }

    public static void add(Point3D res, Point3D v, Point3D w) {
        res.x = v.x + w.x;
        res.y = v.y + w.y;
        res.z = v.z + w.z;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Point3D point3D = (Point3D) o;

        if (Float.compare(point3D.x, x) != 0) return false;
        if (Float.compare(point3D.y, y) != 0) return false;
        if (Float.compare(point3D.z, z) != 0) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = (x != +0.0f ? Float.floatToIntBits(x) : 0);
        result = 31 * result + (y != +0.0f ? Float.floatToIntBits(y) : 0);
        result = 31 * result + (z != +0.0f ? Float.floatToIntBits(z) : 0);
        return result;
    }
}

