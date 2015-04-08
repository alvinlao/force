package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.centroid.Centroid;

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
    }

    /**
     * Sets up the centroid with the offset
     * Assumes the applyOffset method of the ShapeFactory
     * class has already been called.
     */
    public void setCentroid() {
        // Get polygon centroids
        centroid = new Point3D();
        polygonCentroids = new ArrayList<Point3D>();
        for (Polygon polygon : polygons) {
            polygon.setCentroid();
            polygonCentroids.add(polygon.centroid);
        }

        // Shape centroid
        Centroid.calculate(centroid, polygonCentroids);
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
        //System.out.println(zorder);
    }

    @Override
    public int compareTo(Shape other) {
        return (int) (other.zorder - this.zorder);
    }
}
