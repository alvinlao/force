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
        float area_xy = 0;
        float area_xz = 0;
        float area_yz = 0;

        float yz = 0;
        float xy = 0;
        float xz = 0;

        boolean getX = !checkParallelToXAxis(points);
        boolean getY = !checkParallelToYAxis(points);
        boolean getZ = !checkParallelToZAxis(points);

        // Sum up all the points
        for (int i = 0; i < points.size(); i++) {
            Point3D current = points.get(i);
            // Get the next point in the list (if greater than the number of elements in the list
            // then the next reference will point to the first element in the list.
            Point3D next = points.get((i+1) % points.size());

            // Set up values
            float xx = current.x + next.x;
            float yy = current.y + next.y;
            float zz = current.z + next.z;

            if (!getX) {
                yz = (current.y * next.z) - (next.y * current.z);
                centroid.y += yy * yz;
                centroid.z += zz * yz;
            } else if (!getY) {
                xz = (current.x * next.z) - (next.x * current.z);
                centroid.x += xx * xz;
                centroid.z += zz * xz;
            } else if (!getZ) {
                xy = (current.x * next.y) - (next.x * current.y);
                centroid.x += xx * xy;
                centroid.y += yy * xy;
            } else {
                xy = (current.x * next.y) - (next.x * current.y);
                xz = (current.x * next.z) - (next.x * current.z);
                centroid.x += xx * xy;
                centroid.y += yy * xy;
            }

            // Do computation
            area_xy += xy;
            area_xz += xz;
            area_yz += yz;
        }

        area_xy = 1 / (3*area_xy);
        area_xz = 1 / (3*area_xz);
        area_yz = 1 / (3*area_yz);

        // Do final computation
        if (!points.isEmpty()) {
            if (!getX) {
                centroid.x = points.get(0).x;
                centroid.y = centroid.y * area_yz;
                centroid.z = centroid.z * area_yz;
            } else if (!getY) {
                centroid.x = centroid.x * area_xz;
                centroid.y = points.get(0).y;
                centroid.z = centroid.z * area_xz;
            } else if (!getZ) {
                centroid.x = centroid.x * area_xy;
                centroid.y = centroid.y * area_xy;
                centroid.z = points.get(0).z;
            } else {
                centroid.x = centroid.x * area_xy;
                centroid.y = centroid.y * area_xy;
                centroid.z = centroid.z * area_xz;
            }
        }
    }

    /**
     * Checks if the list of points is parallel to the x-axis
     * @param points The list of points.
     * @return true if the list of points is parallel to the x-axis
     */
    private static boolean checkParallelToXAxis(List<Point3D> points) {
        boolean par_to_x = true;

        if (!points.isEmpty()) {
            float x = points.get(0).x;

            // Loop through remaining points. If one has a different x value than
            // the value in x, then it is not parallel.
            for (int i = 1; i < points.size(); i++) {
                if (x != points.get(i).x) {
                    par_to_x = false;
                }
            }
        }

        return par_to_x;
    }

    /**
     * Checks if the list of points is parallel to the y-axis
     * @param points The list of points.
     * @return true if the list of points is parallel to the y-axis
     */
    private static boolean checkParallelToYAxis(List<Point3D> points) {
        boolean par_to_y = true;

        if (!points.isEmpty()) {
            float y = points.get(0).y;

            // Loop through remaining points. If one has a different x value than
            // the value in x, then it is not parallel.
            for (int i = 1; i < points.size(); i++) {
                if (y != points.get(i).y) {
                    par_to_y = false;
                }
            }
        }

        return par_to_y;
    }

    /**
     * Checks if the list of points is parallel to the z-axis
     * @param points The list of points.
     * @return true if the list of points is parallel to the z-axis
     */
    private static boolean checkParallelToZAxis(List<Point3D> points) {
        boolean par_to_z = true;

        if (!points.isEmpty()) {
            float z = points.get(0).z;

            // Loop through remaining points. If one has a different x value than
            // the value in x, then it is not parallel.
            for (int i = 1; i < points.size(); i++) {
                if (z != points.get(i).z) {
                    par_to_z = false;
                }
            }
        }

        return par_to_z;
    }

    public static void testCalculate() {
        BoxFactory box = new BoxFactory();
        Shape shape = box.build();
        for (int i = 0; i < shape.polygons.size(); i++) {
            List<Point3D> points = shape.polygons.get(i).points;
            for (int j = 0; j < points.size(); j++) {
                System.out.println(points.get(j).x + " " + points.get(j).y + " " + points.get(j).z);
            }
            Point3D centroid = new Point3D();
            calculate(centroid, points);

            System.out.println("Centroid: " + centroid.x + " " + centroid.y + " " + centroid.z);
        }
    }
}
