package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.centroid.Centroid;

import java.awt.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Shaan on 03/04/2015.
 */
public class Polygon extends java.awt.Polygon implements Comparable<Polygon> {
	public static final float REAL_CONVERSION = 3333.33f;

    public List<Point3D> points;
    List<Point3D> projectedPoints;

    public Color color;

    Point3D centroid;
    double zorder;

    /**
     * Makes a polygon ready to be transformed into the 2d world
     *
     * @param points assumes points are in a order where a line is drawn from one point to the next
     *               Assumes points are NOT offset yet
     */
    public Polygon(List<Point3D> points, Color color) {
        this.points = points;

        // Initialize local list
        npoints = points.size();
        xpoints = new int[npoints];
        ypoints = new int[npoints];

        // Initialize projection points list
        this.projectedPoints = new ArrayList<Point3D>();
        for (Point3D point : points) {
            this.projectedPoints.add(new ProjectionPoint());
        }

        // Save color
        this.color = color;

        // Create centroid
        centroid = new Point3D();
        Centroid.calculate(centroid, points);
    }

    /**
     * Update all points based on camera position
     *
     * Perform point projection
     * Update polygon centroid
     * @param camPos Camera position
     */
    public void update(Point3D camPos) {
        for (int i = 0; i < npoints; ++i) {
            ProjectionPoint projectionPoint = (ProjectionPoint) projectedPoints.get(i);
            projectionPoint.update(points.get(i), camPos);

            // Update underlying draw class
            xpoints[i] = (int) (projectionPoint.x * REAL_CONVERSION);
            ypoints[i] = (int) (projectionPoint.y * REAL_CONVERSION);
        }

        // Update z-order
        zorder = centroid.distance(camPos);
    }

    @Override
    public int compareTo(Polygon other) {
        return (int) (1000 * (other.zorder - this.zorder));
    }
}
