package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.centroid.Centroid;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Shape implements Comparable<Shape> {
    public List<Polygon> polygons;

    public Point3D centroid;
    double zorder;

    public Shape(List<Polygon> polygons) {
        this.polygons = polygons;

        applyOffset(0, 0, 0);
    }


    /**
     * Update shape with new camera position
     * @param camPos
     */
    public void update(Point3D camPos) {
        for (Polygon polygon : polygons) {
            polygon.update(camPos);
        }

        // Sort polygons by z-order
        Collections.sort(polygons);

        // Distance to camera
        zorder = centroid.distance(camPos);
    }

    /**
     * Offset the shape
     * @param xOffset x offset
     * @param yOffset y offset
     * @param zOffset z offset
     */
    public void applyOffset(float xOffset, float yOffset, float zOffset) {
        for (Polygon polygon : polygons) {
            for (Point3D point : polygon.points) {
                point.x += xOffset;
                point.y += yOffset;
                point.z += zOffset;
            }
        }

        setCentroid(xOffset, yOffset, zOffset);
    }

    /**
     * Sets up the centroid with the offset
     * Assumes the applyOffset method of the ShapeFactory
     * class has already been called.
     */
    private void setCentroid(float x, float y, float z) {
        // Get polygon centroids
        centroid = new Point3D();
        centroid.x = x;
        centroid.y = y;
        centroid.z = z;
    }

    @Override
    public int compareTo(Shape other) {
        return (int) (1000 * (other.zorder - this.zorder));
    }
}
