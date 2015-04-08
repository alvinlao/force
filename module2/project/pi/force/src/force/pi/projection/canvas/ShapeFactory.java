package force.pi.projection.canvas;

import force.pi.Point3D;
import force.pi.projection.Polygon;
import force.pi.projection.Shape;

import java.util.List;

/**
 * Created by alvinlao on 15-04-05.
 */
public abstract class ShapeFactory {
    public static final int scale = 1;

    public abstract Shape build(float xOffset, float yOffset, float zOffset);
    public abstract Shape build();

    /**
     * Offset the shape
     * @param s
     * @param xOffset
     * @param yOffset
     * @param zOffset
     */
    public void applyOffset(Shape s, float xOffset, float yOffset, float zOffset) {
        for (Polygon polygon : s.polygons) {
            for (Point3D point : polygon.points) {
                point.x += xOffset;
                point.y += yOffset;
                point.z += zOffset;
            }
        }
    }

    /**
     * Scale a polygon's points
     * @param points
     */
    public void scalePoints(List<Point3D> points) {
        for (Point3D point : points) {
            Point3D.scale(scale, point);
        }
    }
}
