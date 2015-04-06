package force.pi.projection.centroid;

import force.pi.Point3D;
import force.pi.projection.Shape;
import force.pi.projection.canvas.BoxFactory;

import java.util.List;

/**
 * Created by alvinlao on 15-04-05.
 */
public class Centroid {
    /**
     * Calculate centroid point
     * Based off of formula in this question on StackOverflow:
     * http://stackoverflow.com/questions/2355931/compute-the-centroid-of-a-3d-planar-polygon
     *
     * @param centroid Store result in this object
     * @param points list of points in either clockwise or counterclockwise order
     */
    public static void calculate(Point3D centroid, List<Point3D> points) {
        Point3D current;
        Point3D next;
        float area_xy = 0;
        float area_xz = 0;
        float xy = 0;
        float xz = 0;
        float xx = 0;
        float yy = 0;
        float zz = 0;

        // Sum up all the points
        for (int i = 0; i < points.size(); i++) {
            current = points.get(i);
            // Get the next point in the list (if greater than the number of elements in the list
            // then the next reference will point to the first element in the list.
            next = points.get((i+1) % points.size());

            // Set up values
            xx = current.x + next.x;
            yy = current.y + next.y;
            zz = current.z + next.z;
            xy = (current.x * next.y) - (next.x * current.y);
            xz = (current.x * next.z) - (next.x * current.z);

            // Do computation
            area_xy += xy;
            area_xz += xz;
            centroid.x += xx * xy;
            centroid.y += yy * xy;
            centroid.z += zz * xz;
        }

        // Do final computation
        area_xy = area_xy / 2;
        area_xz = area_xz / 2;
        centroid.x = centroid.x / (6*area_xy);
        centroid.y = centroid.y / (6*area_xy);
        centroid.z = centroid.z / (6*area_xz);
    }

    private static void testCalculate() {
        BoxFactory box = new BoxFactory();
        Shape shape = box.build();
        for (int i = 0; i < shape.polygons.size(); i++) {
            List<Point3D> points = shape.polygons.get(i).points;
            Point3D centroid = new Point3D();
            calculate(centroid, points);

            System.out.println(centroid.x + " " + centroid.y + " " + centroid.z);
        }
    }
}
