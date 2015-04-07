package force.pi.projection;

import force.pi.Point3D;
import force.pi.projection.canvas.ShapeFactory;

/**
 * Created by alvinlao on 15-04-05.
 */
public class ProjectionPoint extends Point3D {
    // The closest the camera can get to the object
    static final int SLACK = 20;

    // Define the plane we are projecting on to.
    static final Point3D normal = new Point3D(0, 0, 1);

    // Store intermediate results
    Point3D l = new Point3D();
    Point3D v = new Point3D();

    /**
     * Project a point onto the z=0 plane
     *
     * @param original original point
     * @param cameraPosition camera position
     */
    public void update(Point3D original, Point3D cameraPosition) {
        // Edge case: Camera below object height
        if (cameraPosition.z <= ShapeFactory.scale + SLACK) {
            cameraPosition.z = ShapeFactory.scale + SLACK;
        }

        sub(l, original, cameraPosition);
        double a = -1.0 * dot(normal, original) / dot(normal, l);
        scale(a, l);
        add(v, l, original);

        x = v.x;
        y = v.y;
        z = v.z;
    }
}
