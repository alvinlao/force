package force.pi.projection;

import force.pi.Point3D;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by Shaan on 03/04/2015.
 */
public class Shape implements Comparable<Shape> {
    public List<Polygon> polygons;
    List<Point3D> polygonCentroids;

    Point3D centroid;
    double zorder;

    public Shape(List<Polygon> polygons) {
        this.polygons = polygons;

        // Get polygon centroids
        centroid = new Point3D();
        for (Polygon polygon : polygons) {
            polygonCentroids.add(polygon.centroid);
        }

        // Shape centroid
        Centroid.calculate(centroid, polygonCentroids);
    }

    /**
     * Update shape with new camera position
     * @param camPos
     */
    void update(Point3D camPos) {
        for (Polygon polygon : polygons) {
            polygon.update(camPos);
        }

        // Sort polygons by z-order
        Collections.sort(polygons);

        // Distance to camera
        zorder = centroid.distance(camPos);
    }

    @Override
    public int compareTo(Shape other) {
        return (int) (this.zorder - other.zorder);
    }
}