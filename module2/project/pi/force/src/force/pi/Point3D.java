package force.pi;

/**
 * 3D Point
 */
public class Point3D {
    public float x, y, z;

    public Point3D() {
        x = 0;
        y = 0;
        z = 0;
    }

    public Point3D(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    void copy(Point3D other) {
        this.x = other.x;
        this.y = other.y;
        this.z = other.z;
    }

    double distance(Point3D other) {
        double dx = Math.pow((other.x - this.x), 2);
        double dy = Math.pow((other.y - this.y), 2);
        double dz = Math.pow((other.z - this.z), 2);
        return Math.sqrt(dx + dy + dz);
    }
}

